module sdl2

pub const (
	version = '0.2'
)

fn init() int {
	C.TTF_Init()
	C.Mix_Init(0)

	C.atexit(C.Mix_Quit)
	C.atexit(C.TTF_Quit)
	C.atexit(C.SDL_Quit)

    return 1
}

pub fn create_texture_from_surface(renderer voidptr, surface &SDL_Surface) voidptr {
    return C.SDL_CreateTextureFromSurface(renderer, voidptr(surface))
}

pub fn create_window_and_renderer(width int, height int, window_flags u32, window voidptr, renderer voidptr) int {
	return C.SDL_CreateWindowAndRenderer(width, height, window_flags, window, renderer)
}

pub fn joystick_name_for_index(device_index int) byteptr {
	return byteptr(C.SDL_JoystickNameForIndex(device_index))
}

pub fn fill_rect(screen &SDL_Surface, rect &SDL_Rect, _col &SDL_Color) {
	col := C.SDL_MapRGB(screen.format, _col.r, _col.g, _col.b)
	_screen := voidptr(screen)
	_rect := voidptr(rect)
	C.SDL_FillRect(_screen, _rect, col)
}

pub fn create_rgb_surface(flags u32, width int, height int, depth int, rmask u32, gmask u32, bmask u32, amask u32) &SDL_Surface {
	res := C.SDL_CreateRGBSurface(flags, width, height, depth, rmask, gmask, bmask, amask)
	return res
}

pub fn render_copy(renderer voidptr, texture voidptr, srcrect &SDL_Rect, dstrect &SDL_Rect) int {
	_srcrect := voidptr(srcrect)
	_dstrect := voidptr(dstrect)
	return C.SDL_RenderCopy(renderer, texture, _srcrect, _dstrect)
}

pub fn poll_event(event &Event) int {
	return C.SDL_PollEvent(voidptr(event))
}

pub fn destroy_texture(text voidptr) {
        C.SDL_DestroyTexture(text)
}

pub fn free_surface(surf &SDL_Surface) {
	_surf := voidptr(surf)
        C.SDL_FreeSurface(_surf)
}

pub fn get_ticks() u32 {
    return C.SDL_GetTicks()
}

pub fn ticks_passed(a, b u32) bool {
    return C.SDL_TICKS_PASSED(a,b)
}

pub fn get_perf_counter() u64 {
    return C.SDL_GetPerformanceCounter()
}

pub fn get_perf_frequency() u64 {
    return C.SDL_GetPerformanceFrequency()
}

pub fn delay(ms u32) {
    C.SDL_Delay(ms)
}
