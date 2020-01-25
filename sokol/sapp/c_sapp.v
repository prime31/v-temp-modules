module sapp

#flag -I @VMOD/prime31/sokol/thirdparty
#flag -I @VMOD/prime31/sokol/thirdparty/util
#flag darwin -fobjc-arc
#flag darwin -framework OpenGL -framework Cocoa

#include "sokol_gfx.h"

// this ensures app gets included before gfx. For SDL we dont need app but we dont have top-level
// $ifs yet so we deal with importing it anyway
#define SOKOL_IMPL
#define SOKOL_NO_ENTRY
#include "sokol_app.h"