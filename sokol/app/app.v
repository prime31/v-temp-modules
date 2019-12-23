module app

#define SOKOL_IMPL
#define SOKOL_NO_ENTRY
#include "sokol_app.h"

/* returns true after sokol-app has been initialized */
[inline]
pub fn sapp_isvalid() bool {
	return C.sapp_isvalid()
}

/* returns the current framebuffer width in pixels */
[inline]
pub fn sapp_width() int {
	return C.sapp_width()
}

/* returns the current framebuffer height in pixels */
[inline]
pub fn sapp_height() int {
	return C.sapp_height()
}

/* returns true when high_dpi was requested and actually running in a high-dpi scenario */
[inline]
pub fn sapp_high_dpi() bool {
	return C.sapp_high_dpi()
}

/* returns the dpi scaling factor (window pixels to framebuffer pixels) */
[inline]
pub fn sapp_dpi_scale() f32 {
	return C.sapp_dpi_scale()
}

/* show or hide the mobile device onscreen keyboard */
[inline]
pub fn sapp_show_keyboard(visible bool) {
	C.sapp_show_keyboard(visible)
}

/* return true if the mobile device onscreen keyboard is currently shown */
[inline]
pub fn sapp_keyboard_shown() bool {
	return C.sapp_keyboard_shown()
}

/* show or hide the mouse cursor */
[inline]
pub fn sapp_show_mouse(visible bool) {
	C.sapp_show_mouse(visible)
}

/* show or hide the mouse cursor */
[inline]
pub fn sapp_mouse_shown() bool {
	return C.sapp_mouse_shown()
}

/* return the userdata pointer optionally provided in sapp_desc */
[inline]
pub fn sapp_userdata() voidptr {
	return C.sapp_userdata()
}

/* return a copy of the sapp_desc structure */
[inline]
pub fn sapp_query_desc() C.sapp_desc {
	return C.sapp_query_desc()
}

/* initiate a "soft quit" (sends SAPP_EVENTTYPE_QUIT_REQUESTED) */
[inline]
pub fn sapp_request_quit() {
	C.sapp_request_quit()
}

/* cancel a pending quit (when SAPP_EVENTTYPE_QUIT_REQUESTED has been received) */
[inline]
pub fn sapp_cancel_quit() {
	C.sapp_cancel_quit()
}

/* intiate a "hard quit" (quit application without sending SAPP_EVENTTYPE_QUIT_REQUSTED) */
[inline]
pub fn sapp_quit() {
	C.sapp_quit()
}

/* call from inside event callback to consume the current event (don't forward to platform) */
[inline]
pub fn sapp_consume_event() {
	C.sapp_consume_event()
}

/* get the current frame counter (for comparison with sapp_event.frame_count) */
[inline]
pub fn sapp_frame_count() u64 {
	return C.sapp_frame_count()
}

/* write string into clipboard */
[inline]
pub fn sapp_set_clipboard_string(str byteptr) {
	C.sapp_set_clipboard_string(str)
}

/* read string from clipboard (usually during SAPP_EVENTTYPE_CLIPBOARD_PASTED) */
[inline]
pub fn sapp_get_clipboard_string() byteptr {
	return C.sapp_get_clipboard_string()
}

/* special run-function for SOKOL_NO_ENTRY (in standard mode this is an empty stub) */
[inline]
pub fn sapp_run(desc &C.sapp_desc) int {
	return C.sapp_run(desc)
}

/* GL: return true when GLES2 fallback is active (to detect fallback from GLES3) */
[inline]
pub fn sapp_gles2() bool {
	return C.sapp_gles2()
}

/* HTML5: enable or disable the hardwired "Leave Site?" dialog box */
[inline]
pub fn sapp_html5_ask_leave_site(ask bool) {
	C.sapp_html5_ask_leave_site(ask)
}

/* Metal: get ARC-bridged pointer to Metal device object */
[inline]
pub fn sapp_metal_get_device() voidptr {
	return C.sapp_metal_get_device()
}

/* Metal: get ARC-bridged pointer to this frame's renderpass descriptor */
[inline]
pub fn sapp_metal_get_renderpass_descriptor() voidptr {
	return C.sapp_metal_get_renderpass_descriptor()
}

/* Metal: get ARC-bridged pointer to current drawable */
[inline]
pub fn sapp_metal_get_drawable() voidptr {
	return C.sapp_metal_get_drawable()
}

/* macOS: get ARC-bridged pointer to macOS NSWindow */
[inline]
pub fn sapp_macos_get_window() voidptr {
	return C.sapp_macos_get_window()
}

/* iOS: get ARC-bridged pointer to iOS UIWindow */
[inline]
pub fn sapp_ios_get_window() voidptr {
	return C.sapp_ios_get_window()
}

/* D3D11: get pointer to ID3D11Device object */
[inline]
pub fn sapp_d3d11_get_device() voidptr {
	return C.sapp_d3d11_get_device()
}

/* D3D11: get pointer to ID3D11DeviceContext object */
[inline]
pub fn sapp_d3d11_get_device_context() voidptr {
	return C.sapp_d3d11_get_device_context()
}

/* D3D11: get pointer to ID3D11RenderTargetView object */
[inline]
pub fn sapp_d3d11_get_render_target_view() voidptr {
	return C.sapp_d3d11_get_render_target_view()
}

/* D3D11: get pointer to ID3D11DepthStencilView */
[inline]
pub fn sapp_d3d11_get_depth_stencil_view() voidptr {
	return C.sapp_d3d11_get_depth_stencil_view()
}

/* Win32: get the HWND window handle */
[inline]
pub fn sapp_win32_get_hwnd() voidptr {
	return C.sapp_win32_get_hwnd()
}

