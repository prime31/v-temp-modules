module imgui

pub fn get_io() &ImGuiIo {
	return C.igGetIO()
}

// ImGui lifecycle helpers, wrapping ImGui, SDL2 Impl and GL Impl methods
pub fn init_for_gl(glsl_version byteptr, window voidptr, gl_context voidptr) {
	C.gl3wInit()
	C.igCreateContext(C.NULL)
	C.ImGui_ImplSDL2_InitForOpenGL(window, gl_context)
	C.ImGui_ImplOpenGL3_Init(glsl_version)
}

pub fn new_frame(window voidptr) {
	C.ImGui_ImplOpenGL3_NewFrame()
	C.ImGui_ImplSDL2_NewFrame(window)
	C.igNewFrame()
}

pub fn shutdown() {
    C.ImGui_ImplOpenGL3_Shutdown()
    C.ImGui_ImplSDL2_Shutdown()
    C.igDestroyContext(C.NULL)
}
