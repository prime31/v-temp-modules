import prime31.sdl2
import prime31.gl3w
import prime31.gl3w.gl41 as gl
import prime31.math
import time
import os

struct AppState {
mut:
	program u32
	mvp_uni int
	vert_pos_loc int
	vert_col_loc int

	cube_vao u32 = u32(0)
	cube_vbo u32
	cube_col_vbo u32

	rot int
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
	window := C.SDL_CreateWindow("V gl3w", C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED, 1024, 768, window_flags)
	gl_context := C.SDL_GL_CreateContext(window)

	C.SDL_GL_MakeCurrent(window, gl_context)
	C.SDL_GL_SetSwapInterval(1) // Enable vsync

	gl3w.initialize()

	state.create_shader()

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

		C.glClearColor(0.4, 0.0, 0.0, 1.0)
		C.glClear(C.GL_COLOR_BUFFER_BIT | C.GL_DEPTH_BUFFER_BIT | C.GL_STENCIL_BUFFER_BIT)
		state.draw_cube()
		C.SDL_GL_SwapWindow(window)
	}

	C.SDL_GL_DeleteContext(gl_context)
	C.SDL_DestroyWindow(window)
	C.SDL_Quit()
}

fn (state mut AppState) create_shader() {
	// vertex shader
	vert := gl.create_shader(.vertex_shader)
	vert_src := '#version 150\nin vec3 LVertexPos3D;\nin vec3 VertexColor;\nout vec3 FragmentColor;\nuniform mat4 MVP;\nvoid main() { FragmentColor = VertexColor; gl_Position = MVP * vec4(LVertexPos3D.xyz, 1.0); }'
	C.glShaderSource(vert, 1, &vert_src.str, 0)
	C.glCompileShader(vert)
	if gl.get_shader_compile_status(vert) == 0 {
		log := gl.get_shader_info_log(vert)
		println('shader $vert compilation failed')
		println(log)
		exit(1)
	}

	// fragment shader
	frag := gl.create_shader(.fragment_shader)
	frag_src := '#version 150\nin vec3 FragmentColor;\nout vec3 LFragment; void main() { LFragment = FragmentColor; }'
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
	state.vert_pos_loc = glGetAttribLocation(state.program, 'LVertexPos3D')
	if state.vert_pos_loc == -1 {
		println('LVertexPos3D is not a valid glsl program variable!')
		exit(1)
	}

	state.vert_col_loc = glGetAttribLocation(state.program, 'VertexColor')
	if state.vert_col_loc == -1 {
		println('VertexColor is not a valid glsl program variable!')
		exit(1)
	}

	state.mvp_uni = glGetUniformLocation(state.program, c'MVP')
	if state.mvp_uni == -1 {
		println('MVP is not a valid glsl program uniform!')
		exit(1)
	}

	prog_res := gl.get_programiv(state.program, C.GL_LINK_STATUS)
	println('prog link res=$prog_res')

	println('gl version=${gl.get_string(C.GL_VERSION)}')
	println('glsl version=${gl.get_string(C.GL_SHADING_LANGUAGE_VERSION)}')
	println('vendor=${gl.get_string(C.GL_VENDOR)}')
	println('renderer=${gl.get_string(C.GL_RENDERER)}')
}

[live]
fn (state mut AppState) draw_cube() {
	if state.cube_vao == 0 {
		vertices := [
			-0.7,-0.7,-0.7, // triangle 1 : begin
			-0.7,-0.7, 0.7,
			-0.7, 0.7, 0.7, // triangle 1 : end
			0.7, 0.7,-0.7, // triangle 2 : begin
			-0.7,-0.7,-0.7,
			-0.7, 0.7,-0.7, // triangle 2 : end
			0.7,-0.7, 0.7,
			-0.7,-0.7,-0.7,
			0.7,-0.7,-0.7,
			0.7, 0.7,-0.7,
			0.7,-0.7,-0.7,
			-0.7,-0.7,-0.7,
			-0.7,-0.7,-0.7,
			-0.7, 0.7, 0.7,
			-0.7, 0.7,-0.7,
			0.7,-0.7, 0.7,
			-0.7,-0.7, 0.7,
			-0.7,-0.7,-0.7,
			-0.7, 0.7, 0.7,
			-0.7,-0.7, 0.7,
			0.7,-0.7, 0.7,
			0.7, 0.7, 0.7,
			0.7,-0.7,-0.7,
			0.7, 0.7,-0.7,
			0.7,-0.7,-0.7,
			0.7, 0.7, 0.7,
			0.7,-0.7, 0.7,
			0.7, 0.7, 0.7,
			0.7, 0.7,-0.7,
			-0.7, 0.7,-0.7,
			0.7, 0.7, 0.7,
			-0.7, 0.7,-0.7,
			-0.7, 0.7, 0.7,
			0.7, 0.7, 0.7,
			-0.7, 0.7, 0.7,
			0.7,-0.7, 0.7
		]!

		state.cube_vao = gl.gen_vertex_array()
		glBindVertexArray(state.cube_vao)

		state.cube_vbo = gl.gen_buffer()
		glBindBuffer(C.GL_ARRAY_BUFFER, state.cube_vbo)
		glBufferData(C.GL_ARRAY_BUFFER, vertices.len * sizeof(f32), vertices.data, C.GL_STATIC_DRAW)

		cols := [
			0.583,  0.771,  0.014,
			0.609,  0.115,  0.436,
			0.327,  0.483,  0.844,
			0.822,  0.569,  0.201,
			0.435,  0.602,  0.223,
			0.310,  0.747,  0.185,
			0.597,  0.770,  0.761,
			0.559,  0.436,  0.730,
			0.359,  0.583,  0.152,
			0.483,  0.596,  0.789,
			0.559,  0.861,  0.639,
			0.195,  0.548,  0.859,
			0.014,  0.184,  0.576,
			0.771,  0.328,  0.970,
			0.406,  0.615,  0.116,
			0.676,  0.977,  0.133,
			0.971,  0.572,  0.833,
			0.140,  0.616,  0.489,
			0.997,  0.513,  0.064,
			0.945,  0.719,  0.592,
			0.543,  0.021,  0.978,
			0.279,  0.317,  0.505,
			0.167,  0.620,  0.077,
			0.347,  0.857,  0.137,
			0.055,  0.953,  0.042,
			0.714,  0.505,  0.345,
			0.783,  0.290,  0.734,
			0.722,  0.645,  0.174,
			0.302,  0.455,  0.848,
			0.225,  0.587,  0.040,
			0.517,  0.713,  0.338,
			0.053,  0.959,  0.120,
			0.393,  0.621,  0.362,
			0.673,  0.211,  0.457,
			0.820,  0.883,  0.371,
			0.982,  0.099,  0.879
		]!
		state.cube_col_vbo = gl.gen_buffer()
		glBindBuffer(C.GL_ARRAY_BUFFER, state.cube_col_vbo)
		glBufferData(C.GL_ARRAY_BUFFER, cols.len * sizeof(f32), cols.data, C.GL_STATIC_DRAW)
	}

	glEnable(C.GL_DEPTH_TEST)
	glDepthFunc(C.GL_LESS)

	glUseProgram(state.program)

	state.rot++

	// Projection: 25° fov, screen aspect ratio, near-far : 0.1 unit <-> 100 units
	proj := math.mat44_perspective(math.radians(25), 1024.0 / 768.0, 0.1, 10)
	// View: camera matrix
	view := math.mat44_look_at(math.Vec3{4, 3, -3}, math.Vec3{0, 0, 0}, math.vec3_up())
	model := math.mat44_rotate(math.radians(state.rot), math.Vec3{0, 1, 0})
	mvp := proj * view * model
	glUniformMatrix4fv(state.mvp_uni, 1, C.GL_FALSE, &mvp.data)

	glBindVertexArray(state.cube_vao)

	glEnableVertexAttribArray(state.vert_pos_loc)
	glBindBuffer(C.GL_ARRAY_BUFFER, state.cube_vbo)
	glVertexAttribPointer(state.vert_pos_loc, 3, C.GL_FLOAT, false, 0, 0)

	glEnableVertexAttribArray(state.vert_col_loc)
	glBindBuffer(C.GL_ARRAY_BUFFER, state.cube_col_vbo)
	glVertexAttribPointer(state.vert_col_loc, 3, C.GL_FLOAT, false, 0, 0)

	glDrawArrays(C.GL_TRIANGLES, 0, 12 * 3)

	glDisableVertexAttribArray(state.vert_pos_loc)
	glDisableVertexAttribArray(state.vert_col_loc)

	glUseProgram(0)
}