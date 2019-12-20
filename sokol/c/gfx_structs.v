module c

pub struct C.sg_desc {
    _start_canary u32
    buffer_pool_size int
    image_pool_size int
    shader_pool_size int
    pipeline_pool_size int
    pass_pool_size int
    context_pool_size int
    /* GL specific */
    gl_force_gles2 bool
    /* Metal-specific */
    mtl_device voidptr
    mtl_renderpass_descriptor_cb fn() voidptr
    mtl_drawable_cb fn() voidptr
    // (*mtl_renderpass_descriptor_cb)(void) voidptr
    // (*mtl_drawable_cb)(void) voidptr
    mtl_global_uniform_buffer_size int
    mtl_sampler_cache_size int
    /* D3D11-specific */
    d3d11_device voidptr
    d3d11_device_context voidptr
    d3d11_render_target_view_cb fn() voidptr
    d3d11_depth_stencil_view_cb fn() voidptr
    // (*d3d11_render_target_view_cb)(void) voidptr
    // (*d3d11_depth_stencil_view_cb)(void) voidptr
    _end_canary u32
}

pub struct C.sg_pipeline_desc {
pub mut:
	_start_canary u32
    layout C.sg_layout_desc
    shader C.sg_shader
    primitive_type sg_primitive_type
    index_type sg_index_type
    depth_stencil sg_depth_stencil_state
    blend sg_blend_state
    rasterizer sg_rasterizer_state
    label byteptr
    _end_canary u32
}

pub struct C.sg_pipeline_info {

}

pub struct C.sg_pipeline {

}

pub struct C.sg_bindings {
pub mut:
    _start_canary u32
    vertex_buffers [8]sg_buffer
    vertex_buffer_offsets [8]int
    index_buffer sg_buffer
    index_buffer_offset int
    vs_images [8]sg_image
    fs_images [8]sg_image
    _end_canary u32
}

pub struct C.sg_shader_desc {
    _start_canary u32
    attrs [16]sg_shader_attr_desc
    vs C.sg_shader_stage_desc
    fs C.sg_shader_stage_desc
    label byteptr
    _end_canary u32
}

pub struct C.sg_shader_stage_desc {
    source byteptr
    byte_code &byte
    byte_code_size int
    entry byteptr
    uniform_blocks [4]sg_shader_uniform_block_desc
    images [12]sg_shader_image_desc
}

pub struct C.sg_shader_stage {

}

pub struct C.sg_shader_info {

}

pub struct C.sg_shader {

}

pub struct C.sg_pass_desc {

}

pub struct C.sg_pass_info {

}

pub struct C.sg_pass_action {
pub mut:
    _start_canary u32
    colors [4]sg_color_attachment_action
    depth sg_depth_attachment_action
    stencil sg_stencil_attachment_action
    _end_canary u32
}

pub struct C.sg_pass {

}

pub struct C.sg_buffer_desc {
    _start_canary u32
    size int
    @type int // TODO: sg_buffer_type
    usage int // TODO: sg_usage
    content byteptr
    label byteptr
    /* GL specific */
    gl_buffers [2]u32
    /* Metal specific */
    mtl_buffers [2]voidptr
    /* D3D11 specific */
    d3d11_buffer voidptr
    _end_canary u32
}

pub struct C.sg_buffer_info {

}

pub struct C.sg_buffer {

}

pub struct C.sg_image_desc {

}

pub struct C.sg_image_info {

}

pub struct C.sg_image {

}

pub struct C.sg_image_content {

}

pub struct C.sg_features {

}

pub struct C.sg_limits {

}

pub struct C.sg_pixel_format {

}

pub struct C.g_pixelformat_info {

}

pub struct C.sg_backend {}

pub struct C.sg_layout_desc {
pub mut:
    buffers [8]sg_buffer_layout_desc
    attrs [16]sg_vertex_attr_desc
}

pub struct C.sg_vertex_attr_desc {
    buffer_index int
    offset int
    format int // TODO: sg_vertex_format
}

pub struct C.sg_primitive_type {}

pub struct C.sg_index_type {}

pub struct C.sg_depth_stencil_state {}

pub struct C.sg_blend_state {}

pub struct C.sg_rasterizer_state {}


pub struct C.sg_color_attachment_action {
pub mut:
    action int // TODO: sg_action
    val [4]f32
}

pub struct C.sg_depth_attachment_action {
pub mut:
    action int // TODO: sg_action
    val f32
}

pub struct C.sg_stencil_attachment_action {
pub mut:
    action int // TODO: sg_action
    val byte
}