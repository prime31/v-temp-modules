import via.libs.sokol
import prime31.sokol.sapp
import via.libs.sokol.gfx

#flag -I.
#define HANDMADE_MATH_IMPLEMENTATION
#include "HandMadeMath.h"

fn C.HMM_Perspective(FOV f32, AspectRatio f32, Near f32, Far f32) C.hmm_mat4
fn C.HMM_LookAt() C.hmm_mat4
fn C.HMM_MultiplyMat4() C.hmm_mat4
fn C.HMM_Rotate() C.hmm_mat4
fn C.HMM_Vec3() C.hmm_vec3

const (
	vert = '#version 330
uniform mat4 mvp;

layout(location=0) in vec4 position;
layout(location=1) in vec4 color0;
layout(location=2) in vec2 texcoord0;
out vec4 color;
out vec2 uv;

void main() {
    gl_Position = mvp * position;
    color = color0;
	uv = texcoord0;
}'
	frag = '#version 330
uniform sampler2D tex;
in vec4 color;
in vec2 uv;
out vec4 frag_color;

void main() {
	frag_color = texture(tex, uv) + color * 0.5;
}'

	offscreen_vert = '#version 330
uniform mat4 mvp;

layout(location=0) in vec4 position;
layout(location=1) in vec4 color0;
out vec4 color;

void main() {
    gl_Position = mvp * position;
    color = color0;
}'
	offscreen_frag = '#version 330
in vec4 color;
out vec4 frag_color;

void main() {
    frag_color = color;
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

	offscreen_pip sg_pipeline
	offscreen_bind sg_bindings
	offscreen_pass sg_pass
	offscreen_pass_action sg_pass_action
}

struct VsParams {
    mvp C.hmm_mat4
}

fn main() {
	mut color_action := sg_color_attachment_action {
		action: C.SG_ACTION_CLEAR
	}
	color_action.val = [0.0, 0.25, 1.0, 1.0]!!

	mut pass_action := sg_pass_action{}
	pass_action.colors[0] = color_action

	state := &AppState{
		pass_action: pass_action
	}

	sapp_run(&sapp_desc{
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
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

    offscreen_pass, color_img := new_offscreen_pass(512, 512)
	state.offscreen_pass = offscreen_pass
	state.offscreen_pass_action = gfx.make_clear_pass(0, 0, 0, 1)


	verts := [
-1.0, -1.0, -1.0,    1.0, 0.0, 0.0, 1.0,     0.0, 0.0,
1.0, -1.0, -1.0,    1.0, 0.0, 0.0, 1.0,      1.0, 0.0,
1.0,  1.0, -1.0,    1.0, 0.0, 0.0, 1.0,      1.0, 1.0,
-1.0,  1.0, -1.0,    1.0, 0.0, 0.0, 1.0,     0.0, 1.0,

-1.0, -1.0,  1.0,    0.0, 1.0, 0.0, 1.0,     0.0, 0.0,
1.0, -1.0,  1.0,    0.0, 1.0, 0.0, 1.0,      1.0, 0.0,
1.0,  1.0,  1.0,    0.0, 1.0, 0.0, 1.0,      1.0, 1.0,
-1.0,  1.0,  1.0,    0.0, 1.0, 0.0, 1.0,     0.0, 1.0,

-1.0, -1.0, -1.0,    0.0, 0.0, 1.0, 1.0,     0.0, 0.0,
-1.0,  1.0, -1.0,    0.0, 0.0, 1.0, 1.0,     1.0, 0.0,
-1.0,  1.0,  1.0,    0.0, 0.0, 1.0, 1.0,     1.0, 1.0,
-1.0, -1.0,  1.0,    0.0, 0.0, 1.0, 1.0,     0.0, 1.0,

1.0, -1.0, -1.0,    1.0, 0.5, 0.0, 1.0,      0.0, 0.0,
1.0,  1.0, -1.0,    1.0, 0.5, 0.0, 1.0,      1.0, 0.0,
1.0,  1.0,  1.0,    1.0, 0.5, 0.0, 1.0,      1.0, 1.0,
1.0, -1.0,  1.0,    1.0, 0.5, 0.0, 1.0,      0.0, 1.0,

-1.0, -1.0, -1.0,    0.0, 0.5, 1.0, 1.0,     0.0, 0.0,
-1.0, -1.0,  1.0,    0.0, 0.5, 1.0, 1.0,     1.0, 0.0,
1.0, -1.0,  1.0,    0.0, 0.5, 1.0, 1.0,      1.0, 1.0,
1.0, -1.0, -1.0,    0.0, 0.5, 1.0, 1.0,      0.0, 1.0,

-1.0,  1.0, -1.0,    1.0, 0.0, 0.5, 1.0,     0.0, 0.0,
-1.0,  1.0,  1.0,    1.0, 0.0, 0.5, 1.0,     1.0, 0.0,
1.0,  1.0,  1.0,    1.0, 0.0, 0.5, 1.0,      1.0, 1.0,
1.0,  1.0, -1.0,    1.0, 0.0, 0.5, 1.0,      0.0, 1.0]!

	vbuf := sg_make_buffer(&sg_buffer_desc{
		size: sizeof(f32) * verts.len
		content: verts.data
	})

	indices := [
		u16(0), 1, 2,  0, 2, 3,
        6, 5, 4,  7, 6, 4,
        8, 9, 10,  8, 10, 11,
        14, 13, 12,  15, 14, 12,
        16, 17, 18,  16, 18, 19,
        22, 21, 20,  23, 22, 20
	]!
	ibuf := sg_make_buffer(&sg_buffer_desc{
        @type: .indexbuffer
        size: sizeof(u16) * indices.len
        content: indices.data
    })

	/* resource bindings for offscreen rendering */
    state.offscreen_bind.vertex_buffers[0] = vbuf
	state.offscreen_bind.index_buffer = ibuf

	/* and the resource bindings for the default pass where a textured cube will
       rendered, note how the render-target image is used as texture here
    */
	state.bind.vertex_buffers[0] = vbuf
	state.bind.index_buffer = ibuf
	state.bind.fs_images[0] = color_img

	/* shader for the non-textured cube, rendered in the offscreen pass */
	mut offscreen_vs_desc := sg_shader_stage_desc{
		source: offscreen_vert.str
	}
	offscreen_vs_desc.uniform_blocks[0].size = sizeof(C.hmm_mat4)

	mut offscreen_uniform := offscreen_vs_desc.uniform_blocks[0].uniforms[0]
	offscreen_uniform.name = 'mvp'.str
	offscreen_uniform.@type = .mat4
	offscreen_vs_desc.uniform_blocks[0].uniforms[0] = offscreen_uniform

	mut offscreen_shader_desc := &sg_shader_desc{
		vs: offscreen_vs_desc
		fs: sg_shader_stage_desc{
			source: offscreen_frag.str
		}
	}

	offscreen_shd := sg_make_shader(offscreen_shader_desc)


	/* ...and a second shader for rendering a textured cube in the default pass */
	// vert shader
	mut vs_desc := sg_shader_stage_desc{
		source: vert.str
	}
	vs_desc.uniform_blocks[0].size = sizeof(C.hmm_mat4)

	mut uniform := vs_desc.uniform_blocks[0].uniforms[0]
	uniform.name = 'mvp'.str
	uniform.@type = .mat4
	vs_desc.uniform_blocks[0].uniforms[0] = uniform

	// frag shader
	mut fs_desc := sg_shader_stage_desc{
		source: frag.str
	}
	fs_desc.images[0] = sg_shader_image_desc{
		name: 'tex'.str
		@type: ._2d
	}

	mut shader_desc := &sg_shader_desc{
		vs: vs_desc
		fs: fs_desc
	}

	shd := sg_make_shader(shader_desc)


	/* pipeline object for offscreen rendering, don't need texcoords here */
	mut layout := sg_layout_desc{}
	layout.buffers[0].stride = 36
	layout.attrs[0] = sg_vertex_attr_desc{
		format: .float3
	}
	layout.attrs[1] = sg_vertex_attr_desc{
		format: .float4
	}

	state.offscreen_pip = sg_make_pipeline(&sg_pipeline_desc{
		layout: layout
		shader: offscreen_shd
		index_type: .uint16
		primitive_type: ._default
		depth_stencil: sg_depth_stencil_state{
			depth_compare_func: .less_equal
			depth_write_enabled: true
		}
		blend: sg_blend_state{
			depth_format: .depth
		}
		rasterizer: sg_rasterizer_state{
			cull_mode: .back
			sample_count: 4
		}
	})


	/* and another pipeline object for the default pass */
	layout = sg_layout_desc{}
	layout.attrs[0] = sg_vertex_attr_desc{
		format: .float3
	}
	layout.attrs[1] = sg_vertex_attr_desc{
		format: .float4
	}
	layout.attrs[2] = sg_vertex_attr_desc{
		format: .float2
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
	proj := C.HMM_Perspective(60.0, f32(sapp_width()) / f32(sapp_height()), 0.01, 10.0)
	view := HMM_LookAt(HMM_Vec3(0.0, 1.5, 6.0), HMM_Vec3(0.0, 0.0, 0.0), HMM_Vec3(0.0, 1.0, 0.0))
	state.view_proj = HMM_MultiplyMat4(proj, view)
}

fn new_offscreen_pass(width, height int) (sg_pass, sg_image) {
    offscreen_sample_count := if C.sg_query_features().msaa_render_targets { 4 } else { 1 }

    mut img_desc := sg_image_desc{
        render_target: true
        width: width
        height: height
        min_filter: .linear
        mag_filter: .linear
        sample_count: offscreen_sample_count
    }
    color_img := sg_make_image(&img_desc)
    img_desc.pixel_format = .depth
    depth_img := sg_make_image(&img_desc)

	// an offscreen render pass into those images
	mut pass_desc := sg_pass_desc{}
	pass_desc.depth_stencil_attachment.image = depth_img
	pass_desc.color_attachments[0].image = color_img
    return sg_make_pass(&pass_desc), color_img
}

fn create_image() C.sg_image {
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
		wrap_u: .clamp_to_edge
		wrap_v: .clamp_to_edge
	}
	img_desc.content.subimage[0][0] = sg_subimage_content{
		ptr: pixels.data
		size: sizeof(u32) * pixels.len
    }

    return C.sg_make_image(&img_desc)
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)

	// compute model-view-projection matrix for vertex shader
	state.rx += 1.0
	state.ry += 2.0
	rxm := HMM_Rotate(state.rx, HMM_Vec3(1.0, 0.0, 0.0))
    rym := HMM_Rotate(state.ry, HMM_Vec3(0.0, 1.0, 0.0))
    model := HMM_MultiplyMat4(rxm, rym)
	vs_params := VsParams{
		mvp: HMM_MultiplyMat4(state.view_proj, model)
	}

	/* offscreen pass, this renders a rotating, untextured cube to the
		offscreen render target */
	sg_begin_pass(state.offscreen_pass, &state.offscreen_pass_action)
	sg_apply_pipeline(state.offscreen_pip)
	sg_apply_bindings(&state.offscreen_bind)
	sg_apply_uniforms(C.SG_SHADERSTAGE_VS, 0, &vs_params, sizeof(VsParams))
	sg_draw(0, 36, 1)
	sg_end_pass()


	/* and the default pass, this renders a textured cube, using the
		offscreen render target as texture image */
	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_apply_pipeline(state.pip)
	sg_apply_bindings(&state.bind)
	sg_apply_uniforms(C.SG_SHADERSTAGE_VS, 0, &vs_params, sizeof(VsParams))
	sg_draw(0, 36, 1)
	sg_end_pass()
	sg_commit()
}

fn cleanup() {
	println('hi cleanup')
}