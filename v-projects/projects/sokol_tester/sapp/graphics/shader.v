module graphics
import via.math

pub fn make_default_shader() C.sg_shader {
	shader_desc := C.sg_shader_desc{
		vs: make_default_vert_desc()
		fs: make_default_frag_desc()
	}
	return sg_make_shader(&shader_desc)
}

pub fn make_default_vert_desc() C.sg_shader_stage_desc {
	mut vs_desc := sg_shader_stage_desc{
		source: vert.str
	}

	vs_desc.uniform_blocks[0].size = sizeof(math.Mat44)
	vs_desc.uniform_blocks[0].uniforms[0] = sg_shader_uniform_desc{
		name: 'TransformProjectionMatrix'.str
		@type: .mat4
	}
	return vs_desc
}

pub fn make_default_frag_desc() C.sg_shader_stage_desc {
	mut fs_desc := sg_shader_stage_desc{
		source: frag.str
	}
	fs_desc.images[0] = sg_shader_image_desc{
		name: 'MainTex'.str // optional uniform name for single image shaders
		@type: ._2d
	}
	return fs_desc
}