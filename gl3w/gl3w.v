module gl3w

pub fn shader_compile_status(shader u32) int {
	success := 0
	C.glGetShaderiv(shader, C.GL_COMPILE_STATUS, &success)
	return success
}

pub fn shader_info_log(shader u32) string {
	info_log := [512]byte
	C.glGetShaderInfoLog(shader, 512, 0, info_log)
	return tos_clone(info_log)
}

pub fn get_program_link_status(program u32) int {
	success := 0
	C.glGetProgramiv(program, C.GL_LINK_STATUS, &success)
	return success
}

pub fn program_info_log(program u32) string {
	if C.glIsProgram(program) != 1 {
		println('program $program is not a shader program')
		exit(1)
	}

	info_log := [512]byte
	C.glGetProgramInfoLog(program, 512, 0, info_log)
	return tos_clone(info_log)
}

pub fn gen_buffer() u32 {
	vbo := u32(0)
	C.glGenBuffers(1, &vbo)
	return vbo
}

pub fn gen_vertex_array() u32 {
	vao := u32(0)
	C.glGenVertexArrays(1, &vao)
	return vao
}