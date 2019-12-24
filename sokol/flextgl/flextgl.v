module flextgl

#flag -I @VMOD/prime31/sokol/thirdparty/flextgl
#flag darwin -framework OpenGL -framework Cocoa -framework QuartzCore
#flag @VMOD/prime31/sokol/thirdparty/flextgl/flextGL.o
#include "flextGL.h"

fn C.flextInit() int

pub fn flext_init() int {
	return C.flextInit()
}