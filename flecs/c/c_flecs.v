module c

#flag -I @VMOD/prime31/flecs/thirdparty
#flag -I @VMOD/prime31/flecs/thirdparty/include
#flag -I @VMOD/prime31/flecs/thirdparty/include/util
#flag -L @VMOD/prime31/flecs/thirdparty

// both static and shared will work for macos
#flag darwin @VMOD/prime31/flecs/thirdparty/libflecs_static.a
//#flag darwin -lflecs_shared

// shared requres setting rpath
#flag linux @VMOD/prime31/flecs/thirdparty/libflecs_static.a
//#flag linux -lflecs_shared
//#flag linux '-Wl,-rpath,@VMOD/prime31/flecs/thirdparty'

#include "include/flecs.h"


pub const ( version = 1 )

