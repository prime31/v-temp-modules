module sokol

#flag -I @VMOD/prime31/sokol/thirdparty

#flag darwin -fobjc-arc

// METAL
#flag darwin -framework Metal -framework Cocoa -framework MetalKit -framework QuartzCore
#define SOKOL_METAL

// OPENGL
// #define SOKOL_GLCORE33
// #flag @VMOD/prime31/sokol/thirdparty/flextgl/flextGL.o
// #flag darwin -framework OpenGL -framework Cocoa -framework QuartzCore
// this is just to quite the warnings about gl.h and gl3.h being included by Apple
// #flag darwin -DGL_DO_NOT_WARN_IF_MULTI_GL_VERSION_HEADERS_INCLUDED

#define SOKOL_IMPL
#define SOKOL_NO_ENTRY
#include "sokol_app.h"

#define SOKOL_NO_DEPRECATED
#include "sokol_gfx.h"

#define SOKOL_GL_IMPL
#include "util/sokol_gl.h"

#define SOKOL_IMPL
#include "sokol_time.h"

#define SOKOL_IMGUI_IMPL
// don't depend on sokol_app.h
// #define SOKOL_IMGUI_NO_SOKOL_APP
// #include "util/sokol_imgui.h"