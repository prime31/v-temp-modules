module sdl2

// not sure why we have to import ourself here...
import prime31.sdl2


#flag linux -lSDL2_image
#include <SDL_image.h>

#flag darwin -L/usr/local/lib -lSDL2_IMAGE
#flag darwin -I /usr/local/opt/sdl2_image/include/SDL2

#flag windows -I/msys64/mingw64/include/SDL2
#flag windows -L/mingw64/lib -lSDL2_image

// C declarations
//-----------------------
//fn C.IMG_Load_RW(logo &vsdl2.RwOps, free_src int) &vsdl2.Surface
fn C.IMG_Init(flags int) int
fn C.IMG_Quit()
fn C.IMG_Load(file byteptr) voidptr


// module wrapper functions
//-----------------------
pub fn img_init(flags int) int {
	return C.IMG_Init(flags)
}

pub fn quit() {
	C.IMG_Quit()
}

pub fn load(file string) &sdl2.Surface {
	res := C.IMG_Load(file.str)
	return res
}
