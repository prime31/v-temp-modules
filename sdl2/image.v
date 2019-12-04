module sdl2

#flag linux -lSDL2_image
#include <SDL_image.h>

#flag darwin -L/usr/local/lib -lSDL2_IMAGE
#flag darwin -I /usr/local/opt/sdl2_image/include/SDL2

#flag windows -I/msys64/mingw64/include/SDL2
#flag windows -L/mingw64/lib -lSDL2_image

const (
	IMG_INIT_JPG = 0x00000001
    IMG_INIT_PNG = 0x00000002
    IMG_INIT_TIF = 0x00000004
    IMG_INIT_WEBP = 0x00000008
)

fn C.IMG_Init(flags int) int
fn C.IMG_Quit()

fn C.IMG_LoadTyped_RW(src &SDL_RWops, freesrc int, _type byteptr) &SDL_Surface
fn C.IMG_Load(file byteptr) voidptr
fn C.IMG_Load_RW(src &SDL_RWops, freesrc int) voidptr

/* Functions to detect a file type, given a seekable source */
fn C.IMG_isPNG(src &SDL_RWops) int
fn C.IMG_isBMP(src &SDL_RWops) int
fn C.IMG_isJPG(src &SDL_RWops) int
fn C.IMG_isWEBP(src &SDL_RWops) int

/* Individual loading functions */
fn C.IMG_LoadPNG_RW(src &SDL_RWops) voidptr
fn C.IMG_LoadBMP_RW(src &SDL_RWops) voidptr
fn C.IMG_LoadJPG_RW(src &SDL_RWops) voidptr
fn C.IMG_LoadWEBP_RW(src &SDL_RWops) voidptr

/* Individual saving functions */
fn C.IMG_SavePNG(surface voidptr, file byteptr) int
fn C.IMG_SavePNG_RW(surface voidptr, dst &SDL_RWops, freedst int) int
fn C.IMG_SaveJPG(surface voidptr, file byteptr) int
fn C.IMG_SaveJPG_RW(surface voidptr, dst &SDL_RWops, freedst int) int