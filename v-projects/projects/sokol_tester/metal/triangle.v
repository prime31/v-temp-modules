import prime31.sokol

const (
	vert = '#include <metal_stdlib>
using namespace metal;
struct vs_in {
  float4 position [[attribute(0)]];
  float4 color [[attribute(1)]];
};
struct vs_out {
  float4 position [[position]];
  float4 color;
};
vertex vs_out _main(vs_in inp [[stage_in]]) {
  vs_out outp;
  outp.position = inp.position;
  outp.color = inp.color;
  return outp;
}'
	frag = '#include <metal_stdlib>
using namespace metal;
fragment float4 _main(float4 color [[stage_in]]) {
  return color;
};'
)

struct AppState {
mut:
	pip sg_pipeline
	bind sg_bindings
	pass_action sg_pass_action
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
		cleanup_cb: cleanup
		window_title: 'Word up sapp'.str
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
		// positions        colors
         0.0, 0.5, 0.5,  1.0, 0.0, 0.0, 1.0,
         0.5, -0.5, 0.5, 0.0, 1.0, 0.0, 1.0,
        -0.5, -0.5, 0.5, 0.0, 0.0, 1.0, 1.0]!
	state.bind.vertex_buffers[0] = sg_make_buffer(&sg_buffer_desc{
		size: sizeof(f32) * verts.len
		content: verts.data
	})

	shd := sg_make_shader(&sg_shader_desc{
		vs: sg_shader_stage_desc{
			source: vert.str
		}
		fs: sg_shader_stage_desc{
			source: frag.str
		}
	})

	mut layout := sg_layout_desc{}
	layout.attrs[0] = sg_vertex_attr_desc{
		format: C.SG_VERTEXFORMAT_FLOAT3
	}
	layout.attrs[1] = sg_vertex_attr_desc{
		format: C.SG_VERTEXFORMAT_FLOAT4
	}

	state.pip = sg_make_pipeline(&sg_pipeline_desc{
		layout: layout
		shader: shd
	})
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_apply_pipeline(state.pip)
	sg_apply_bindings(&state.bind)
	sg_draw(0, 3, 1)
	sg_end_pass()
	sg_commit()
}

fn cleanup() {
	println('hi cleanup')
}