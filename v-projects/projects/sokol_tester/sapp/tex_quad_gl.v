import prime31.sokol
import prime31.sokol.sapp
import prime31.sokol.gfx
import prime31.stb.image

#flag -I.
#define HANDMADE_MATH_IMPLEMENTATION
#include "HandmadeMath.h"

fn C.HMM_Orthographic(Left f32, Right f32, Bottom f32, Top f32, Near f32, Far f32) C.hmm_mat4
fn C.HMM_Perspective(FOV f32, AspectRatio f32, Near f32, Far f32) C.hmm_mat4
fn C.HMM_LookAt() C.hmm_mat4
fn C.HMM_MultiplyMat4() C.hmm_mat4
fn C.HMM_Rotate() C.hmm_mat4
fn C.HMM_Vec3() C.hmm_vec3

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
	pip sg_pipeline
	bind sg_bindings
	pass_action sg_pass_action
	rx f32
	ry f32
	view_proj C.hmm_mat4

	checker_img C.sg_image
	beach_img C.sg_image
}

struct VsParams {
    mvp C.hmm_mat4
}

fn main() {
	mut color_action := sg_color_attachment_action {
		action: C.SG_ACTION_CLEAR
	}
	color_action.val[0] = 0.3
	color_action.val[1] = 0.3

	mut pass_action := sg_pass_action{}
	pass_action.colors[0] = color_action

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
	-1.0, -1.0,    0.0, 0.0,	1.0, 1.0, 1.0, 1.0,
	1.0, -1.0,     1.0, 0.0,	1.0, 1.0, 1.0, 1.0,
	1.0,  1.0,     1.0, 1.0,	1.0, 1.0, 1.0, 1.0,
	-1.0,  1.0,    0.0, 1.0,	1.0, 1.0, 1.0, 1.0]!
	state.bind.vertex_buffers[0] = sg_make_buffer(&sg_buffer_desc{
		size: sizeof(f32) * verts.len
		content: verts.data
	})

	indices := [u16(0), 1, 2, 0, 2, 3]!
	state.bind.index_buffer = sg_make_buffer(&sg_buffer_desc{
        @type: C.SG_BUFFERTYPE_INDEXBUFFER
        size: sizeof(u16) * indices.len
        content: indices.data
    })
	state.bind.fs_images[0] = create_image()

	state.beach_img = state.bind.fs_images[0]
	state.checker_img = create_checker_image()

	// vert shader
	mut vs_desc := sg_shader_stage_desc{
		source: vert.str
	}
	vs_desc.uniform_blocks[0].size = sizeof(C.hmm_mat4)

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

	mut shader_desc := &sg_shader_desc{
		vs: vs_desc
		fs: fs_desc
	}

	shd := sg_make_shader(shader_desc)

	mut layout := sg_layout_desc{}
	layout.attrs[0] = sg_vertex_attr_desc{
		format: .float2
	}
	layout.attrs[1] = sg_vertex_attr_desc{
		format: .float2
	}
	layout.attrs[2] = sg_vertex_attr_desc{
		format: .float4
	}

	rasterizer := sg_rasterizer_state{
		cull_mode: C.SG_CULLMODE_BACK
		sample_count: 4
	}
	state.pip = sg_make_pipeline(&sg_pipeline_desc{
		layout: layout
		shader: shd
		index_type: C.SG_INDEXTYPE_UINT16
		depth_stencil: sg_depth_stencil_state{
			depth_compare_func: C.SG_COMPAREFUNC_LESS_EQUAL
			depth_write_enabled: true
		}
		rasterizer: rasterizer
	})

	// view-projection matrix
	// state.view_proj = HMM_Orthographic(Left f32, Right f32, Bottom f32, Top f32, -5.0, 5.0)
	state.view_proj = HMM_Orthographic(-2, 2, 2, -2, -5.0, 5.0)
}

fn create_image() C.sg_image {
	img := image.load('assets/beach.png')

	img_content := sg_subimage_content{
		ptr: img.data
		size: sizeof(u32) * img.width * img.height
    }
	mut img_desc := C.gfx_hack_make_image_desc(img_content)
	img_desc.width = img.width
	img_desc.height = img.height
	img_desc.pixel_format = .rgba8
	img_desc.min_filter = .nearest
	img_desc.mag_filter = .nearest

    sg_img := C.sg_make_image(img_desc)
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

	img_content := sg_subimage_content{
		ptr: pixels.data
		size: sizeof(u32) * pixels.len
    }
	mut img_desc := C.gfx_hack_make_image_desc(img_content)
	img_desc.width = 4
	img_desc.height = 4
	img_desc.pixel_format = .rgba8
	img_desc.min_filter = .nearest
	img_desc.mag_filter = .nearest

    return C.sg_make_image(img_desc)
}

fn frame(user_data voidptr) {
	state := &AppState(user_data)

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_apply_pipeline(state.pip)
	sg_apply_bindings(&state.bind)
	sg_apply_uniforms(C.SG_SHADERSTAGE_VS, 0, &state.view_proj, sizeof(VsParams))
	sg_draw(0, 8, 1)
	sg_end_pass()
	sg_commit()
}

fn on_event(evt &C.sapp_event, user_data voidptr) {
	if evt.@type == .key_down {
		match evt.key_code {
			.f {
				mut state := &AppState(user_data)
				state.bind.fs_images[0] = state.beach_img
			}
			.g {
				mut state := &AppState(user_data)
				state.bind.fs_images[0] = state.checker_img
			}
			else {}
		}
	}
}

fn cleanup() {
	println('hi cleanup')
}