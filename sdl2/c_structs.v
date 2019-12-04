module sdl2

struct C.SDL_RWops {}

pub struct C.SDL_Color {
pub mut:
	r byte
	g byte
	b byte
	a byte
}

pub struct C.SDL_Rect {
pub mut:
	x int
	y int
	w int
	h int
}

pub struct C.SDL_FRect
{
pub mut:
	x f32
	y f32
	w f32
	h f32
}

pub struct C.SDL_Window {}

pub struct C.SDL_Renderer {}

pub struct C.SDL_Texture {}

pub struct C.SDL_Surface {
pub:
	flags u32
	format voidptr
	w int
	h int
	pitch int
	pixels voidptr
	userdata voidptr
	locked int
	lock_data voidptr
	clip_rect SDL_Rect
	map voidptr
	refcount int
}

/////////////////////////////////////////////////////////

pub enum WindowEventID {
	_none
	shown
	hidden
	exposed
	moved
	resized
	size_changed
	minimized
	maximized
	restored
	enter
	leave
	focus_gained
	focus_lost
	close
	take_focus
	hit_test
}

pub struct WindowEvent {
pub:
	_type u32
	timestamp u32
	window_id u32
	window_event byte
	padding1 byte
	padding2 byte
	padding3 byte
	data1 int
	data2 int
}

struct QuitEvent {
	_type u32 /**< SDL_QUIT */
	timestamp u32
}

struct Keysym {
pub:
	scancode int  /**< hardware specific scancode */
	sym int       /**< SDL virtual keysym */
	mod u16       /**< current key modifiers */
	unused u32    /**< translated character */
}

struct KeyboardEvent {
pub:
        _type u32   	/**< SDL_KEYDOWN or SDL_KEYUP */
        timestamp u32
        windowid u32
        state byte  	/**< SDL_PRESSED or SDL_RELEASED */
        repeat byte
        padding2 byte
        padding3 byte
        keysym Keysym
}

struct JoyButtonEvent {
pub:
        _type u32 		/**< SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP */
        timestamp u32
        which int 		/**< The joystick device index */
        button byte		/**< The joystick button index */
        state byte		/**< SDL_PRESSED or SDL_RELEASED */
}

struct JoyHatEvent {
pub:
        _type u32       /**< SDL_JOYHATMOTION */
        timestamp u32
        which int       /**< The joystick device index */
        hat byte        /**< The joystick hat index */
        value byte      /**< The hat position value:
			             *   SDL_HAT_LEFTUP   SDL_HAT_UP       SDL_HAT_RIGHTUP
			             *   SDL_HAT_LEFT     SDL_HAT_CENTERED SDL_HAT_RIGHT
			             *   SDL_HAT_LEFTDOWN SDL_HAT_DOWN     SDL_HAT_RIGHTDOWN
			             *  Note that zero means the POV is centered.
			             */
}

pub union Event {
pub:
	_type u32
	window WindowEvent
	quit QuitEvent
	key KeyboardEvent
	jbutton JoyButtonEvent
	jhat JoyHatEvent
	_pad56 [56]byte
}

pub struct C.SDL_AudioSpec {
pub mut:
        freq int                           /**< DSP frequency -- samples per second */
        format u16                         /**< Audio data format */
        channels byte                      /**< Number of channels: 1 mono, 2 stereo */
        silence byte                       /**< Audio buffer silence value (calculated) */
        samples u16                        /**< Audio buffer size in samples (power of 2) */
        size u32                           /**< Necessary for some compile environments */
        callback voidptr
        userdata voidptr
}


// MIX TODO: get this working as a return type
pub struct C.Mix_Chunk {
    allocated int
    abuf &byte // *UInt8
    alen u32
    volume byte       /* Per-sample volume, 0-128 */
}

pub struct C.Mix_Music {}