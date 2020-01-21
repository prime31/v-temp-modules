import emscripten
import via.libs.sdl2
import prime31.sdl2.image
import prime31.sdl2.ttf

struct State{
mut:
	renderer voidptr
	window voidptr
	tv_logo voidptr
}


fn init_sdl() &State {
	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_AUDIO)

	win := C.SDL_CreateWindow('V + SDL2', 300, 300, 500, 300, C.SDL_WINDOW_OPENGL | C.SDL_WINDOW_MOUSE_FOCUS)
	return &State{
		window: win
		renderer: C.SDL_CreateRenderer(win, -1, C.SDL_RENDERER_ACCELERATED | C.SDL_RENDERER_PRESENTVSYNC)
	}
}

fn main() {
	mut state := init_sdl()

	C.IMG_Init(C.IMG_INIT_PNG)
	state.tv_logo = C.IMG_LoadTexture(state.renderer, '../assets/v-logo_30_30.png')

	$if wasm? {
		emscripten_set_main_loop_arg(main_loop, voidptr(state), -1, 0)
	}

	$if !wasm? {
		for {
			main_loop(voidptr(state))
		}
	}
}

fn main_loop(context voidptr) {
	if poll_events() {
		C.SDL_Quit()
	}
	state := &State(context)

	C.SDL_SetRenderDrawColor(state.renderer, 55, 55, 55, 255)
	C.SDL_RenderClear(state.renderer)

	draw_text(state.renderer, 200, 100, 'TTF in the WASM', SDL_Color{255, 100, 155, 255})

	mut rect := SDL_Rect {0, 0, 50, 30}
	C.SDL_SetRenderDrawColor(state.renderer, 155, 155, 55, 255)
	C.SDL_RenderDrawRect(state.renderer, &rect)

	rect.x = 100
	rect.y = 100
	C.SDL_RenderFillRect(state.renderer, &rect)

	dstrect := SDL_Rect { 200, 200, 30, 30 }
	C.SDL_RenderCopy(state.renderer, state.tv_logo, voidptr(0), voidptr(&dstrect))

	C.SDL_RenderPresent(state.renderer)
}

fn poll_events() bool {
	ev := SDL_Event{}
	for 0 < C.SDL_PollEvent(&ev) {
		match int(ev.@type) {
			C.SDL_QUIT {
				return true
			}
			C.SDL_WINDOWEVENT {
				if ev.window.event == C.SDL_WINDOWEVENT_CLOSE {
					return true
				}
			}
			else {}
		}
	}

	return false
}

fn draw_text(renderer &SDL_Renderer, x int, y int, text string, color SDL_Color) {
	C.TTF_Init()
	font := C.TTF_OpenFont('../assets/RobotoMono-Regular.ttf'.str, 16)

	defer {
		C.TTF_CloseFont(font)
		C.TTF_Quit()
	}

	// surface := C.TTF_RenderText_Solid(font, text.str, color)
	surface := C.TTF_RenderText_Shaded(font, text.str, color, SDL_Color{0, 0, 0, 255})
	ttext := C.SDL_CreateTextureFromSurface(renderer, surface)
	C.SDL_FreeSurface(surface)

	texw := 0
	texh := 0
	C.SDL_QueryTexture(ttext, 0, 0, &texw, &texh)
	dstrect := SDL_Rect { x, y, texw, texh }

	C.SDL_RenderCopy(renderer, ttext, voidptr(0), voidptr(&dstrect))
	C.SDL_DestroyTexture(ttext)
}
