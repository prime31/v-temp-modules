module sdl2

pub const (
	MIX_MAX_VOLUME = 128
)

fn init() {
	C.TTF_Init()
	C.Mix_Init(0)

	C.atexit(C.Mix_Quit)
	C.atexit(C.TTF_Quit)
	C.atexit(C.SDL_Quit)
}
