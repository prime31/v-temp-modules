module image
import prime31.sdl2

#flag -lSDL2_image
#include <SDL_image.h>

pub const (
	IMG_INIT_JPG = 0x00000001
    IMG_INIT_PNG = 0x00000002
    IMG_INIT_TIF = 0x00000004
    IMG_INIT_WEBP = 0x00000008
    version = sdl2.version
)

fn C.IMG_Init(flags int) int
fn C.IMG_Quit()

/* Load an image from an SDL data source. The 'type' may be one of: "BMP", "GIF", "PNG", etc. */
fn C.IMG_LoadTyped_RW(src &SDL_RWops, freesrc int, _type byteptr) &C.SDL_Surface
fn C.IMG_Load(file byteptr) &C.SDL_Surface
fn C.IMG_Load_RW(src &SDL_RWops, freesrc int) &C.SDL_Surface

/* Load an image directly into a render texture. */
fn C.IMG_LoadTexture(renderer &SDL_Renderer, file byteptr) &C.SDL_Texture
fn C.IMG_LoadTexture_RW(renderer &SDL_Renderer, src &SDL_RWops, freesrc int) &C.SDL_Texture
fn C.IMG_LoadTextureTyped_RW(renderer &SDL_Renderer, src &SDL_RWops, freesrc int, _type byteptr) &C.SDL_Texture

/* Functions to detect a file type, given a seekable source */
fn C.IMG_isPNG(src &SDL_RWops) int
fn C.IMG_isBMP(src &SDL_RWops) int
fn C.IMG_isJPG(src &SDL_RWops) int
fn C.IMG_isWEBP(src &SDL_RWops) int

/* Individual loading functions */
fn C.IMG_LoadPNG_RW(src &SDL_RWops) &C.SDL_Surface
fn C.IMG_LoadBMP_RW(src &SDL_RWops) &C.SDL_Surface
fn C.IMG_LoadJPG_RW(src &SDL_RWops) &C.SDL_Surface
fn C.IMG_LoadWEBP_RW(src &SDL_RWops) &C.SDL_Surface

/* Individual saving functions */
fn C.IMG_SavePNG(surface voidptr, file byteptr) int
fn C.IMG_SavePNG_RW(surface voidptr, dst &SDL_RWops, freedst int) int
fn C.IMG_SaveJPG(surface voidptr, file byteptr) int
fn C.IMG_SaveJPG_RW(surface voidptr, dst &SDL_RWops, freedst int) int