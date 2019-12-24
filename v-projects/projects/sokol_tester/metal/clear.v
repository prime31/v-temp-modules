import prime31.sokol
import prime31.sokol.app
import prime31.sokol.gfx

struct AppState {
	pass_action sg_pass_action
}

fn main() {
	mut color_action := sg_color_attachment_action {
		action: C.SG_ACTION_CLEAR
	}
	color_action.val[0] = 1.0

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
	state := &AppState(user_data)

	sg_setup(&sg_desc {
		mtl_device: C.sapp_metal_get_device()
		mtl_renderpass_descriptor_cb: sapp_metal_get_renderpass_descriptor
		mtl_drawable_cb: sapp_metal_get_drawable
		d3d11_device: sapp_d3d11_get_device()
		d3d11_device_context: sapp_d3d11_get_device_context()
		d3d11_render_target_view_cb: sapp_d3d11_get_render_target_view
		d3d11_depth_stencil_view_cb: sapp_d3d11_get_depth_stencil_view
	})
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)
	g := state.pass_action.colors[0].val[1] + 0.01
	state.pass_action.colors[0].val[1] = if g > 1.0 { 0.0 } else { g }

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_end_pass()
	sg_commit()
}

fn cleanup() {
	println('hi cleanup')
}