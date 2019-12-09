import prime31.sdl2
import prime31.sdl2.image
import prime31.sdl2.mixer as mixer
import prime31.sdl2.ttf as ttf
import os
import time

struct FpsCounter {
mut:
	fps_lasttime u32 //the last recorded time.
	fps_current u32 //the current FPS.
	fps_frames u32 //frames passed since the last recorded fps.
}

fn main() {
	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_AUDIO | C.SDL_INIT_JOYSTICK)

	window := C.SDL_CreateWindow('V + SDL2', 300, 300, 500, 300, 0)
	renderer := C.SDL_CreateRenderer(window, -1, C.SDL_RENDERER_ACCELERATED | C.SDL_RENDERER_PRESENTVSYNC)

	C.Mix_Init(0)
	if C.Mix_OpenAudio(48000, mixer.MIX_DEFAULT_FORMAT, 2, 1024) < 0 {
		println('couldn\'t open audio')
	}

	music := C.Mix_LoadMUS('sounds/TwintrisThosenine.mod')
	println('mus $music')
	C.Mix_FadeInMusic(music, -1, 5000)
	// C.Mix_PlayMusic(music, 1)

	wave := C.Mix_LoadWAV('sounds/triple.wav')
	// C.Mix_PlayChannel(0, wave, 0)
	C.Mix_FadeInChannel(0, wave, 2, 3000)
	C.Mix_ChannelFinished(channel_finished)

	defer {
		C.Mix_FreeChunk(wave)
		C.Mix_FreeMusic(music)
		C.Mix_CloseAudio()
	}

	C.IMG_Init(C.IMG_INIT_PNG)
	tv_logo := C.IMG_LoadTexture(renderer, 'images/v-logo_30_30.png')

	mut should_close := false
	mut fps := FpsCounter{}
	fps.init()

	for {
		ev := sdl2.Event{}
		for 0 < C.SDL_PollEvent(&ev) {
			match int(ev._type) {
				C.SDL_QUIT { should_close = true }
				C.SDL_KEYDOWN {
					key := ev.key.keysym.sym
					if key == C.SDLK_ESCAPE {
					        should_close = true
					        break
					}
					//game.handle_key(key)
					println('KEY fucker $key')
				}
				C.SDL_JOYBUTTONDOWN {
					jb := int(ev.jbutton.button)
					joyid := ev.jbutton.which
					println('JOY BUTTON $jb $joyid')
					//game.handle_jbutton(jb, joyid)
				}
				C.SDL_JOYHATMOTION {
					jh := int(ev.jhat.hat)
					jv := int(ev.jhat.value)
					joyid := ev.jhat.which
					println('JOY HAT $jh $jv $joyid')
					//game.handle_jhat(jh, jv, joyid)
				}
				C.SDL_WINDOWEVENT {
					println('win=$ev.window.window_event')
					if ev.window.window_event == C.SDL_WINDOWEVENT_MOVED {
						println('moved da win')
					}
				}
				else {}
			}
		}
		if should_close {
			break
		}

		C.SDL_SetRenderDrawColor(renderer, 55, 55, 55, 255)
		C.SDL_RenderClear(renderer)

		draw_text(renderer, 200, 100, 'holy fucking shit', SDL_Color{255, 100, 155, 255})

		mut rect := SDL_FRect {0, 0, 50, 30}
		C.SDL_SetRenderDrawColor(renderer, 155, 155, 55, 255)
		C.SDL_RenderDrawRectF(renderer, &rect)

		rect.x = 100
		rect.y = 100
		C.SDL_RenderFillRectF(renderer, &rect)

		dstrect := SDL_Rect { 200, 200, 30, 30 }
		C.SDL_RenderCopy(renderer, tv_logo, voidptr(0), voidptr(&dstrect))

		C.SDL_RenderPresent(renderer)

		fps.tick()
	}
}

fn channel_finished(channel int) {
	println('channel_finished $channel')
}

[live]
fn draw_text(renderer &SDL_Renderer, x int, y int, text string, color SDL_Color) {
	C.TTF_Init()
	font := C.TTF_OpenFont('fonts/RobotoMono-Regular.ttf'.str, 16)

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

fn (fps mut FpsCounter) init() {
	fps.fps_lasttime = C.SDL_GetTicks()
	fps.fps_frames = 0
}

fn (fps mut FpsCounter) tick() {
	fps.fps_frames++
	if fps.fps_lasttime < SDL_GetTicks() - u32(1000) {
		fps.fps_lasttime = SDL_GetTicks()
		fps.fps_current = fps.fps_frames
		fps.fps_frames = 0
		println('fps=$fps.fps_current')
	}
}