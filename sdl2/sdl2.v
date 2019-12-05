module sdl2


fn init() {
	C.atexit(C.SDL_Quit)
}
