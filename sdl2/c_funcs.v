module sdl2

fn C.atexit(func fn ())

///////////////////////////////////////////////////
fn C.SDL_MapRGB(fmt voidptr byte, g byte, b byte) u32
fn C.SDL_CreateRGBSurface(flags u32, width int, height int, depth int, Rmask u32, Gmask u32, Bmask u32, Amask u32) voidptr
fn C.SDL_PollEvent(&Event) int
fn C.SDL_NumJoysticks() int
fn C.SDL_JoystickNameForIndex(device_index int) voidptr
fn C.SDL_RenderCopy(renderer &SDL_Renderer, texture voidptr, srcrect voidptr, dstrect voidptr) int
fn C.SDL_CreateWindow(title byteptr, x int, y int, w int, h int, flags u32) voidptr
fn C.SDL_CreateWindowAndRenderer(width int, height int, window_flags u32, window &SDL_Window, renderer &SDL_Renderer) int
fn C.SDL_DestroyWindow(window voidptr)
fn C.SDL_GetWindowSize(window voidptr, w &int, h &int)
fn C.SDL_SetHint(name byteptr, value byteptr) C.SDL_bool
//fn C.SDL_RWFromFile(byteptr, byteptr) &RwOps
//fn C.SDL_CreateTextureFromSurface(renderer &C.SDL_Renderer, surface &C.SDL_Surface) &C.SDL_Texture
fn C.SDL_CreateTextureFromSurface(renderer voidptr, surface voidptr) voidptr
fn C.SDL_CreateTexture(renderer &SDL_Renderer, format u32, access int, w int, h int) voidptr
fn C.SDL_SetRenderTarget(renderer &SDL_Renderer, texture &SDL_Texture) int
fn C.SDL_FillRect(dst voidptr, dstrect voidptr, color u32) int
fn C.SDL_SetRenderDrawColor(renderer voidptr, r byte, g byte, b byte, a byte)
fn C.SDL_RenderPresent(renderer voidptr)
fn C.SDL_RenderClear(renderer voidptr) int
fn C.SDL_UpdateTexture(texture voidptr, rect voidptr, pixels voidptr, pitch int) int
fn C.SDL_QueryTexture(texture voidptr, format voidptr, access voidptr, w voidptr, h voidptr) int
fn C.SDL_DestroyTexture(texture voidptr)

fn C.SDL_RenderDrawRectF(renderer voidptr, rect voidptr)
fn C.SDL_RenderFillRectF(renderer voidptr, rect voidptr)

fn C.SDL_FreeSurface(surface voidptr)
fn C.SDL_Init(flags u32) int
fn C.SDL_Quit()
fn C.SDL_SetWindowTitle(window voidptr, title byteptr)

// following is wrong : SDL_Zero is a macro accepting an argument
fn C.SDL_zero()
fn C.SDL_LoadWAV(file byteptr, spec voidptr, audio_buf voidptr, audio_len voidptr) voidptr
fn C.SDL_FreeWAV(audio_buf voidptr)
fn C.SDL_OpenAudio(desired voidptr, obtained voidptr) int
fn C.SDL_CloseAudio()
fn C.SDL_PauseAudio(pause_on int)

fn C.SDL_JoystickOpen(device_index int) int
fn C.SDL_JoystickEventState(state int) int

// SDL_Timer.h
fn C.SDL_GetTicks() u32
fn C.SDL_TICKS_PASSED(a,b u32) bool
fn C.SDL_GetPerformanceCounter() u64
fn C.SDL_GetPerformanceFrequency() u64
fn C.SDL_Delay(ms u32)


// TTF
fn C.TTF_Init() int
fn C.TTF_Quit()
fn C.TTF_OpenFont(file byteptr, ptsize int) voidptr
fn C.TTF_CloseFont(font voidptr)
//fn C.TTF_RenderText_Solid(voidptr, voidptr, SdlColor) voidptr
fn C.TTF_RenderText_Solid(voidptr, voidptr, C.SDL_Color) voidptr


// MIX
fn C.Mix_Init(flags int) int
fn C.Mix_OpenAudio(frequency int, format u16, channels int, chunksize int) int
fn C.Mix_CloseAudio()

fn C.Mix_LoadMUS(file byteptr) voidptr // *Mix_Music
fn C.Mix_LoadMUS_RW(src &SDL_RWops, freesrc int) voidptr // *Mix_Music
fn C.Mix_LoadWAV(file byteptr) voidptr // *Mix_Chunk
fn C.Mix_LoadWAV_RW(src &SDL_RWops, freesrc int) voidptr // *Mix_Chunk

// Music
fn C.Mix_FadeInMusic(music &Mix_Music, loops int, ms int) int
fn C.Mix_PlayMusic(music &SDL_AudioSpec, loops int) int
fn C.Mix_VolumeMusic(volume int) int
fn C.Mix_PauseMusic()
fn C.Mix_ResumeMusic()
fn C.Mix_RewindMusic()
fn C.Mix_SetMusicPosition(position f64) int
fn C.Mix_PausedMusic() int
fn C.Mix_HaltMusic() int
fn C.Mix_FadeOutMusic(ms int) int
fn C.Mix_HookMusicFinished(cb fn())
fn C.Mix_FreeMusic(music &Mix_Music)

// Channels
fn C.Mix_VolumeChunk(chunk &Mix_Chunk, volume int) int
fn C.Mix_PlayChannel(channel int, chunk &Mix_Chunk, loops int) int
fn C.Mix_FadeInChannel(channel int, chunk &Mix_Chunk, loops int, ms int) int
fn C.Mix_PlayChannelTimed(channel int, chunk &Mix_Chunk, loops int, ticks int) int
fn C.Mix_Pause(channel int)
fn C.Mix_Resume(channel int)
fn C.Mix_HaltChannel(channel int) int
fn C.Mix_ExpireChannel(channel int, ticks int) int
fn C.Mix_FadeOutChannel(channel int, ms int) int
fn C.Mix_ChannelFinished(cb fn (int))
fn C.Mix_Playing(channel int) int
fn C.Mix_Paused(channel int) int
fn C.Mix_GetChunk(channel int) voidptr //Mix_Chunk
fn C.Mix_FreeChunk(chunk &Mix_Chunk)

// TODO: Groups

const (
	MIX_CHANNEL_POST = -2
)

// Effects
type EffectFunc fn (int, voidptr, int, voidptr) // int chan, void *stream, int len, void *udata
type EffectDone fn (int, voidptr) // int chan, void *udata

fn C.Mix_RegisterEffect(channel int, f EffectFunc, d EffectDone, arg voidptr) int
fn C.Mix_UnregisterEffect(channel int, f EffectFunc) int
fn C.Mix_UnregisterAllEffects(channel int) int
fn C.Mix_SetPanning(channel int, left byte, right byte) int
fn C.Mix_SetDistance(channel int, distance byte) int
fn C.Mix_SetPosition(channel int, angle i16, distance byte) int
fn C.Mix_SetReverseStereo(channel int, flip int) int


// GL
fn C.SDL_GL_SetAttribute(attr int, value int) int
fn C.SDL_GL_CreateContext(window voidptr) voidptr
fn C.SDL_GL_MakeCurrent(window voidptr, context voidptr) int
fn C.SDL_GL_SetSwapInterval(interval int) int
fn C.SDL_GL_SwapWindow(window voidptr)
fn C.SDL_GL_DeleteContext(context voidptr)