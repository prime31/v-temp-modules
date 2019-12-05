module imgui


#flag -DCIMGUI_DEFINE_ENUMS_AND_STRUCTS=1
#flag -DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1
#flag -DIMGUI_IMPL_API=

#flag -I @VMOD/prime31/imgui

#flag @VMOD/prime31/imgui/thirdparty/imgui_impl_sdl.o
#flag @VMOD/prime31/imgui/thirdparty/imgui_impl_opengl3.o

// both static and shared will work. if you use dynamic uncomment both lines below and comment this one out
#flag darwin @VMOD/prime31/imgui/thirdparty/cimgui.a

// rpath is required for shared. for proper installs, -rpath should be relative to @executable_path/
// #flag darwin -rpath @VMOD/prime31/imgui/thirdparty
// #flag darwin @VMOD/prime31/imgui/thirdparty/cimgui.dylib

#flag darwin -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo `sdl2-config --libs`
#flag -lm -lc++

#include "thirdparty/cimgui.h"
#include "thirdparty/imgui_impl_opengl3.h"
#include "thirdparty/imgui_impl_sdl.h"