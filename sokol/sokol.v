module sokol

#flag -I @VMOD/prime31/sokol/thirdparty
#flag -I @VMOD/prime31/sokol/thirdparty/util

#flag darwin -fobjc-arc
#flag linux -lX11 -lGL

// METAL
// #define SOKOL_METAL // which one? depends on import order...
// #flag -DSOKOL_METAL
// #flag darwin -framework Metal -framework Cocoa -framework MetalKit -framework QuartzCore

// OPENGL
// #define SOKOL_GLCORE33 // which one? depends on import order...
#flag -DSOKOL_GLCORE33
#flag darwin -framework OpenGL -framework Cocoa -framework QuartzCore
// this is just to quite the warnings about gl.h and gl3.h being included by Apple
// #flag darwin -DGL_DO_NOT_WARN_IF_MULTI_GL_VERSION_HEADERS_INCLUDED
