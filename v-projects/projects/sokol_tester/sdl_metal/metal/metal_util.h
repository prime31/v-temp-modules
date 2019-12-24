#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <SDL.h>
#include "SDL_syswm.h"


static void* _window;
static bool _is_high_dpi;
static CAMetalLayer* _metal_layer;
static id<CAMetalDrawable> _drawable;
MTLRenderPassDescriptor* _render_pass_descriptor;

CGSize _calculate_drawable_size() {
    static float content_scale = 0;
    if (content_scale < 0)
        content_scale = _metal_layer.contentsScale;

    int width, height;
    SDL_GetWindowSize(_window, &width, &height);

    return CGSizeMake(width * _metal_layer.contentsScale, height * _metal_layer.contentsScale);
}

void create_metal_layer(void* window, void* cametal_layer, bool is_high_dpi) {
    _window = window;
    _is_high_dpi = is_high_dpi;

    _metal_layer = (__bridge __typeof__ (CAMetalLayer*))cametal_layer;
    _metal_layer.framebufferOnly = YES;
}

const void* get_metal_device() {
    return (__bridge const void*)_metal_layer.device;
}

const void* get_render_pass_descriptor() {
    // todo: do we need to set the drawableSize? doesnt seem like we do...
    //_metal_layer.drawableSize = _calculate_drawable_size();

    _drawable = [_metal_layer nextDrawable];

    _render_pass_descriptor = NULL;
    _render_pass_descriptor = [[MTLRenderPassDescriptor alloc] init];
    _render_pass_descriptor.colorAttachments[0].texture = _drawable.texture;

    return (__bridge const void*)_render_pass_descriptor;
}

const void* get_drawable() {
    return (__bridge const void*)_drawable;
}