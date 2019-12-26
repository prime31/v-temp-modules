import prime31.sokol
import prime31.sokol.app
import prime31.sokol.gfx
import prime31.imgui
import prime31.sdl2 as sdl2
import prime31.gl3w

struct AppState {
	pass_action sg_pass_action
mut:
	window voidptr
	gl_context voidptr
	done bool
}

fn main() {
	mut color_action := sg_color_attachment_action {
		action: C.SG_ACTION_CLEAR
	}
	color_action.val[0] = 1.0

	mut pass_action := sg_pass_action{}
	pass_action.colors[0] = color_action

	mut state := &AppState{
		pass_action: pass_action
	}

	state.imgui_init()

	sapp_run(&sapp_desc{
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
		event_userdata_cb: on_event
		cleanup_cb: cleanup
		window_title: 'Word up sapp'.str
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
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)
	g := state.pass_action.colors[0].val[1] + 0.01
	state.pass_action.colors[0].val[1] = if g > 1.0 { 0.0 } else { g }

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_end_pass()
	sg_commit()

	if !state.done {
		state.imgui_tick()
	}
}

fn on_event(evt &C.sapp_event, user_data voidptr) {
	println(evt.str())
}

fn cleanup() {
	printf('cleanup time')
}

fn (state mut AppState) imgui_init() {
	C.SDL_Init(C.SDL_INIT_VIDEO)

    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_FLAGS, C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_PROFILE_MASK, C.SDL_GL_CONTEXT_PROFILE_CORE)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MAJOR_VERSION, 3)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MINOR_VERSION, 2)

	C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
	C.SDL_GL_SetAttribute(C.SDL_GL_DEPTH_SIZE, 24)
	C.SDL_GL_SetAttribute(C.SDL_GL_STENCIL_SIZE, 8)

	window_flags := C.SDL_WINDOW_OPENGL | C.SDL_WINDOW_RESIZABLE | C.SDL_WINDOW_ALLOW_HIGHDPI
	state.window = C.SDL_CreateWindow("V ImGui + SDL2 + Sokol + OpenGL3 demo", 0, 0, 400, 600, window_flags)
	state.gl_context = C.SDL_GL_CreateContext(state.window)

	C.SDL_GL_MakeCurrent(state.window, state.gl_context)
	C.SDL_GL_SetSwapInterval(1) // Enable vsync

	imgui.init_for_gl('#version 150'.str, state.window, state.gl_context)
	C.igStyleColorsDark(C.NULL)
	mut io := imgui.get_io()
	io.ConfigFlags |= C.ImGuiConfigFlags_DockingEnable
}

fn (state mut AppState) imgui_tick() {
	ev := SDL_Event{}
	for 0 < C.SDL_PollEvent(&ev) {
		C.ImGui_ImplSDL2_ProcessEvent(&ev)
		match int(ev.@type) {
			C.SDL_QUIT {
				state.done = true
				imgui.shutdown()

				C.SDL_GL_DeleteContext(state.gl_context)
				C.SDL_VideoQuit()
				C.SDL_Quit()
				app.quit()
				exit(1)
			}
			else {}
		}
	}

	state.imgui_frame()
}

fn (state &AppState) imgui_frame() {
	imgui.new_frame(state.window)
	C.igShowDemoWindow(1)

	// Rendering
	C.igRender()

	io := imgui.get_io()
	C.glViewport(0, 0, int(io.DisplaySize.x), int(io.DisplaySize.y))
	C.glClearColor(0.2, 0.2, 0.2, 1.0)
	C.glClear(C.GL_COLOR_BUFFER_BIT)
	C.ImGui_ImplOpenGL3_RenderDrawData(C.igGetDrawData())
	C.SDL_GL_SwapWindow(state.window)
}