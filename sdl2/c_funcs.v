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
fn C.SDL_CreateRenderer(window &SDL_Window, index int, flags u32) voidptr
fn C.SDL_DestroyWindow(window voidptr)
fn C.SDL_DestroyRenderer(renderer voidptr)
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
fn C.SDL_RenderFillRect(renderer voidptr, rect voidptr)
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


// GL
fn C.SDL_GL_SetAttribute(attr int, value int) int
fn C.SDL_GL_CreateContext(window voidptr) voidptr
fn C.SDL_GL_MakeCurrent(window voidptr, context voidptr) int
fn C.SDL_GL_SetSwapInterval(interval int) int
fn C.SDL_GL_SwapWindow(window voidptr)
fn C.SDL_GL_DeleteContext(context voidptr)