module simgui
import via.libs.imgui.c


#include "sokol_gfx.h"

// optionally don't depend on sokol_app.h
// #define SOKOL_IMGUI_NO_SOKOL_APP
#define SOKOL_IMGUI_IMPL
#include "sokol_imgui.h"

[inline]
pub fn setup(desc &C.simgui_desc_t) {
	C.simgui_setup(desc)
}

[inline]
pub fn new_frame(width int, height int, delta_time f64) {
	C.simgui_new_frame(width, height, delta_time)
}

[inline]
pub fn render() {
	C.simgui_render()
}

// remove if not using Sokol app and ensure SOKOL_IMGUI_NO_SOKOL_APP is defined
[inline]
pub fn handle_event(ev &C.sapp_event) bool {
	return C.simgui_handle_event(ev)
}

[inline]
pub fn shutdown() {
	C.simgui_shutdown()
}

