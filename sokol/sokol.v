module sokol

#flag -I @VMOD/prime31/sokol/thirdparty
#flag -I @VMOD/prime31/sokol/thirdparty/util

#flag darwin -fobjc-arc

// METAL
#define SOKOL_METAL
#flag darwin -framework Metal -framework Cocoa -framework MetalKit -framework QuartzCore

// OPENGL
// #define SOKOL_GLCORE33
// #flag @VMOD/prime31/sokol/thirdparty/flextgl/flextGL.o
// #flag darwin -framework OpenGL -framework Cocoa -framework QuartzCore
// this is just to quite the warnings about gl.h and gl3.h being included by Apple
// #flag darwin -DGL_DO_NOT_WARN_IF_MULTI_GL_VERSION_HEADERS_INCLUDED
