import via.libs.sokol
import prime31.sokol.sapp
import via.libs.sokol.gfx
import via.math
import via.libs.stb.image
import rand

const (
	vert = '#version 330
uniform mat4 TransformProjectionMatrix;

layout (location=0) in vec2 VertPosition;
layout (location=1) in vec2 VertTexCoord;
layout (location=2) in vec4 VertColor;

out vec2 VaryingTexCoord;
out vec4 VaryingColor;

vec4 position(mat4 TransformProjectionMatrix, vec4 localPosition);

void main() {
	VaryingTexCoord = VertTexCoord;
	VaryingColor = VertColor;
	gl_Position = position(TransformProjectionMatrix, vec4(VertPosition, 0, 1));
}

vec4 position(mat4 transformProjectionMatrix, vec4 localPosition) {
	return transformProjectionMatrix * localPosition;
}'
	frag = '#version 330
uniform sampler2D MainTex;

uniform mat4 TransformProjectionMatrix;
uniform vec4 via_ScreenSize;

in vec2 VaryingTexCoord;
in vec4 VaryingColor;

vec4 effect(vec4 vcolor, sampler2D tex, vec2 texcoord);

layout (location=0) out vec4 frag_color;
void main() {
	frag_color = effect(VaryingColor, MainTex, VaryingTexCoord.st);
}

vec4 effect(vec4 vcolor, sampler2D tex, vec2 texcoord) {
	return texture(tex, texcoord) * vcolor;
}'
)

struct AppState {
mut:
	update_verts bool
	pip sg_pipeline
	bind sg_bindings
	pass_action sg_pass_action
	rx f32
	ry f32
	trans_mat math.Mat44

	checker_img C.sg_image
	beach_img C.sg_image

	draw_images [2]sg_image
}

struct Vert {
pub mut:
	pos math.Vec2
	texcoords math.Vec2
	color math.Color
}


fn main() {
	mut pass_action := sg_pass_action{}
	pass_action.colors[0] = sg_color_attachment_action {
		action: C.SG_ACTION_CLEAR
	}
	pass_action.colors[0].val[0] = 0.3
	pass_action.colors[0].val[1] = 0.3

	state := &AppState{
		pass_action: pass_action
	}

	sapp_run(&sapp_desc{
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
		event_userdata_cb: on_event
		cleanup_cb: cleanup
		window_title: 'Textured Cube'.str
	})
}

fn init(user_data voidptr) {
	mut state := &AppState(user_data)

	sg_setup(&sg_desc {
		mtl_device: C.sapp_metal_get_device()
		mtl_renderpass_descriptor_cb: sapp_metal_get_renderpass_descriptor
		mtl_drawable_cb: sapp_metal_get_drawable
		d3d11_device: sapp_d3d11_get_device()
		d3d11_device_context: sapp_d3d11_get_device_context()
		d3d11_render_target_view_cb: sapp_d3d11_get_render_target_view
		d3d11_depth_stencil_view_cb: sapp_d3d11_get_depth_stencil_view
	})

	verts := [
		Vert{ math.Vec2{-1,-1}, 	math.Vec2{0,0},		math.Color{} }, // tl
		Vert{ math.Vec2{1,-1}, 	math.Vec2{1,0},		math.Color{} }, // tr
		Vert{ math.Vec2{1,1}, 	math.Vec2{1,1},		math.Color{} }, // br
		Vert{ math.Vec2{-1,1}, 	math.Vec2{0,1},		math.Color{0xff0000ff} }, // bl

		Vert{ math.Vec2{-2,-2}, 	math.Vec2{0,0},		math.Color{} },
		Vert{ math.Vec2{0,-2}, 	math.Vec2{1,0},		math.Color{} },
		Vert{ math.Vec2{0,0}, 	math.Vec2{1,1},		math.Color{} },
		Vert{ math.Vec2{-2,0}, 	math.Vec2{0,1},		math.Color{0xff0000ff} }
	]!

	state.bind.vertex_buffers[0] = sg_make_buffer(&sg_buffer_desc{
		size: sizeof(Vert) * verts.len
		usage: .dynamic
	})
	sg_update_buffer(state.bind.vertex_buffers[0], verts.data, sizeof(Vert) * verts.len)

	indices := [u16(0), 1, 2, 0, 2, 3,  4, 5, 6, 4, 6, 7]!
	state.bind.index_buffer = sg_make_buffer(&sg_buffer_desc{
        @type: C.SG_BUFFERTYPE_INDEXBUFFER
        size: sizeof(u16) * indices.len
        content: indices.data
    })
	state.bind.fs_images[0] = create_image()

	state.beach_img = state.bind.fs_images[0]
	state.checker_img = create_checker_image()
	state.draw_images[0] = state.beach_img
	state.draw_images[1] = state.checker_img

	// vert shader
	mut vs_desc := sg_shader_stage_desc{
		source: vert.str
	}
	vs_desc.uniform_blocks[0].size = sizeof(math.Mat44)

	mut uniform := vs_desc.uniform_blocks[0].uniforms[0]
	uniform.name = 'TransformProjectionMatrix'.str
	uniform.@type = .mat4
	vs_desc.uniform_blocks[0].uniforms[0] = uniform

	// frag shader
	mut fs_desc := sg_shader_stage_desc{
		source: frag.str
	}
	fs_desc.images[0] = sg_shader_image_desc{
		name: 'MainTex'.str // optional uniform name for single image shaders
		@type: ._2d
	}

	shader_desc := sg_shader_desc{
		vs: vs_desc
		fs: fs_desc
	}

	shd := sg_make_shader(&shader_desc)

	mut layout := sg_layout_desc{}
	layout.attrs[0] = sg_vertex_attr_desc{
		format: .float2
	}
	layout.attrs[1] = sg_vertex_attr_desc{
		format: .float2
	}
	layout.attrs[2] = sg_vertex_attr_desc{
		format: .ubyte4n
	}


	state.pip = sg_make_pipeline(&sg_pipeline_desc{
		layout: layout
		shader: shd
		index_type: C.SG_INDEXTYPE_UINT16
		depth_stencil: sg_depth_stencil_state{
			depth_compare_func: C.SG_COMPAREFUNC_LESS_EQUAL
			depth_write_enabled: true
		}
		rasterizer: sg_rasterizer_state{
			cull_mode: C.SG_CULLMODE_BACK
			sample_count: 4
		}
	})

	// view-projection matrix
	state.trans_mat = math.mat44_ortho2d(-2, 2, 2, -2)
}

fn create_image() C.sg_image {
	img := image.load('assets/beach.png')
	mut img_desc := sg_image_desc{
		width: img.width
		height: img.height
		pixel_format: .rgba8
		min_filter: .nearest
		mag_filter: .nearest
	}
	img_desc.content.subimage[0][0] = sg_subimage_content{
		ptr: img.data
		size: sizeof(u32) * img.width * img.height
    }

    sg_img := C.sg_make_image(&img_desc)
	img.free()
	return sg_img
}

fn create_checker_image() C.sg_image {
	/* create a checkerboard texture */
    pixels := [
        u32(0xFFFFFFFF), 0x00000000, 0xFFFFFFFF, 0x00000000,
        0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF,
        0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0x00000000,
        0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF,
	]!

	mut img_desc := sg_image_desc{
		width: 4
		height: 4
		pixel_format: .rgba8
		min_filter: .nearest
		mag_filter: .nearest
	}
	img_desc.content.subimage[0][0] = sg_subimage_content{
		ptr: pixels.data
		size: sizeof(u32) * pixels.len
    }

    return C.sg_make_image(&img_desc)
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)

	if state.update_verts {
		state.update_verts = !state.update_verts
		state.update_vert_buffer()
	}

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_apply_pipeline(state.pip)

	for i := 0; i < 2; i++ {
		state.bind.fs_images[0] = state.draw_images[i]
		sg_apply_bindings(&state.bind)
		sg_apply_uniforms(C.SG_SHADERSTAGE_VS, 0, &state.trans_mat, sizeof(math.Mat44))
		sg_draw(i * 6, 6, 1)
	}

	sg_end_pass()
	sg_commit()
}

fn on_event(evt &C.sapp_event, user_data voidptr) {
	if evt.@type == .key_down {
		match evt.key_code {
			.f {
				mut state := &AppState(user_data)
				state.draw_images[0] = state.beach_img
			}
			.g {
				mut state := &AppState(user_data)
				state.draw_images[0] = state.checker_img
			}
			.v {
				mut state := &AppState(user_data)
				state.update_verts = !state.update_verts

				// comment these two lines out to cause the vert update to occur in frame
				// state.update_verts = false
				// state.update_vert_buffer()
			}
			else {}
		}
	}
}

fn (state &AppState) update_vert_buffer() {
	mut verts := [
		Vert{ math.Vec2{-1,-1}, 	math.Vec2{0,0},		math.Color{} }, // tl
		Vert{ math.Vec2{1,-1}, 	math.Vec2{1,0},		math.Color{} }, // tr
		Vert{ math.Vec2{1,1}, 	math.Vec2{1,1},		math.Color{} }, // br
		Vert{ math.Vec2{-1,1}, 	math.Vec2{0,1},		math.Color{0xff0000ff} }, // bl

		Vert{ math.Vec2{-2,-2}, 	math.Vec2{0,0},		math.Color{} },
		Vert{ math.Vec2{0,-2}, 	math.Vec2{1,0},		math.Color{} },
		Vert{ math.Vec2{0,0}, 	math.Vec2{1,1},		math.Color{} },
		Vert{ math.Vec2{-2,0}, 	math.Vec2{0,1},		math.Color{0xff0000ff} }
	]!
	for i, _ in verts {
		verts[i].pos.x += f32(rand.next(100)) / 100
		verts[i].pos.y += f32(rand.next(100)) / 100
	}
	sg_update_buffer(state.bind.vertex_buffers[0], verts.data, sizeof(Vert) * verts.len)
}

fn cleanup() {
	println('hi cleanup')
}