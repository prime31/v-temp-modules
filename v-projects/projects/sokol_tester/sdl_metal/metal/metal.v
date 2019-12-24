module metal

#flag -I./metal
#flag darwin -framework Metal -framework Cocoa -framework MetalKit -framework QuartzCore

#include "metal_util.h"

fn C.create_metal_layer(window voidptr, is_high_dpi bool)
fn C.get_metal_device() voidptr
fn C.get_render_pass_descriptor() voidptr
fn C.get_drawable() voidptr

pub fn shit(window voidptr) {
	flags := C.SDL_GetWindowFlags(window)
	is_highdpi := (flags & C.SDL_WINDOW_ALLOW_HIGHDPI) > 0

	renderer := C.SDL_CreateRenderer(window, -1, C.SDL_RENDERER_PRESENTVSYNC)
	metal_layer := C.SDL_RenderGetMetalLayer(renderer)
	C.SDL_DestroyRenderer(renderer)

	C.create_metal_layer(window, metal_layer, is_highdpi)
}