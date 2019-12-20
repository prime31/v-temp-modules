module c

#flag -I @VMOD/prime31/sokol/thirdparty

#flag darwin -framework Metal -framework Cocoa -framework MetalKit -framework Quartz
#flag darwin -fobjc-arc

$if macos {
	#define SOKOL_METAL
}

#define SOKOL_IMPL
#define SOKOL_NO_DEPRECATED
#include "sokol_gfx.h"

#define SOKOL_IMPL
#define SOKOL_NO_ENTRY
#include "sokol_app.h"

#include "sokol_time.h"