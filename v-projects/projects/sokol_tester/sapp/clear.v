import via.libs.sokol
import prime31.sokol.sapp
import via.libs.sokol.gfx

struct AppState {
	pass_action sg_pass_action
}

fn main() {
	state := &AppState{
		pass_action: gfx.create_clear_pass(1.3, 0.3, 1.0, 1.0)
	}

	desc := sapp_desc{
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
		event_userdata_cb: on_event
		cleanup_cb: cleanup
		window_title: 'Word up sapp'.str
	}
	sapp_run(&desc)
}

fn init(user_data voidptr) {
	desc := sg_desc {
		mtl_device: C.sapp_metal_get_device()
		mtl_renderpass_descriptor_cb: sapp_metal_get_renderpass_descriptor
		mtl_drawable_cb: sapp_metal_get_drawable
		d3d11_device: sapp_d3d11_get_device()
		d3d11_device_context: sapp_d3d11_get_device_context()
		d3d11_render_target_view_cb: sapp_d3d11_get_render_target_view
		d3d11_depth_stencil_view_cb: sapp_d3d11_get_depth_stencil_view
	}
	sg_setup(&desc)
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)
	g := state.pass_action.colors[0].val[1] + 0.01
	state.pass_action.colors[0].val[1] = if g > 1.0 { 0.0 } else { g }

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_end_pass()
	sg_commit()
}

fn on_event(evt &C.sapp_event, user_data voidptr) {
	println(evt.str())
}

fn cleanup() {
	println('hi cleanup')
}