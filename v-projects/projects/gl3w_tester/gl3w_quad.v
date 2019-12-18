import prime31.sdl2
import prime31.gl3w.gl41 as gl
import prime31.gl3w
import time
import os

struct AppState {
mut:
	program u32
	vert_pos_loc int
	vao u32
	vbo u32
	ibo u32
}

fn main() {
	mut state := &AppState{}
	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_JOYSTICK)

    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_FLAGS, C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_PROFILE_MASK, C.SDL_GL_CONTEXT_PROFILE_CORE)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MAJOR_VERSION, 3)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MINOR_VERSION, 2)

	C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
	C.SDL_GL_SetAttribute(C.SDL_GL_DEPTH_SIZE, 24)
	C.SDL_GL_SetAttribute(C.SDL_GL_STENCIL_SIZE, 8)

	window_flags := C.SDL_WINDOW_OPENGL | C.SDL_WINDOW_RESIZABLE | C.SDL_WINDOW_ALLOW_HIGHDPI
	window := C.SDL_CreateWindow("V gl3w", C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED, 500, 300, window_flags)
	gl_context := C.SDL_GL_CreateContext(window)

	C.SDL_GL_MakeCurrent(window, gl_context)
	C.SDL_GL_SetSwapInterval(1) // Enable vsync

	gl3w.initialize()

	state.create_shader()
	state.create_buffers()

	mut alive := true
	for alive {
		ev := SDL_Event{}
		for 0 < C.SDL_PollEvent(&ev) {
			match int(ev.@type) {
				C.SDL_QUIT {
					alive = false
					break
				}
				else {}
			}
		}

		C.glClearColor(0.1, 0.0, 0.2, 1.0)
		C.glClear(C.GL_COLOR_BUFFER_BIT | C.GL_DEPTH_BUFFER_BIT | C.GL_STENCIL_BUFFER_BIT)
		state.draw_quad()
		C.SDL_GL_SwapWindow(window)
	}

    C.SDL_GL_DeleteContext(gl_context)
    C.SDL_DestroyWindow(window)
    C.SDL_Quit()
}

fn (state mut AppState) create_shader() {
	// vertex shader
	vert := gl.create_shader(C.GL_VERTEX_SHADER)
	vert_src := '#version 150\nin vec2 LVertexPos2D;\nvoid main() { gl_Position = vec4(LVertexPos2D.x, LVertexPos2D.y, 0, 1); }'
	C.glShaderSource(vert, 1, &vert_src.str, 0)
	C.glCompileShader(vert)
	if gl.get_shader_compile_status(vert) == 0 {
		log := gl.get_shader_info_log(vert)
		println('shader $vert compilation failed')
		println(log)
		exit(1)
	}

	// fragment shader
	frag := gl.create_shader(C.GL_FRAGMENT_SHADER)
	frag_src := '#version 150\nout vec4 LFragment; void main() { LFragment = vec4(0.9, 0.1, 0.1, 1.0); }'
	C.glShaderSource(frag, 1, &frag_src.str, 0)
	C.glCompileShader(frag)
	if gl.get_shader_compile_status(frag) == 0 {
		log := gl.get_shader_info_log(frag)
		println('fragment $frag shader compilation failed')
		println(log)
		exit(1)
	}

	// link shaders
	shader_program := gl.create_program()
	C.glAttachShader(shader_program, vert)
	C.glAttachShader(shader_program, frag)
	C.glLinkProgram(shader_program)

	// check for linking errors
	success := gl.get_program_link_status(shader_program)
	if success == 0 {
		log := gl.get_program_info_log(shader_program)
		println('shader compilation failed')
		println('vertex source = $vert_src')
		println('fragment source = $frag_src')
		println(log)
		exit(1)
	}

	state.program = shader_program
	state.vert_pos_loc = C.glGetAttribLocation(state.program, 'LVertexPos2D')
	if state.vert_pos_loc == -1 {
		println('LVertexPos2D is not a valid glsl program variable!')
		exit(1)
	}

	name, size, typ := gl.get_active_attrib(state.program, 0)
	println('att: $name')

	prog_res := gl.get_programiv(state.program, C.GL_LINK_STATUS)
	println('prog link res=$prog_res')

	println('gl version=${gl.get_string(C.GL_VERSION)}')
	println('glsl version=${gl.get_string(C.GL_SHADING_LANGUAGE_VERSION)}')
	println('vendor=${gl.get_string(C.GL_VENDOR)}')
	println('renderer=${gl.get_string(C.GL_RENDERER)}')
}

fn (state mut AppState) create_buffers() {
	vertex_data := [
		-0.5, -0.5,
		0.5, -0.5,
		0.5,  0.5,
		-0.5,  0.5
	]!
	index_data := [
		u16(0), 1, 2, 3
	]!

	state.vao = gl.gen_vertex_array()
	C.glBindVertexArray(state.vao)

	// state.vbo = gl.gen_buffer()
	C.glGenBuffers(1, &state.vbo)
	C.glBindBuffer(C.GL_ARRAY_BUFFER, state.vbo)
	gl.buffer_data_f32(C.GL_ARRAY_BUFFER, vertex_data, C.GL_STATIC_DRAW)
	// C.glBufferData(C.GL_ARRAY_BUFFER, vertex_data.len * sizeof(f32), vertex_data.data, C.GL_STATIC_DRAW)

	state.ibo = gl.gen_buffer()
	C.glBindBuffer(C.GL_ELEMENT_ARRAY_BUFFER, state.ibo)
	gl.buffer_data_u16(C.GL_ELEMENT_ARRAY_BUFFER, index_data, C.GL_STATIC_DRAW)
	// C.glBufferData(C.GL_ELEMENT_ARRAY_BUFFER, index_data.len * sizeof(u32), index_data.data, C.GL_STATIC_DRAW)
}

fn (state AppState) draw_quad() {
	C.glUseProgram(state.program)

	C.glBindVertexArray(state.vao)
	C.glEnableVertexAttribArray(state.vert_pos_loc)
	C.glBindBuffer(C.GL_ARRAY_BUFFER, state.vbo)
	C.glVertexAttribPointer(state.vert_pos_loc, 2, C.GL_FLOAT, C.GL_FALSE, 2 * sizeof(f32), C.NULL)

	C.glBindBuffer(C.GL_ELEMENT_ARRAY_BUFFER, state.ibo)
	C.glDrawElements(C.GL_TRIANGLE_FAN, 4, C.GL_UNSIGNED_SHORT, C.NULL)

	C.glDisableVertexAttribArray(state.vert_pos_loc)

	C.glUseProgram(0)
}


struct Mesh {
pub:
	program u32
	vao u32
	vbo u32
	ibo u32
}