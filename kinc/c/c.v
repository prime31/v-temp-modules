module c

// graphics4/vertexstructure

pub enum VertexData {
	non
	float1
	float2
	float3
	float4
	float4x4
	short2_norm
	short4_norm
	color
}

pub struct C.kinc_g4_vertex_element_t {
	name byteptr
	data VertexData
}

pub struct C.kinc_g4_vertex_structure_t {
	elements [16]kinc_g4_vertex_element_t
	size int
	instanced bool
}

fn C.kinc_g4_vertex_element_init(element &kinc_g4_vertex_element_t, name byteptr, data VertexData)
fn C.kinc_g4_vertex_structure_init(structure &kinc_g4_vertex_structure_t)
fn C.kinc_g4_vertex_structure_add(structure &kinc_g4_vertex_structure_t, name byteptr, data VertexData)

// graphics5/vertexstructure


// kinc/image

pub enum ImageCompression {
	non
	dxt5
	astc
	pvrtc
}

pub enum ImageFormat {
	rgba32
	grey8
	rgb24
	rgba128
	rgba64
	a32
	bgra32
	a16
}

pub struct C.kinc_image_t {
	width int
	height int
	depth int
	format ImageFormat
	internal_format u32
	compression ImageCompression
	data voidptr
	data_size int
}

pub struct C.kinc_image_read_callbacks_t {
	read fn(voidptr, voidptr, int) int
	seek fn(voidptr, int)
	pos fn(voidptr) int
	size fn(voidptr) int
}

fn C.kinc_image_init(image &kinc_image_t, memory voidptr, width int, height int, format ImageFormat) int
fn C.kinc_image_init3d(image &kinc_image_t, memory voidptr, width int, height int, depth int, format ImageFormat) int
fn C.kinc_image_size_from_file(filename byteptr) int
fn C.kinc_image_size_from_callbacks(callbacks kinc_image_read_callbacks_t, user_data voidptr, filename byteptr) int
fn C.kinc_image_init_from_file(image &kinc_image_t, memory voidptr, filename byteptr) int
fn C.kinc_image_init_from_callbacks(image &kinc_image_t, memory voidptr, callbacks kinc_image_read_callbacks_t, user_data voidptr, filename byteptr) int
fn C.kinc_image_init_from_bytes(image &kinc_image_t, data voidptr, width int, height int, format ImageFormat)
fn C.kinc_image_init_from_bytes3d(image &kinc_image_t, data voidptr, width int, height int, depth int, format ImageFormat)
fn C.kinc_image_destroy(image &kinc_image_t)
fn C.kinc_image_at(image &kinc_image_t, x int, y int) int
fn C.kinc_image_get_pixels(image &kinc_image_t) &byte
fn C.kinc_image_format_sizeof(format ImageFormat) int

// graphics5/textureunit

pub struct C.kinc_g5_texture_unit_t {
	impl TextureUnit5Impl
}


// graphics5/rendertarget

pub enum RenderTargetFormat {
	_32bit
	_64bit_float
	_32bit_red_float
	_128bit_float
	_16bit_depth
	_8bit_red
	_16bit_red_float
}

fn C.kinc_g5_render_target_init(target &kinc_g5_render_target_t, width int, height int, depthBufferBits int, antialiasing bool, format RenderTargetFormat, stencilBufferBits int, contextId int)
fn C.kinc_g5_render_target_init_cube(target &kinc_g5_render_target_t, cubeMapSize int, depthBufferBits int, antialiasing bool, format RenderTargetFormat, stencilBufferBits int, contextId int)
fn C.kinc_g5_render_target_destroy(target &kinc_g5_render_target_t)
fn C.kinc_g5_render_target_use_color_as_texture(target &kinc_g5_render_target_t, unit kinc_g5_texture_unit_t)
fn C.kinc_g5_render_target_use_depth_as_texture(target &kinc_g5_render_target_t, unit kinc_g5_texture_unit_t)
fn C.kinc_g5_render_target_set_depth_stencil_from(target &kinc_g5_render_target_t, source &kinc_g5_render_target_t)

// graphics5/texture

fn C.kinc_g5_texture_init(texture &kinc_g5_texture_t, width int, height int, format ImageFormat)
fn C.kinc_g5_texture_init3d(texture &kinc_g5_texture_t, width int, height int, depth int, format ImageFormat)
fn C.kinc_g5_texture_init_from_image(texture &kinc_g5_texture_t, image &kinc_image_t)
fn C.kinc_g5_texture_destroy(texture &kinc_g5_texture_t)
fn C.kinc_g5_texture_lock(texture &kinc_g5_texture_t) &byte
fn C.kinc_g5_texture_unlock(texture &kinc_g5_texture_t)
fn C.kinc_g5_texture_clear(texture &kinc_g5_texture_t, x int, y int, z int, width int, height int, depth int, color u32)
fn C.kinc_g5_texture_generate_mipmaps(texture &kinc_g5_texture_t, levels int)
fn C.kinc_g5_texture_set_mipmap(texture &kinc_g5_texture_t, mipmap &kinc_g5_texture_t, level int)
fn C.kinc_g5_texture_stride(texture &kinc_g5_texture_t) int

// math/matrix

pub struct C.kinc_matrix3x3_t {
	m [9]f32
}

pub struct C.kinc_matrix4x4_t {
	m [16]f32
}

fn C.kinc_matrix3x3_get(matrix &kinc_matrix3x3_t, x int, y int) f32
fn C.kinc_matrix3x3_set(matrix &kinc_matrix3x3_t, x int, y int, value f32)
fn C.kinc_matrix3x3_transpose(matrix &kinc_matrix3x3_t)
fn C.kinc_matrix3x3_identity() kinc_matrix3x3_t
fn C.kinc_matrix3x_rotation_x(alpha f32) kinc_matrix3x3_t
fn C.kinc_matrix3x_rotation_y(alpha f32) kinc_matrix3x3_t
fn C.kinc_matrix3x_rotation_z(alpha f32) kinc_matrix3x3_t
fn C.kinc_matrix4x4_get(matrix &kinc_matrix4x4_t, x int, y int) f32
fn C.kinc_matrix4x4_transpose(matrix &kinc_matrix4x4_t)

// graphics5/shader

pub enum ShaderType {
	fragment
	vertex
	geometry
	tessellation_control
	tessellation_evaluation
}

fn C.kinc_g5_shader_init(shader &kinc_g5_shader_t, source voidptr, length int, typ ShaderType)
fn C.kinc_g5_shader_destroy(shader &kinc_g5_shader_t)

// graphics5/graphics

pub enum TextureAddressing {
	repeat
	mirror
	clamp
	border
}

pub enum TextureFilter {
	point
	linear
	anisotropic
}

pub enum MipmapFilter {
	non
	point
	linear
}

pub enum BlendingOperation {
	one
	zero
	source_alpha
	dest_alpha
	inv_source_alpha
	inv_dest_alpha
	source_color
	dest_color
	inv_source_color
	inv_dest_color
}

pub enum CompareMode {
	always
	never
	equal
	not_equal
	less
	less_equal
	greater
	greater_equal
}

pub enum CullMode {
	clockwise
	counterclockwise
	never
}

pub enum TextureDirection {
	u
	v
	w
}

pub enum StencilAction {
	keep
	zero
	replace
	increment
	increment_wrap
	decrement
	decrement_wrap
	invert
}

pub enum TextureOperation {
	modulate
	select_first
	select_second
}

pub enum TextureArgument {
	current_color
	texture_color
}

fn C.kinc_g5_init(window int, depthBufferBits int, stencilBufferBits int, vsync bool)
fn C.kinc_g5_destroy(window int)
fn C.kinc_g5_flush()
fn C.kinc_g5_set_texture(unit kinc_g5_texture_unit_t, texture &kinc_g5_texture_t)
fn C.kinc_g5_set_image_texture(unit kinc_g5_texture_unit_t, texture &kinc_g5_texture_t)
fn C.kinc_g5_draw_indexed_vertices_instanced(instanceCount int)
fn C.kinc_g5_draw_indexed_vertices_instanced_from_to(instanceCount int, start int, count int)
fn C.kinc_g5_antialiasing_samples() int
fn C.kinc_g5_set_antialiasing_samples(samples int)
fn C.kinc_g5_non_pow2_textures_qupported() bool
fn C.kinc_g5_render_targets_inverted_y() bool
fn C.kinc_g5_set_render_target_face(texture &kinc_g5_render_target_t, face int)
fn C.kinc_g5_begin(renderTarget &kinc_g5_render_target_t, window int)
fn C.kinc_g5_end(window int)
fn C.kinc_g5_swap_buffers() bool
fn C.kinc_g5_set_texture_addressing(unit kinc_g5_texture_unit_t, dir TextureDirection, addressing TextureAddressing)
fn C.kinc_g5_set_texture_magnification_filter(texunit kinc_g5_texture_unit_t, filter TextureFilter)
fn C.kinc_g5_set_texture_minification_filter(texunit kinc_g5_texture_unit_t, filter TextureFilter)
fn C.kinc_g5_set_texture_mipmap_filter(texunit kinc_g5_texture_unit_t, filter MipmapFilter)
fn C.kinc_g5_set_texture_operation(operation TextureOperation, arg1 TextureArgument, arg2 TextureArgument)
fn C.kinc_g5_init_occlusion_query(occlusionQuery &u32) bool
fn C.kinc_g5_delete_occlusion_query(occlusionQuery u32)
fn C.kinc_g5_render_occlusion_query(occlusionQuery u32, triangles int)
fn C.kinc_g5_are_query_results_available(occlusionQuery u32) bool
fn C.kinc_g5_get_query_result(occlusionQuery u32, pixelCount &u32)

// graphics5/constantlocation

pub struct C.kinc_g5_constant_location_t {
	impl ConstantLocation5Impl
}


// graphics5/pipeline

pub struct C.kinc_g5_shader_t {
	impl Shader5Impl
}

fn C.kinc_g5_pipeline_init(pipeline &kinc_g5_pipeline_t)
fn C.kinc_g5_pipeline_destroy(pipeline &kinc_g5_pipeline_t)
fn C.kinc_g5_pipeline_compile(pipeline &kinc_g5_pipeline_t)
fn C.kinc_g5_pipeline_get_constant_location(pipeline &kinc_g5_pipeline_t, name byteptr) kinc_g5_constant_location_t
fn C.kinc_g5_pipeline_get_texture_unit(pipeline &kinc_g5_pipeline_t, name byteptr) kinc_g5_texture_unit_t

// graphics4/constantlocation

pub struct C.kinc_g4_constant_location_t {
	impl kinc_g4_constant_location_impl_t
}


// graphics4/textureunit

pub struct C.kinc_g4_texture_unit_t {
	impl kinc_g4_texture_unit_impl_t
}


// graphics5/indexbuffer

fn C.kinc_g5_index_buffer_init(buffer &kinc_g5_index_buffer_t, count int, gpuMemory bool)
fn C.kinc_g5_index_buffer_destroy(buffer &kinc_g5_index_buffer_t)
fn C.kinc_g5_index_buffer_lock(buffer &kinc_g5_index_buffer_t) &int
fn C.kinc_g5_index_buffer_unlock(buffer &kinc_g5_index_buffer_t)
fn C.kinc_g5_index_buffer_count(buffer &kinc_g5_index_buffer_t) int

// graphics4/indexbuffer

pub struct C.kinc_g4_index_buffer_t {
	impl kinc_g4_index_buffer_impl_t
}

fn C.kinc_g4_index_buffer_init(buffer &kinc_g4_index_buffer_t, count int)
fn C.kinc_g4_index_buffer_destroy(buffer &kinc_g4_index_buffer_t)
fn C.kinc_g4_index_buffer_lock(buffer &kinc_g4_index_buffer_t) &int
fn C.kinc_g4_index_buffer_unlock(buffer &kinc_g4_index_buffer_t)
fn C.kinc_g4_index_buffer_count(buffer &kinc_g4_index_buffer_t) int
fn C.kinc_g4_set_index_buffer(buffer &kinc_g4_index_buffer_t)

// graphics4/rendertarget

pub enum RenderTargetFormat {
	_32bit
	_64bit_float
	_32bit_red_float
	_128bit_float
	_16bit_depth
	_8bit_red
	_16bit_red_float
}

pub struct C.kinc_g4_render_target_t {
	width int
	height int
	texWidth int
	texHeight int
	contextId int
	isCubeMap bool
	isDepthAttachment bool
	impl kinc_g4_render_target_impl_t
}

fn C.kinc_g4_render_target_init(renderTarget &kinc_g4_render_target_t, width int, height int, depthBufferBits int, antialiasing bool, format RenderTargetFormat, stencilBufferBits int, contextId int)
fn C.kinc_g4_render_target_init_cube(renderTarget &kinc_g4_render_target_t, cubeMapSize int, depthBufferBits int, antialiasing bool, format RenderTargetFormat, stencilBufferBits int, contextId int)
fn C.kinc_g4_render_target_destroy(renderTarget &kinc_g4_render_target_t)
fn C.kinc_g4_render_target_use_color_as_texture(renderTarget &kinc_g4_render_target_t, unit kinc_g4_texture_unit_t)
fn C.kinc_g4_render_target_use_depth_as_texture(renderTarget &kinc_g4_render_target_t, unit kinc_g4_texture_unit_t)
fn C.kinc_g4_render_target_set_depth_stencil_from(renderTarget &kinc_g4_render_target_t, source &kinc_g4_render_target_t)
fn C.kinc_g4_render_target_get_pixels(renderTarget &kinc_g4_render_target_t, data &byte)
fn C.kinc_g4_render_target_generate_mipmaps(renderTarget &kinc_g4_render_target_t, levels int)

// graphics4/shader

pub enum ShaderType {
	fragment
	vertex
	geometry
	tessellation_control
	tessellation_evaluation
}

pub struct C.kinc_g4_shader_t {
	impl kinc_g4_shader_impl_t
}

fn C.kinc_g4_shader_init(shader &kinc_g4_shader_t, data voidptr, length int, typ ShaderType)
fn C.kinc_g4_shader_init_from_source(shader &kinc_g4_shader_t, source byteptr, typ ShaderType)
fn C.kinc_g4_shader_destroy(shader &kinc_g4_shader_t)

// graphics4/texture

pub struct C.kinc_g4_texture_t {
	tex_width int
	tex_height int
	tex_depth int
	format ImageFormat
	impl kinc_g4_texture_impl_t
}

fn C.kinc_g4_texture_init(texture &kinc_g4_texture_t, width int, height int, format ImageFormat)
fn C.kinc_g4_texture_init3d(texture &kinc_g4_texture_t, width int, height int, depth int, format ImageFormat)
fn C.kinc_g4_texture_init_from_image(texture &kinc_g4_texture_t, image &kinc_image_t)
fn C.kinc_g4_texture_init_from_image3d(texture &kinc_g4_texture_t, image &kinc_image_t)
fn C.kinc_g4_texture_destroy(texture &kinc_g4_texture_t)
fn C.kinc_g4_texture_lock(texture &kinc_g4_texture_t) &byte
fn C.kinc_g4_texture_unlock(texture &kinc_g4_texture_t)
fn C.kinc_g4_texture_clear(texture &kinc_g4_texture_t, x int, y int, z int, width int, height int, depth int, color u32)
fn C.kinc_g4_texture_upload(texture &kinc_g4_texture_t, data &byte, stride int)
fn C.kinc_g4_texture_generate_mipmaps(texture &kinc_g4_texture_t, levels int)
fn C.kinc_g4_texture_set_mipmap(texture &kinc_g4_texture_t, mipmap &kinc_image_t, level int)
fn C.kinc_g4_texture_stride(texture &kinc_g4_texture_t) int

// graphics4/texturearray

pub struct C.kinc_g4_texture_array_t {
	impl kinc_g4_texture_array_impl_t
}

fn C.kinc_g4_texture_array_init(array &kinc_g4_texture_array_t, textures &kinc_image_t, count int)
fn C.kinc_g4_texture_array_destroy(array &kinc_g4_texture_array_t)

// graphics5/commandlist

pub struct C.kinc_g5_render_target_t {
	width int
	height int
	texWidth int
	texHeight int
	contextId int
	isCubeMap bool
	isDepthAttachment bool
	impl RenderTarget5Impl
}

pub struct C.kinc_g5_texture_t {
	texWidth int
	texHeight int
	format ImageFormat
	impl Texture5Impl
}

pub struct C.kinc_g5_pipeline_t {
	inputLayout [16]&kinc_g5_vertex_structure_t
	vertexShader &kinc_g5_shader_t
	fragmentShader &kinc_g5_shader_t
	geometryShader &kinc_g5_shader_t
	tessellationControlShader &kinc_g5_shader_t
	tessellationEvaluationShader &kinc_g5_shader_t
	cullMode CullMode
	depthWrite bool
	depthMode CompareMode
	stencilMode CompareMode
	stencilBothPass StencilAction
	stencilDepthFail StencilAction
	stencilFail StencilAction
	stencilReferenceValue int
	stencilReadMask int
	stencilWriteMask int
	blendSource BlendingOperation
	blendDestination BlendingOperation
	alphaBlendSource BlendingOperation
	alphaBlendDestination BlendingOperation
	colorWriteMaskRed [8]bool
	colorWriteMaskGreen [8]bool
	colorWriteMaskBlue [8]bool
	colorWriteMaskAlpha [8]bool
	conservativeRasterization bool
	impl PipelineState5Impl
}

pub struct C.kinc_g5_index_buffer_t {
	impl IndexBuffer5Impl
}

pub struct C.kinc_g5_vertex_buffer {
}

pub struct C.kinc_g5_command_list_t {
	impl CommandList5Impl
}

fn C.kinc_g5_command_list_init(list &kinc_g5_command_list_t)
fn C.kinc_g5_command_list_destroy(list &kinc_g5_command_list_t)
fn C.kinc_g5_command_list_begin(list &kinc_g5_command_list_t)
fn C.kinc_g5_command_list_end(list &kinc_g5_command_list_t)
fn C.kinc_g5_command_list_clear(list &kinc_g5_command_list_t, renderTarget &kinc_g5_render_target_t, flags u32, color u32, depth f32, stencil int)
fn C.kinc_g5_command_list_render_target_to_framebuffer_barrier(list &kinc_g5_command_list_t, renderTarget &kinc_g5_render_target_t)
fn C.kinc_g5_command_list_framebuffer_to_render_target_barrier(list &kinc_g5_command_list_t, renderTarget &kinc_g5_render_target_t)
fn C.kinc_g5_command_list_texture_to_render_target_barrier(list &kinc_g5_command_list_t, renderTarget &kinc_g5_render_target_t)
fn C.kinc_g5_command_list_render_target_to_texture_barrier(list &kinc_g5_command_list_t, renderTarget &kinc_g5_render_target_t)
fn C.kinc_g5_command_list_draw_indexed_vertices(list &kinc_g5_command_list_t)
fn C.kinc_g5_command_list_draw_indexed_vertices_from_to(list &kinc_g5_command_list_t, start int, count int)
fn C.kinc_g5_command_list_viewport(list &kinc_g5_command_list_t, x int, y int, width int, height int)
fn C.kinc_g5_command_list_scissor(list &kinc_g5_command_list_t, x int, y int, width int, height int)
fn C.kinc_g5_command_list_disable_scissor(list &kinc_g5_command_list_t)
fn C.kinc_g5_command_list_set_pipeline(list &kinc_g5_command_list_t, pipeline &kinc_g5_pipeline_t)
fn C.kinc_g5_command_list_set_vertex_buffers(list &kinc_g5_command_list_t, buffers voidptr /* kinc_g5_vertex_buffer** */, offsets &int, count int)
fn C.kinc_g5_command_list_set_index_buffer(list &kinc_g5_command_list_t, buffer &kinc_g5_index_buffer_t)
fn C.kinc_g5_command_list_set_render_targets(list &kinc_g5_command_list_t, targets voidptr /* kinc_g5_render_target** */, count int)
fn C.kinc_g5_command_list_upload_index_buffer(list &kinc_g5_command_list_t, buffer &kinc_g5_index_buffer_t)
fn C.kinc_g5_command_list_upload_vertex_buffer(list &kinc_g5_command_list_t, buffer &kinc_g5_vertex_buffer)
fn C.kinc_g5_command_list_upload_texture(list &kinc_g5_command_list_t, texture &kinc_g5_texture_t)
fn C.kinc_g5_command_list_set_vertex_constant_buffer(list &kinc_g5_command_list_t, buffer &kinc_g5_constant_buffer_t, offset int, size int)
fn C.kinc_g5_command_list_set_fragment_constant_buffer(list &kinc_g5_command_list_t, buffer &kinc_g5_constant_buffer_t, offset int, size int)
fn C.kinc_g5_command_list_set_pipeline_layout(list &kinc_g5_command_list_t)
fn C.kinc_g5_command_list_execute(list &kinc_g5_command_list_t)
fn C.kinc_g5_command_list_execute_and_wait(list &kinc_g5_command_list_t)
fn C.kinc_g5_command_list_get_render_target_pixels(list &kinc_g5_command_list_t, render_target &kinc_g5_render_target_t, data &byte)

// graphics5/constantbuffer

pub struct C.kinc_g5_constant_buffer_t {
	data &byte
	impl ConstantBuffer5Impl
}

fn C.kinc_g5_constant_buffer_init(buffer &kinc_g5_constant_buffer_t, size int)
fn C.kinc_g5_constant_buffer_destroy(buffer &kinc_g5_constant_buffer_t)
fn C.kinc_g5_constant_buffer_lock_all(buffer &kinc_g5_constant_buffer_t)
fn C.kinc_g5_constant_buffer_lock(buffer &kinc_g5_constant_buffer_t, start int, count int)
fn C.kinc_g5_constant_buffer_unlock(buffer &kinc_g5_constant_buffer_t)
fn C.kinc_g5_constant_buffer_size(buffer &kinc_g5_constant_buffer_t) int
fn C.kinc_g5_constant_buffer_set_bool(buffer &kinc_g5_constant_buffer_t, offset int, value bool)
fn C.kinc_g5_constant_buffer_set_int(buffer &kinc_g5_constant_buffer_t, offset int, value int)
fn C.kinc_g5_constant_buffer_set_float(buffer &kinc_g5_constant_buffer_t, offset int, value f32)
fn C.kinc_g5_constant_buffer_set_float2(buffer &kinc_g5_constant_buffer_t, offset int, value1 f32, value2 f32)
fn C.kinc_g5_constant_buffer_set_float3(buffer &kinc_g5_constant_buffer_t, offset int, value1 f32, value2 f32, value3 f32)
fn C.kinc_g5_constant_buffer_set_float4(buffer &kinc_g5_constant_buffer_t, offset int, value1 f32, value2 f32, value3 f32, value4 f32)
fn C.kinc_g5_constant_buffer_set_floats(buffer &kinc_g5_constant_buffer_t, offset int, values &f32, count int)
fn C.kinc_g5_constant_buffer_set_matrix3(buffer &kinc_g5_constant_buffer_t, offset int, value &kinc_matrix3x3_t)
fn C.kinc_g5_constant_buffer_set_matrix4(buffer &kinc_g5_constant_buffer_t, offset int, value &kinc_matrix4x4_t)

// io/filereader

pub struct C.kinc_file_reader_t {
	file voidptr
	size int
	@type int
	mode int
	mounted bool
}

fn C.kinc_file_reader_open(reader &kinc_file_reader_t, filename byteptr, typ int) bool
fn C.kinc_file_reader_close(reader &kinc_file_reader_t)
fn C.kinc_file_reader_read(reader &kinc_file_reader_t, data voidptr, size int) int
fn C.kinc_file_reader_size(reader &kinc_file_reader_t) int
fn C.kinc_file_reader_pos(reader &kinc_file_reader_t) int
fn C.kinc_file_reader_seek(reader &kinc_file_reader_t, pos int)
fn C.kinc_read_f32le(data &byte) f32
fn C.kinc_read_f32be(data &byte) f32
fn C.kinc_read_u64le(data &byte) u64
fn C.kinc_read_u64be(data &byte) u64
fn C.kinc_read_s64le(data &byte) i64
fn C.kinc_read_s64be(data &byte) i64
fn C.kinc_read_u32le(data &byte) u32
fn C.kinc_read_u32be(data &byte) u32
fn C.kinc_read_s32le(data &byte) int
fn C.kinc_read_s32be(data &byte) int
fn C.kinc_read_u16le(data &byte) u16
fn C.kinc_read_u16be(data &byte) u16
fn C.kinc_read_s16le(data &byte) i16
fn C.kinc_read_s16be(data &byte) i16
fn C.kinc_read_u8(data &byte) byte
fn C.kinc_read_s8(data &byte) i8

// kinc/system

fn C.kinc_init(name byteptr, width int, height int, win &kinc_window_options_t, frame &kinc_framebuffer_options_t) int
fn C.kinc_application_name() byteptr
fn C.kinc_set_application_name(name byteptr)
fn C.kinc_width() int
fn C.kinc_height() int
fn C.kinc_load_url(url byteptr)
fn C.kinc_system_id() byteptr
fn C.kinc_video_formats() voidptr /* const char** */
fn C.kinc_language() byteptr
fn C.kinc_vibrate(milliseconds int)
fn C.kinc_safe_zone() f32
fn C.kinc_automatic_safe_zone() bool
fn C.kinc_set_safe_zone(value f32)
fn C.kinc_frequency() f64
fn C.kinc_timestamp() u64
fn C.kinc_time() f64
fn C.kinc_run(value fn())
fn C.kinc_start()
fn C.kinc_stop()
fn C.kinc_login()
fn C.kinc_unlock_achievement(id int)
fn C.kinc_disallow_user_change()
fn C.kinc_allow_user_change()
fn C.kinc_set_keep_screen_on(on bool)
fn C.kinc_set_update_callback(value fn())
fn C.kinc_set_foreground_callback(value fn())
fn C.kinc_set_resume_callback(value fn())
fn C.kinc_set_pause_callback(value fn())
fn C.kinc_set_background_callback(value fn())
fn C.kinc_set_shutdown_callback(value fn())
fn C.kinc_set_drop_files_callback(value fn(&u16))
fn C.kinc_set_cut_callback(value fn() byteptr)
fn C.kinc_set_copy_callback(value fn() byteptr)
fn C.kinc_set_paste_callback(value fn(byteptr))
fn C.kinc_set_login_callback(value fn())
fn C.kinc_set_logout_callback(value fn())

// kinc/window

pub enum WindowMode {
	window
	fullscreen
	exclusive_fullscreen
}

pub struct C.kinc_window_options_t {
	title byteptr
	x int
	y int
	width int
	height int
	display_index int
	visible bool
	window_features int
	mode WindowMode
}

pub struct C.kinc_framebuffer_options_t {
	frequency int
	vertical_sync bool
	color_bits int
	depth_bits int
	stencil_bits int
	samples_per_pixel int
}

fn C.kinc_window_create(win &kinc_window_options_t, frame &kinc_framebuffer_options_t) int
fn C.kinc_window_destroy(window_index int)
fn C.kinc_count_windows() int
fn C.kinc_window_resize(window_index int, width int, height int)
fn C.kinc_window_move(window_index int, x int, y int)
fn C.kinc_window_change_mode(window_index int, mode WindowMode)
fn C.kinc_window_change_features(window_index int, features int)
fn C.kinc_window_change_framebuffer(window_index int, frame &kinc_framebuffer_options_t)
fn C.kinc_window_x(window_index int) int
fn C.kinc_window_y(window_index int) int
fn C.kinc_window_width(window_index int) int
fn C.kinc_window_height(window_index int) int
fn C.kinc_window_display(window_index int) int
fn C.kinc_window_get_mode(window_index int) WindowMode
fn C.kinc_window_show(window_index int)
fn C.kinc_window_hide(window_index int)
fn C.kinc_window_set_title(window_index int, title byteptr)
fn C.kinc_window_set_resize_callback(window_index int, callback fn(int, int, voidptr), data voidptr)
fn C.kinc_window_set_ppi_changed_callback(window_index int, callback fn(int, voidptr), data voidptr)
fn C.kinc_window_vsynced(window_index int) bool

// graphics4/graphics

pub enum TextureAddressing {
	repeat
	mirror
	clamp
	border
}

pub enum TextureDirection {
	u
	v
	w
}

pub enum TextureOperation {
	modulate
	select_first
	select_second
}

pub enum TextureArgument {
	current_color
	texture_color
}

pub enum TextureFilter {
	point
	linear
	anisotropic
}

pub enum MipmapFilter {
	non
	point
	linear
}

pub struct C.kinc_g4_pipeline {
}

fn C.kinc_g4_init(window int, depthBufferBits int, stencilBufferBits int, vSync bool)
fn C.kinc_g4_destroy(window int)
fn C.kinc_g4_flush()
fn C.kinc_g4_begin(window int)
fn C.kinc_g4_end(window int)
fn C.kinc_g4_swap_buffers() bool
fn C.kinc_g4_clear(flags u32, color u32, depth f32, stencil int)
fn C.kinc_g4_viewport(x int, y int, width int, height int)
fn C.kinc_g4_scissor(x int, y int, width int, height int)
fn C.kinc_g4_disable_scissor()
fn C.kinc_g4_draw_indexed_vertices()
fn C.kinc_g4_draw_indexed_vertices_from_to(start int, count int)
fn C.kinc_g4_draw_indexed_vertices_from_to_from(start int, count int, vertex_start int)
fn C.kinc_g4_draw_indexed_vertices_instanced(instanceCount int)
fn C.kinc_g4_draw_indexed_vertices_instanced_from_to(instanceCount int, start int, count int)
fn C.kinc_g4_set_texture_addressing(unit kinc_g4_texture_unit_t, dir TextureDirection, addressing TextureAddressing)
fn C.kinc_g4_set_texture3d_addressing(unit kinc_g4_texture_unit_t, dir TextureDirection, addressing TextureAddressing)
fn C.kinc_g4_set_pipeline(pipeline &kinc_g4_pipeline)
fn C.kinc_g4_set_stencil_reference_value(value int)
fn C.kinc_g4_set_texture_operation(operation TextureOperation, arg1 TextureArgument, arg2 TextureArgument)
fn C.kinc_g4_set_int(location kinc_g4_constant_location_t, value int)
fn C.kinc_g4_set_int2(location kinc_g4_constant_location_t, value1 int, value2 int)
fn C.kinc_g4_set_int3(location kinc_g4_constant_location_t, value1 int, value2 int, value3 int)
fn C.kinc_g4_set_int4(location kinc_g4_constant_location_t, value1 int, value2 int, value3 int, value4 int)
fn C.kinc_g4_set_ints(location kinc_g4_constant_location_t, values &int, count int)
fn C.kinc_g4_set_float(location kinc_g4_constant_location_t, value f32)
fn C.kinc_g4_set_float2(location kinc_g4_constant_location_t, value1 f32, value2 f32)
fn C.kinc_g4_set_float3(location kinc_g4_constant_location_t, value1 f32, value2 f32, value3 f32)
fn C.kinc_g4_set_float4(location kinc_g4_constant_location_t, value1 f32, value2 f32, value3 f32, value4 f32)
fn C.kinc_g4_set_floats(location kinc_g4_constant_location_t, values &f32, count int)
fn C.kinc_g4_set_bool(location kinc_g4_constant_location_t, value bool)
fn C.kinc_g4_set_matrix3(location kinc_g4_constant_location_t, value &kinc_matrix3x3_t)
fn C.kinc_g4_set_matrix4(location kinc_g4_constant_location_t, value &kinc_matrix4x4_t)
fn C.kinc_g4_set_texture_magnification_filter(unit kinc_g4_texture_unit_t, filter TextureFilter)
fn C.kinc_g4_set_texture3d_magnification_filter(texunit kinc_g4_texture_unit_t, filter TextureFilter)
fn C.kinc_g4_set_texture_minification_filter(unit kinc_g4_texture_unit_t, filter TextureFilter)
fn C.kinc_g4_set_texture3d_minification_filter(texunit kinc_g4_texture_unit_t, filter TextureFilter)
fn C.kinc_g4_set_texture_mipmap_filter(unit kinc_g4_texture_unit_t, filter MipmapFilter)
fn C.kinc_g4_set_texture3d_mipmap_filter(texunit kinc_g4_texture_unit_t, filter MipmapFilter)
fn C.kinc_g4_set_texture_compare_mode(unit kinc_g4_texture_unit_t, enabled bool)
fn C.kinc_g4_set_cubemap_compare_mode(unit kinc_g4_texture_unit_t, enabled bool)
fn C.kinc_g4_render_targets_inverted_y() bool
fn C.kinc_g4_non_pow2_textures_supported() bool
fn C.kinc_g4_restore_render_target()
fn C.kinc_g4_set_render_targets(targets voidptr /* kinc_g4_render_target** */, count int)
fn C.kinc_g4_set_render_target_face(texture &kinc_g4_render_target_t, face int)
fn C.kinc_g4_set_texture(unit kinc_g4_texture_unit_t, texture &kinc_g4_texture_t)
fn C.kinc_g4_set_image_texture(unit kinc_g4_texture_unit_t, texture &kinc_g4_texture_t)
fn C.kinc_g4_init_occlusion_query(occlusionQuery &u32) bool
fn C.kinc_g4_delete_occlusion_query(occlusionQuery u32)
fn C.kinc_g4_start_occlusion_query(occlusionQuery u32)
fn C.kinc_g4_end_occlusion_query(occlusionQuery u32)
fn C.kinc_g4_are_query_results_available(occlusionQuery u32) bool
fn C.kinc_g4_get_query_results(occlusionQuery u32, pixelCount &u32)
fn C.kinc_g4_set_texture_array(unit kinc_g4_texture_unit_t, array &kinc_g4_texture_array_t)
fn C.kinc_g4_antialiasing_samples() int
fn C.kinc_g4_set_antialiasing_samples(samples int)

// kinc/color

fn C.kinc_color_components(color u32, red &f32, green &f32, blue &f32, alpha &f32)

// graphics1/graphics

fn C.kinc_g1_init(width int, height int)
fn C.kinc_g1_begin()
fn C.kinc_g1_end()
fn C.kinc_g1_set_pixel(x int, y int, red f32, green f32, blue f32)
fn C.kinc_g1_width() int
fn C.kinc_g1_height() int

// Kore/pch

fn C.kickstart(argc int, argv voidptr /* char** */) int

// math/core

fn C.kinc_sin(value f32) f32
fn C.kinc_cos(value f32) f32
fn C.kinc_tan(x f32) f32
fn C.kinc_cot(x f32) f32
fn C.kinc_round(value f32) f32
fn C.kinc_ceil(value f32) f32
fn C.kinc_pow(value f32, exponent f32) f32
fn C.kinc_max_float() f32
fn C.kinc_sqrt(value f32) f32
fn C.kinc_abs(value f32) f32
fn C.kinc_asin(value f32) f32
fn C.kinc_acos(value f32) f32
fn C.kinc_atan(value f32) f32
fn C.kinc_atan2(y f32, x f32) f32
fn C.kinc_floor(value f32) f32
fn C.kinc_mod(numer f32, denom f32) f32
fn C.kinc_exp(exponent f32) f32
fn C.kinc_min(a f32, b f32) f32
fn C.kinc_max(a f32, b f32) f32
fn C.kinc_mini(a int, b int) int
fn C.kinc_maxi(a int, b int) int
fn C.kinc_clamp(value f32, minValue f32, maxValue f32) f32

// input/gamepad

fn C.kinc_gamepad_vendor(gamepad int) byteptr
fn C.kinc_gamepad_product_name(gamepad int) byteptr
fn C.kinc_gamepad_connected(gamepad int) bool

// input/keyboard

fn C.kinc_keyboard_show()
fn C.kinc_keyboard_hide()
fn C.kinc_keyboard_active() bool

// input/mouse

fn C.kinc_mouse_can_lock(window int) bool
fn C.kinc_mouse_is_locked(window int) bool
fn C.kinc_mouse_lock(window int)
fn C.kinc_mouse_unlock(window int)
fn C.kinc_mouse_show()
fn C.kinc_mouse_hide()
fn C.kinc_mouse_set_position(window int, x int, y int)
fn C.kinc_mouse_get_position(window int, x &int, y &int)

// io/filewriter

pub struct C.kinc_file_writer_t {
	file voidptr
	filename byteptr
	mounted bool
}

fn C.kinc_file_writer_open(writer &kinc_file_writer_t, filepath byteptr) bool
fn C.kinc_file_writer_write(writer &kinc_file_writer_t, data voidptr, size int)
fn C.kinc_file_writer_close(writer &kinc_file_writer_t)

// math/random

fn C.kinc_random_init(seed int)
fn C.kinc_random_get() int
fn C.kinc_random_get_max(max int) int
fn C.kinc_random_get_in(min int, max int) int

// Kore/PipelineState5Impl

pub struct C.PipelineState5Impl {
	vertexShader &kinc_g5_shader_t
	fragmentShader &kinc_g5_shader_t
	_pipeline voidptr
	_reflection voidptr
	_depthStencil voidptr
}

pub struct C.ConstantLocation5Impl {
	vertexOffset int
	fragmentOffset int
}


// Kore/Shader5Impl

pub struct C.Shader5Impl {
	name [1024]byte
	mtlFunction voidptr
}


// Kore/Texture5Impl

pub struct C.TextureUnit5Impl {
	index int
}

pub struct C.Texture5Impl {
	_tex voidptr
	_sampler voidptr
	data voidptr
}


// Kore/RenderTarget5Impl

pub struct C.RenderTarget5Impl {
	_tex voidptr
	_sampler voidptr
	_depthTex voidptr
}


// Kore/IndexBuffer5Impl

pub struct C.IndexBuffer5Impl {
	mtlBuffer voidptr
	myCount int
	gpuMemory bool
}


// Kore/VertexBuffer5Impl

pub struct C.VertexBuffer5Impl {
	myCount int
	myStride int
	mtlBuffer voidptr
	gpuMemory bool
	lastStart int
	lastCount int
}


// math/vector

pub struct C.kinc_vector2_t {
	x f32
	y f32
}

pub struct C.kinc_vector3_t {
	x f32
	y f32
	z f32
}

pub struct C.kinc_vector4_t {
	x f32
	y f32
	z f32
}


// Kore/PipelineStateImpl

pub struct C.kinc_g4_pipeline_impl_t {
	_pipeline kinc_g5_pipeline_t
}

pub struct C.kinc_g4_constant_location_impl_t {
	_location kinc_g5_constant_location_t
}

pub struct C.Kinc_G4_AttributeLocationImpl {
	nothing int
}


// Kore/ShaderImpl

pub struct C.kinc_g4_shader_impl_t {
	_shader kinc_g5_shader_t
}


// Kore/TextureImpl

pub struct C.kinc_g4_texture_unit_impl_t {
	_unit kinc_g5_texture_unit_t
}

pub struct C.kinc_g4_texture_impl_t {
	_texture kinc_g5_texture_t
	_uploaded bool
}


// Kore/RenderTargetImpl

pub struct C.kinc_g4_render_target_impl_t {
	_renderTarget kinc_g5_render_target_t
}


// Kore/TextureArrayImpl

pub struct C.kinc_g4_texture_array_impl_t {
	nothing int
}


// Kore/IndexBufferImpl

pub struct C.kinc_g4_index_buffer_impl_t {
	_buffer kinc_g5_index_buffer_t
}


// Kore/CommandList5Impl

pub struct C.CommandList5Impl {
}


// Kore/ConstantBuffer5Impl

pub struct C.ConstantBuffer5Impl {
	_buffer voidptr
	lastStart int
	lastCount int
	mySize int
}

