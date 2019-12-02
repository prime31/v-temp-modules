module flecs


#flag -I @VMOD/prime31/flecs/flecs_git
#flag -I @VMOD/prime31/flecs/flecs_git/include
#flag -I @VMOD/prime31/flecs/flecs_git/include/util

#flag -L @VMOD/prime31/flecs/flecs_git/build
// both static and shared will work
#flag darwin @VMOD/prime31/flecs/flecs_git/build/libflecs_static.a
//#flag darwin -lflecs_shared

#include "include/flecs.h"




