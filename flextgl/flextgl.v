module flextgl

#flag darwin -framework OpenGL -framework Cocoa -framework QuartzCore

#flag -I @VMOD/prime31/flextgl/thirdparty
#flag @VMOD/prime31/flextgl/thirdparty/flextGL.o
#include "flextGL.h"

fn C.flextInit() int

pub fn flext_init() int {
	return C.flextInit()
}