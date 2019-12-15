module physfs
import prime31.sdl2
import prime31.sdl2.image

const ( image_version = image.version )

pub fn load_surface(fname byteptr) &C.SDL_Surface {
	rwops := C.PHYSFSRWOPS_openRead(fname)
	return C.IMG_Load_RW(rwops, 0)
}

pub fn load_texture(renderer &SDL_Renderer, fname byteptr, freesrc int) &C.SDL_Texture {
	src := C.PHYSFSRWOPS_openRead(fname)
	return C.IMG_LoadTexture_RW(renderer, src, freesrc)
}