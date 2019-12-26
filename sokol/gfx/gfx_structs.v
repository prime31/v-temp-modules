module gfx

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
    primitive_type int // TODO: sg_primitive_type
    index_type int // TODO: sg_index_type
    depth_stencil C.sg_depth_stencil_state
    blend sg_blend_state
    rasterizer C.sg_rasterizer_state
    label byteptr
    _end_canary u32
}

pub struct C.sg_pipeline_info {

}

pub struct C.sg_pipeline {
    id u32
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
pub mut:
    _start_canary u32
    attrs [16]sg_shader_attr_desc
    vs C.sg_shader_stage_desc
    fs C.sg_shader_stage_desc
    label byteptr
    _end_canary u32
}

pub struct C.sg_shader_attr_desc {
    name byteptr           /* GLSL vertex attribute name (only required for GLES2) */
    sem_name byteptr       /* HLSL semantic name */
    sem_index int              /* HLSL semantic index */
}

pub struct C.sg_shader_stage_desc {
pub mut:
    source byteptr
    byte_code &byte
    byte_code_size int
    entry byteptr
    uniform_blocks [4]sg_shader_uniform_block_desc
    images [12]sg_shader_image_desc
}

pub struct C.sg_shader_uniform_block_desc {
pub mut:
    size int
    uniforms [16]sg_shader_uniform_desc
}

pub struct C.sg_shader_uniform_desc {
pub mut:
    name byteptr
    @type UniformType
    array_count int
}

pub struct C.sg_shader_image_desc {
    name byteptr
    @type int // TODO: sg_image_type
}

pub struct C.sg_shader_info {

}

pub struct C.sg_context {
    id u32
}

pub struct C.sg_shader {
    id u32
}

pub struct C.sg_pass_desc {
    _start_canary u32
    color_attachment [4]sg_attachment_desc
    depth_stencil_attachment sg_attachment_desc
    label byteptr
    _end_canary u32
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
    id u32
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
    id u32
}

pub struct C.sg_image_desc {
    _start_canary u32
    @type ImageType
    render_target bool
    width int
    height int
    dept int
    // union {
    //     int depth;
    //     int layers;
    // };
    num_mipmaps int
    usage Usage
    pixel_format PixelFormat
    sample_count int
    min_filter Filter
    mag_filter Filter
    wrap_u Wrap
    wrap_v Wrap
    wrap_w Wrap
    border_color BorderColor
    max_anisotropy u32
    min_lod f32
    max_lod f32
    content sg_image_content
    label byteptr
    /* GL specific */
    gl_textures [2]u32
    /* Metal specific */
    mtl_textures [2]voidptr
    /* D3D11 specific */
    d3d11_texture voidptr
    _end_canary u32
}

pub struct C.sg_image_info {

}

pub struct C.sg_image {
    id u32
}

pub struct C.sg_image_content {

}

pub struct C.sg_features {
    instancing bool
    origin_top_left bool
    multiple_render_targets bool
    msaa_render_targets bool
    imagetype_3d bool          /* creation of SG_IMAGETYPE_3D images is supported */
    imagetype_array bool       /* creation of SG_IMAGETYPE_ARRAY images is supported */
    image_clamp_to_border bool /* border color and clamp-to-border UV-wrap mode is supported */
}

pub struct C.sg_limits {
    max_image_size_2d u32         /* max width/height of SG_IMAGETYPE_2D images */
    max_image_size_cube u32       /* max width/height of SG_IMAGETYPE_CUBE images */
    max_image_size_3d u32         /* max width/height/depth of SG_IMAGETYPE_3D images */
    max_image_size_array u32
    max_image_array_layers u32
    max_vertex_attrs u32          /* <= SG_MAX_VERTEX_ATTRIBUTES (only on some GLES2 impls) */
}

pub struct C.g_pixelformat_info {

}

pub struct C.sg_layout_desc {
pub mut:
    buffers [8]sg_buffer_layout_desc
    attrs [16]sg_vertex_attr_desc
}

pub struct C.sg_buffer_layout_desc {
pub mut:
    stride int
    step_func int // TODO: sg_vertex_step
    step_rate int
}

pub struct C.sg_vertex_attr_desc {
pub mut:
    buffer_index int
    offset int
    format int // TODO: sg_vertex_format
}

pub struct C.sg_depth_stencil_state {
    stencil_front sg_stencil_state
    stencil_back sg_stencil_state
    depth_compare_func int // TODO: sg_compare_func
    depth_write_enabled bool
    stencil_enabled bool
    stencil_read_mask byte
    stencil_write_mask byte
    stencil_ref byte
}

pub struct C.sg_stencil_state {
    fail_op int // TODO: sg_stencil_op
    depth_fail_op int // TODO: sg_stencil_op
    pass_op int // TODO: sg_stencil_op
    compare_func int // TODO: sg_compare_func
}

pub struct C.sg_blend_state {}

pub struct C.sg_rasterizer_state {
pub mut:
    alpha_to_coverage_enabled bool
    cull_mode int // TODO: sg_cull_mode
    face_winding int // TODO: sg_face_winding
    sample_count int
    depth_bias f32
    depth_bias_slope_scale f32
    depth_bias_clamp f32
}


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

pub struct C.sg_pixelformat_info {
    sample bool        /* pixel format can be sampled in shaders */
    filter bool        /* pixel format can be sampled with filtering */
    render bool        /* pixel format can be used as render target */
    blend bool         /* alpha-blending is supported */
    msaa bool          /* pixel format can be used as MSAA render target */
    depth bool         /* pixel format is a depth format */
}

pub struct C.sg_attachment_desc {
    // image sg_image
    // mip_level int
    // union {
    //     face int
    //     layer int
    //     slice int
    // }
}