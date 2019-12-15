module sdl2
import prime31.sdl2.c

pub const ( version = c.version )

fn init() {
	C.atexit(C.SDL_Quit)
}
