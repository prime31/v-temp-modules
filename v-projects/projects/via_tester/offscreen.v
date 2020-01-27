import via
import via.math
import via.graphics
import via.libs.imgui

struct AppState {
mut:
	atlas graphics.TextureAtlas
	batch &graphics.QuadBatch = &graphics.QuadBatch(0)
	offscreen_pass graphics.OffScreenPass
	rot f32
	x f32
	y f32
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{
		imgui_enabled: true
	}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	state.offscreen_pass = via.g.new_offscreen_pass(256, 256, math.color_cornflower_blue())
	state.atlas = via.g.new_texture_atlas('assets/adventurer.atlas')
	state.batch = graphics.quadbatch(20)

	quad1 := state.atlas.get_quad('adventurer-run-04')
}

pub fn (state mut AppState) update(via &via.Via) {
	state.rot += 0.5
	igSliderFloat('x'.str, &state.x, -100, 100, C.NULL, 1)
	igSliderFloat('y'.str, &state.y, -100, 100, C.NULL, 1)
}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.make_clear_pass(0.7, 0.4, 0.8, 1.0)
	w, h := via.win.get_drawable_size()

	// render upside-down for the offscreen buffers
	os_proj_mat := math.mat32_ortho_off_center(256, -256)
	// TODO: shouldnt this be translation * projection?
	cam_translated := os_proj_mat * math.mat32_translate(-state.x, -state.y)

	state.offscreen_pass.begin()
	sg_apply_pipeline(via.g.get_default_pipeline().pip)

	state.batch.begin(cam_translated)
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x: 0, y: 0, sx: 1, sy: 1})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-03'), {x: -50, y: 50, sx: 1, sy: 1})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-02'), {x: -100, y: -50, sx: 1, sy: 1})
	state.batch.end()

	sg_end_pass()

	sg_begin_default_pass(&pass_action, w, h)
	sg_apply_pipeline(via.g.get_default_pipeline().pip)

	// full screen, untranslated projection for the final render
	fs_trans_mat := math.mat32_ortho(w, h)
	state.batch.begin(fs_trans_mat)
	// state.batch.draw(state.offscreen_pass.color_tex, {x:-w/2+128*3 y:0 sx:3 sy:3 ox:128 oy:128})
	// state.batch.draw(state.offscreen_pass.color_tex, {x:w/2-128, y:-h/2+128 rot:state.rot sx:1, sy:1, ox:128, oy:128})
	// state.batch.draw(state.offscreen_pass.color_tex, {x:w/2-128*2, y:h/2-128*2, sx:2, sy:2, ox:128, oy:128})

	// state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x: 0, y: 0, sx: 1, sy: 1})
	// state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x: 0, y: 0, sx: 4, sy: 4})
	// state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-03'), {x: -100, y: 100, sx: 4, sy: 4})
	// state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-02'), {x: -100, y: -100, sx: 4, sy: 4})

	state.batch.draw(state.offscreen_pass.color_tex, state.offscreen_pass.get_pixel_perfect_config(w, h))
	state.batch.end()

	sg_end_pass()
	sg_commit()
}