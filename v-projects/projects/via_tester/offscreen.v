import via
import via.math
import via.input
import via.graphics
import via.components
import via.libs.imgui

struct AppState {
mut:
	atlas graphics.TextureAtlas
	batch &graphics.QuadBatch = &graphics.QuadBatch(0)
	offscreen_pass graphics.OffScreenPass
	rot f32
	pp_no_border bool
	cam components.Camera
}

fn main() {
	state := AppState{
		cam: components.camera()
	}
	via.run(via.ViaConfig{
		imgui: true
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
	igCheckbox(c'No Border', &state.pp_no_border)

	pp_cfg := if state.pp_no_border {
		state.offscreen_pass.get_pixel_perfect_no_border_config()
	} else {
		state.offscreen_pass.get_pixel_perfect_config()
	}
	sx := f32(state.offscreen_pass.color_tex.width) / pp_cfg.sx
	sy := f32(state.offscreen_pass.color_tex.height) / pp_cfg.sy

	wx, wy := via.win.get_size()
	C.igText(c'Win size: %d, %d', wx, wy)
	rx, ry := via.win.get_drawable_size()
	C.igText(c'Win draw: %d, %d', rx, ry)
	C.igText(c'Scale, Offset: %f, (%f, %f)', pp_cfg.sx, pp_cfg.x, pp_cfg.y)

	mut x, mut y := input.mouse_pos_scaled(pp_cfg.sx, pp_cfg.sy, pp_cfg.x, pp_cfg.y)
	C.igText(c'Mouse Scaled: %d, %d', x, y)

	x, y = input.mouse_pos()
	C.igText(c'Mouse Raw: %d, %d', x, y)

	C.igText(c'RT Offset: %f, %f', pp_cfg.x, pp_cfg.y)
	C.igText(c'RT size: %d, %d', state.offscreen_pass.color_tex.width, state.offscreen_pass.color_tex.height)

	C.igText(c'Camera')
	C.igDragFloat2(c'Position', &state.cam.pos, 1, -200, 200, C.NULL, 1)
	C.igSliderAngle('Rotation', &state.cam.rot, -360, 360, C.NULL)
	C.igDragFloat2(c'Scale', &state.cam.scale, 0.01, 0.1, 4, C.NULL, 1)
}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.make_pass_action({color:math.color_from_floats(0.7, 0.4, 0.8, 1.0)})
	trans_mat := state.cam.get_trans_mat()
	via.g.begin_offscreen_pass(state.offscreen_pass, {trans_mat:&trans_mat})

	state.batch.begin()
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x: 0, y: 0, sx: 1, sy: 1})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-03'), {x: -50, y: 50, sx: 1, sy: 1})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-02'), {x: -100, y: -50, sx: 1, sy: 1})
	state.batch.end()

	via.g.end_pass()

	via.g.begin_default_pass(pass_action, {blit_pass:true})

	// full screen, untranslated projection for the final render
	state.batch.begin()
	// state.batch.draw(state.offscreen_pass.color_tex, {x:-w/2+128*3 y:0 sx:3 sy:3 ox:128 oy:128})
	// state.batch.draw(state.offscreen_pass.color_tex, {x:w/2-128, y:-h/2+128 rot:state.rot sx:1, sy:1, ox:128, oy:128})
	// state.batch.draw(state.offscreen_pass.color_tex, {x:w/2-128*2, y:h/2-128*2, sx:2, sy:2, ox:128, oy:128})

	// state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x: 0, y: 0, sx: 1, sy: 1})
	// state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x: 0, y: 0, sx: 4, sy: 4})
	// state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-03'), {x: -100, y: 100, sx: 4, sy: 4})
	// state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-02'), {x: -100, y: -100, sx: 4, sy: 4})

	if state.pp_no_border {
		state.batch.draw(state.offscreen_pass.color_tex, state.offscreen_pass.get_pixel_perfect_no_border_config())
	} else {
		state.batch.draw(state.offscreen_pass.color_tex, state.offscreen_pass.get_pixel_perfect_config())
	}
	state.batch.end()

	via.g.end_pass()
}