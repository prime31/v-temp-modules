module flecs


#flag -I @VMOD/prime31/flecs/thirdparty
#flag -I @VMOD/prime31/flecs/thirdparty/include
#flag -I @VMOD/prime31/flecs/thirdparty/include/util

#flag -L @VMOD/prime31/flecs/thirdparty
// both static and shared will work
#flag darwin @VMOD/prime31/flecs/thirdparty/libflecs_static.a
//#flag darwin -lflecs_shared

#include "include/flecs.h"




