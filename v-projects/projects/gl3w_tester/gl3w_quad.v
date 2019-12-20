import prime31.sdl2
import prime31.gl3w.gl41 as gl
import prime31.gl3w
import prime31.stb.image
import time
import os

struct AppState {
mut:
	program1 u32
	program2 u32

	vao u32
	vbo u32
	ibo u32
	tex u32
	tex2 u32

	tri_mesh Mesh
}

struct Mesh {
pub:
	vao u32
	vbo u32
	ibo u32
}

const (
	vert_shader = '#version 330 core
	layout (location = 0) in vec3 aPos;
	layout (location = 1) in vec3 aColor;
	layout (location = 2) in vec2 aTexCoord;

	out vec3 ourColor;
	out vec2 TexCoord;

	void main()
	{
		gl_Position = vec4(aPos, 1.0);
		ourColor = aColor;
		TexCoord = aTexCoord;
	}'

	frag_shader = '#version 330 core
	out vec4 FragColor;

	in vec3 ourColor;
	in vec2 TexCoord;

	uniform sampler2D texture1;
	uniform sampler2D texture2;

	void main()
	{
		// FragColor = texture(texture1, TexCoord);
		FragColor = mix(texture(texture1, TexCoord), texture(texture2, TexCoord), 0.2) * vec4(ourColor, 1);
	}'

	frag_shader_via_color_only = '#version 330 core
	layout(location = 0) out vec4 FragColor;

	in vec2 VaryingTexCoord;
	in vec4 VaryingColor;

	uniform sampler2D MainTex;

	void main()
	{
		FragColor = VaryingColor;
	}'

	vert_shader_via = '#version 330 core
	layout (location = 0) in vec2 VertPosition;
	layout (location = 1) in vec2 VertTexCoord;
	layout (location = 2) in vec4 VertColor;

	out vec2 VaryingTexCoord;
	out vec4 VaryingColor;

	void main()
	{
		VaryingTexCoord = VertTexCoord;
		VaryingColor = VertColor;
		gl_Position = vec4(VertPosition, 1.0, 1.0);
	}'

	frag_shader_via = '#version 330 core
	layout(location = 0) out vec4 FragColor;

	in vec2 VaryingTexCoord;
	in vec4 VaryingColor;

	uniform sampler2D MainTex;

	void main()
	{
		FragColor = texture(MainTex, VaryingTexCoord) * VaryingColor;
	}'
)

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

	state.program1 = create_shader(vert_shader, frag_shader)
	state.create_buffers()
	state.load_textures()

	state.program2 = create_shader(vert_shader_via, frag_shader_via_color_only)
	state.tri_mesh = create_tri_buffers()

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

		gl.clear_color(0.1, 0.0, 0.2, 1.0)
		gl.clear(.color_buffer_bit)
		state.draw_quad()
		state.draw_tri()
		C.SDL_GL_SwapWindow(window)
	}

    C.SDL_GL_DeleteContext(gl_context)
    C.SDL_DestroyWindow(window)
    C.SDL_Quit()
}

fn create_shader(vert_src, frag_src string) u32 {
	// vertex shader
	vert := gl.create_shader(.vertex_shader)
	gl.shader_source(vert, vert_src)
	gl.compile_shader(vert)
	if gl.get_shader_compile_status(vert) == 0 {
		log := gl.get_shader_info_log(vert)
		println('shader $vert compilation failed')
		println(log)
		exit(1)
	}

	// fragment shader
	frag := gl.create_shader(.fragment_shader)
	gl.shader_source(frag, frag_src)
	gl.compile_shader(frag)
	if gl.get_shader_compile_status(frag) == 0 {
		log := gl.get_shader_info_log(frag)
		println('fragment $frag shader compilation failed')
		println(log)
		exit(1)
	}

	// link shaders
	shader_program := gl.create_program()
	gl.attach_shader(shader_program, vert)
	gl.attach_shader(shader_program, frag)
	gl.link_program(shader_program)

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

	gl.delete_shader(vert)
	gl.delete_shader(frag)

	return shader_program
}

fn (state mut AppState) create_buffers() {
	vertex_data := [
    // positions          // colors           // texture coords
     0.5,  0.5, 0.0,   1.0, 0.0, 0.0,   1.0, 1.0,   // top right
     0.5, -0.5, 0.0,   0.0, 1.0, 0.0,   1.0, 0.0,   // bottom right
    -0.5, -0.5, 0.0,   0.0, 0.0, 1.0,   0.0, 0.0,   // bottom left
    -0.5,  0.5, 0.0,   1.0, 1.0, 0.0,   0.0, 1.0    // top left
	]!
	index_data := [
		u16(0), 1, 3, 1, 2, 3
	]!

	state.vao = gl.gen_vertex_array()
	gl.bind_vertex_array(state.vao)

	state.vbo = gl.gen_buffer()
	gl.bind_buffer(.array_buffer, state.vbo)
	gl.buffer_data_f32(.array_buffer, vertex_data, .static_draw)

	state.ibo = gl.gen_buffer()
	gl.bind_buffer(.element_array_buffer, state.ibo)
	gl.buffer_data_u16(.element_array_buffer, index_data, .static_draw)

	// position attribute
    gl.vertex_attrib_pointer(0, 3, .float, .gl_false, 8 * sizeof(f32), C.NULL)
    gl.enable_vertex_attrib_array(0)
    // color attribute
    gl.vertex_attrib_pointer(1, 3, .float, .gl_false, 8 * sizeof(f32), (3 * sizeof(f32)))
    gl.enable_vertex_attrib_array(1)
    // texture coord attribute
    gl.vertex_attrib_pointer(2, 2, .float, .gl_false, 8 * sizeof(f32), (6 * sizeof(f32)))
    gl.enable_vertex_attrib_array(2)
}

fn create_tri_buffers() Mesh {
	vertex_data := [
		// positions	// tex coords 	// colors
		-1.0, -1.0,		1.0, 1.0,		1.0, 0.0, 0.0, 1.0,   // bottom left
		1.0,  -1.0,		1.0, 0.0,		0.0, 1.0, 0.0, 1.0,   // bottom right
		0.0,  0.0, 		0.0, 1.0,		1.0, 1.0, 0.0, 1.0    // top
	]!
	index_data := [
		u16(0), 1, 2
	]!

	vao := gl.gen_vertex_array()
	gl.bind_vertex_array(vao)

	vbo := gl.gen_buffer()
	gl.bind_buffer(.array_buffer, vbo)
	gl.buffer_data_f32(.array_buffer, vertex_data, .static_draw)

	ibo := gl.gen_buffer()
	gl.bind_buffer(.element_array_buffer, ibo)
	gl.buffer_data_u16(.element_array_buffer, index_data, .static_draw)

	// position attribute
	gl.vertex_attrib_pointer(0, 2, .float, .gl_false, 8 * sizeof(f32), C.NULL)
    gl.enable_vertex_attrib_array(0)
    // texture coord attribute
	gl.vertex_attrib_pointer(2, 2, .float, .gl_false, 8 * sizeof(f32), 2 * sizeof(f32))
    gl.enable_vertex_attrib_array(2)
    // color attribute
	gl.vertex_attrib_pointer(2, 4, .float, .gl_false, 8 * sizeof(f32), 2 * sizeof(f32))
    gl.enable_vertex_attrib_array(2)

	return Mesh { vao, vbo, ibo }
}

fn (state mut AppState) load_textures() {
	image.set_flip_vertically_on_load(true)

 	state.tex = gl.gen_texture()
    gl.bind_texture(.texture_2d, state.tex)

     // set the texture wrapping parameters
	gl.tex_parameteri(.texture_2d, .texture_wrap_s, C.GL_REPEAT)
	gl.tex_parameteri(.texture_2d, .texture_wrap_t, C.GL_REPEAT)

    // set texture filtering parameters
	gl.tex_parameteri(.texture_2d, .texture_min_filter, C.GL_LINEAR)
	gl.tex_parameteri(.texture_2d, .texture_mag_filter, C.GL_LINEAR)

	img := image.load('assets/container.jpg')
	gl.tex_image_2d(.texture_2d, 0, .rgb, img.width, img.height, 0, .rgb, .unsigned_byte, img.data)
	img.free()


	state.tex2 = gl.gen_texture()
    gl.bind_texture(.texture_2d, state.tex2)

     // set the texture wrapping parameters
	gl.tex_parameteri(.texture_2d, .texture_wrap_s, C.GL_REPEAT)
	gl.tex_parameteri(.texture_2d, .texture_wrap_t, C.GL_REPEAT)

    // set texture filtering parameters
	gl.tex_parameteri(.texture_2d, .texture_min_filter, C.GL_LINEAR)
	gl.tex_parameteri(.texture_2d, .texture_mag_filter, C.GL_LINEAR)

	img2 := image.load('assets/face.png')
	gl.tex_image_2d(.texture_2d, 0, .rgba, img2.width, img2.height, 0, .rgba, .unsigned_byte, img2.data)
	img2.free()

	gl.use_program(state.program1)
    gl.uniform1i(gl.get_uniform_location(state.program1, "texture1"), 0)
	gl.uniform1i(gl.get_uniform_location(state.program1, "texture2"), 1)
}

fn (state AppState) draw_quad() {
	gl.use_program(state.program1)

	gl.active_texture(.texture0)
	gl.bind_texture(.texture_2d, state.tex)
	gl.active_texture(.texture1)
	gl.bind_texture(.texture_2d, state.tex2)

	gl.bind_vertex_array(state.vao)
	gl.draw_elements(.triangle_fan, 6, .unsigned_short, C.NULL)
}

fn (state AppState) draw_tri() {
	gl.use_program(state.program2)

	gl.active_texture(.texture0)
	gl.bind_texture(.texture_2d, 0)
	gl.active_texture(.texture1)
	gl.bind_texture(.texture_2d, 0)

	gl.bind_vertex_array(state.tri_mesh.vao)
	gl.draw_elements(.triangle_fan, 3, .unsigned_short, C.NULL)
}
