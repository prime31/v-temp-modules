module gl3w

#flag -I @VMOD/prime31/gl3w/thirdparty
#flag @VMOD/prime31/gl3w/thirdparty/gl3w.o
#flag darwin -framework OpenGL -framework Cocoa

#include <GL/gl3w.h>    // Initialize with gl3wInit()

fn C.gl3wInit()
fn C.gl3wIsSupported(major int, minor int) int
fn C.gl3wGetProcAddress(proc byteptr) voidptr

pub fn initialize() {
	C.gl3wInit()
}