module c

fn C.sg_setup(&sg_desc)

fn C.sg_make_buffer(&sg_buffer_desc) sg_buffer
fn C.sg_make_image(&sg_image_desc) sg_image
fn C.sg_make_shader(&sg_shader_desc) C.sg_shader
fn C.sg_make_pipeline(&C.sg_pipeline_desc) C.sg_pipeline
fn C.sg_make_pass(&sg_pass_desc) sg_pass

fn C.sg_begin_default_pass(actions &sg_pass_action, width int, height int)
fn C.sg_begin_pass(pass sg_pass, actions &sg_pass_action)
fn C.sg_apply_pipeline(pip sg_pipeline)
fn C.sg_apply_bindings(bindings &sg_bindings)

fn C.sg_apply_uniforms(stage &sg_shader_stage, ub_index int, data voidptr, num_bytes int)
fn C.sg_draw(base_element int, num_elements int, num_instances int)
fn C.sg_end_pass()
fn C.sg_commit()
fn C.sg_shutdown()

fn C.sg_destroy_buffer(buf sg_buffer)
fn C.sg_destroy_image(img sg_image)
fn C.sg_destroy_shader(shd sg_shader)
fn C.sg_destroy_pipeline(pip sg_pipeline)
fn C.sg_destroy_pass(pass sg_pass)

fn C.sg_apply_viewport(x int, y int, width int, height int, origin_top_left bool)
fn C.sg_apply_scissor_rect(x int, y int, width int, height int, origin_top_left bool)
fn C.sg_update_buffer(buf sg_buffer, ptr voidptr, num_bytes int)
fn C.sg_update_image(img sg_image, content &sg_image_content)

fn C.sg_append_buffer(buf sg_buffer, ptr voidptr, num_bytes int) int

fn C.sg_query_buffer_overflow(buf sg_buffer) bool
fn C.sg_query_features() sg_features
fn C.sg_query_limits() sg_limits
fn C.ssg_query_pixelformat(fmt sg_pixel_format) g_pixelformat_info
fn C.sg_reset_state_cache()

fn C.sg_query_buffer_info(buf sg_buffer) sg_buffer_info
fn C.sg_query_image_info(img sg_image) sg_image_info
fn C.sg_query_shader_info(shd sg_shader) sg_shader_info
fn C.sg_query_pipeline_info(pip sg_pipeline) sg_pipeline_info
fn C.sg_query_pass_info(pass sg_pass) sg_pass_info

fn C.sg_query_backend() sg_backend
fn C.sg_query_buffer_defaults(desc &sg_buffer) sg_buffer_desc
fn C.sg_query_image_defaults(desc &sg_image) sg_image_desc
fn C.sg_query_shader_defaults(desc &sg_shader) sg_shader_desc
fn C.sg_query_pipeline_defaults(desc &sg_pipeline) sg_pipeline_desc
fn C.sg_query_pass_defaults(desc &sg_pass) sg_pass_desc