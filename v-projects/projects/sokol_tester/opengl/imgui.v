import prime31.sokol
import prime31.sokol.app
import prime31.sokol.gfx
import prime31.sokol.simgui
import prime31.sokol.time

struct AppState {
	pass_action sg_pass_action
	last_time u64
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
		event_userdata_cb: on_event
		cleanup_cb: cleanup
		window_title: 'Sokol ImGui'.str
	})
}

fn init(user_data voidptr) {
	sg_setup(&sg_desc {
		mtl_device: C.sapp_metal_get_device()
		mtl_renderpass_descriptor_cb: sapp_metal_get_renderpass_descriptor
		mtl_drawable_cb: sapp_metal_get_drawable
		d3d11_device: sapp_d3d11_get_device()
		d3d11_device_context: sapp_d3d11_get_device_context()
		d3d11_render_target_view_cb: sapp_d3d11_get_render_target_view
		d3d11_depth_stencil_view_cb: sapp_d3d11_get_depth_stencil_view
	})

	time.setup()
	d := &C.simgui_desc_t{}
	simgui.setup(d)
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)
	g := state.pass_action.colors[0].val[1] + 0.01
	state.pass_action.colors[0].val[1] = if g > 1.0 { 0.0 } else { g }

    delta_time := time.sec(time.laptime(&state.last_time))
    simgui.new_frame(app.width(), app.height(), delta_time)
	C.igShowDemoWindow(true)

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	simgui.render()
	sg_end_pass()
	sg_commit()
}

fn on_event(evt &C.sapp_event, user_data voidptr) {
	println(evt.str())
	simgui.handle_event(evt)
}

fn cleanup() {
	println('hi cleanup')
	simgui.shutdown()
}

fn C.igShowDemoWindow()