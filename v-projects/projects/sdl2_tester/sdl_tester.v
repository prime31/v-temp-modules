import prime31.sdl2

fn main() {
	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_AUDIO | C.SDL_INIT_JOYSTICK)

	window := voidptr(0)
	renderer := voidptr(0)
	sdl2.create_window_and_renderer(500, 300, 0, &window, &renderer)
	C.SDL_SetWindowTitle(window, 'V + SDL2')

	if C.Mix_OpenAudio(48000, C.MIX_DEFAULT_FORMAT, 2, 1024) < 0 {
		println('couldn\'t open audio')
	}

	music := C.Mix_LoadMUS('sounds/TwintrisThosenine.mod')
	println('mus $music')
	if C.Mix_PlayMusic(music, 1) != -1 {
		C.Mix_VolumeMusic(C.SDL_MIX_MAXVOLUME)
	}

	wave := C.Mix_LoadWAV('sounds/triple.wav')
	C.Mix_PlayChannel(0, wave, 0)

	C.IMG_Init(C.IMG_INIT_PNG)
	v_logo := C.IMG_Load('images/v-logo_30_30.png')

	mut tv_logo := voidptr(0)
	if !isnil(v_logo) {
		println('got v_logo=$v_logo')
		tv_logo = sdl2.create_texture_from_surface(renderer, v_logo)
	}

	mut should_close := false

	for {
		start_ticks := C.SDL_GetPerformanceCounter()

		ev := sdl2.Event{}
		for 0 < sdl2.poll_event(&ev) {
			match int(ev._type) {
				C.SDL_QUIT { should_close = true }
				C.SDL_KEYDOWN {
					key := int(ev.key.keysym.sym)
					if key == C.SDLK_ESCAPE {
					        should_close = true
					        break
					}
					//game.handle_key(key)
					println('KEY fucker $key')
				}
				C.SDL_JOYBUTTONDOWN {
					jb := int(ev.jbutton.button)
					joyid := int(ev.jbutton.which)
					println('JOY BUTTON $jb $joyid')
					//game.handle_jbutton(jb, joyid)
				}
				C.SDL_JOYHATMOTION {
					jh := int(ev.jhat.hat)
					jv := int(ev.jhat.value)
					joyid := int(ev.jhat.which)
					println('JOY HAT $jh $jv $joyid')
					//game.handle_jhat(jh, jv, joyid)
				}

				C.SDL_WINDOWEVENT {
					println('win=$ev.window.window_event')
					if ev.window.window_event == C.SDL_WINDOWEVENT_MOVED {
						println('moved da win')
					}
				}
			}
		}
		if should_close {
			break
		}

		C.SDL_SetRenderDrawColor(renderer, 55, 55, 55, 255)
		C.SDL_RenderClear(renderer)

		mut rect := C.SDL_FRect {0, 0, 50, 30}
		C.SDL_SetRenderDrawColor(renderer, 155, 155, 55, 255)
		C.SDL_RenderDrawRectF(renderer, &rect)

		rect.x = 100
		rect.y = 100
		C.SDL_RenderFillRectF(renderer, &rect)

		dstrect := sdl2.Rect { 200, 200, 30, 30 }
		C.SDL_RenderCopy(renderer, tv_logo, voidptr(0), voidptr(&dstrect))

		C.SDL_RenderPresent(renderer)
	}

	C.Mix_FreeChunk(wave)
	C.Mix_FreeMusic(music)
}
