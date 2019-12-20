module graphics
import strings
import prime31.math
import prime31.gl3w.gl41 as gl

// TODO: after setup gl context set these, create 1px white texture. do what OpenGL.cpp in Love does
enum BuiltinVertexAttribute {
	position
	texcoord,
	vert_color,
	constant_color
}

pub struct Shader {
	program u32
}

pub fn create_shader(frag_src, vert_src string) &Shader {
	version := gl.get_string(.shading_language_version).replace('.', '')

	// vertex shader
	vert_code := get_vert_shader_source(vert_src, version)
	vert := gl.create_shader(.vertex_shader)
	gl.shader_source(vert, vert_code)
	gl.compile_shader(vert)
	check_compile_errors(vert, false)

	// fragment shader
	frag_code := get_frag_shader_source(frag_src, version)
	frag := gl.create_shader(.fragment_shader)
	gl.shader_source(frag, frag_code)
	gl.compile_shader(frag)
	check_compile_errors(frag, false)

	// link shaders
	program := gl.create_program()
	gl.attach_shader(program, vert)
	gl.attach_shader(program, frag)
	gl.link_program(program)
	check_compile_errors(program, true)

	gl.delete_shader(vert)
	gl.delete_shader(frag)

	// TODO: query shader for

	return &Shader {
		program: program
	}
}

fn get_frag_shader_source(src_or_path, version string) string {
	mut frag_sb := strings.Builder{}
	frag_sb.writeln('#version $version core')
	frag_sb.writeln(shader_syntax)
	frag_sb.writeln(frag_main)

	if src_or_path.len == 0 {
		frag_sb.writeln(frag_default)
	} else {
		// TODO: check for file path validity (no newlines, ends with .frag maybe) and load from file if necessary
		frag_sb.writeln(src_or_path)
		if src_or_path.contains('effects(') { panic('custom effects() not yet supported for frag shader') }
	}

	return frag_sb.str()
}

fn get_vert_shader_source(src_or_path, version string) string {
	mut vert_sb := strings.Builder{}
	vert_sb.writeln('#version $version core')
	vert_sb.writeln(shader_syntax)
	vert_sb.writeln(vert_main)

	if src_or_path.len == 0 {
		vert_sb.writeln(vert_default)
	} else {
		// TODO: check for file path validity (no newlines, ends with .vert maybe) and load from file if necessary
		vert_sb.writeln(src_or_path)
		if !src_or_path.contains('position(') { panic('postion function not found in vert shader') }
	}

	return vert_sb.str()
}

fn check_compile_errors(shader_or_program u32, is_program bool) {
	if is_program {
		if gl.get_program_link_status(shader_or_program) == 0 {
			log := gl.get_program_info_log(shader_or_program)
			println('shader program link failed')
			println(log)
		}
	} else {
		if gl.get_shader_compile_status(shader_or_program) == 0 {
			log := gl.get_shader_info_log(shader_or_program)
			println('shader compilation failed')
			println(log)
		}
	}
}

pub fn (s &Shader) use() {
	gl.use_program(s.program)
}

pub fn (s &Shader) set_bool(name string, val bool) {
	int_bool := if val { 1 } else { 0 }
	gl.uniform1i(gl.get_uniform_location(s.program, name), int_bool)
}

pub fn (s &Shader) set_int(name string, val int) {
	gl.uniform1i(gl.get_uniform_location(s.program, name), val)
}

pub fn (s &Shader) set_float(name string, val f32) {
	gl.uniform1f(gl.get_uniform_location(s.program, name), val)
}

pub fn (s &Shader) set_vec2(name string, val math.Vec2) {
	gl.uniform2fv(gl.get_uniform_location(s.program, name), 1, &val.x)
}

pub fn (s &Shader) set_vec3(name string, val math.Vec3) {
	gl.uniform3fv(gl.get_uniform_location(s.program, name), 1, &val.x)
}

pub fn (s &Shader) set_vec4(name string, val math.Vec4) {
	gl.uniform3fv(gl.get_uniform_location(s.program, name), 1, &val.x)
}

pub fn (s &Shader) set_vertex_attrib4f(name string, x f32, y f32, z f32, w f32) {
	index := gl.get_attrib_location(s.program, name)
	if index >= 0 {
		gl.vertex_attrib4f(u32(index), x, y, z, w)
	} else {
		println('could not find vertex attribute $name')
	}
}


pub fn (s &Shader) free() {
	gl.delete_program(s.program)
	free(s)
}

