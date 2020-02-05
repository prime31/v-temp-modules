import via
import via.math
import via.input
import via.debug
import via.window
import via.graphics
import via.filesystem
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
	filesystem.mount('../assets', 'assets', true)
	state := AppState{
		cam: components.camera()
	}
	via.run(via.ViaConfig{
		imgui: true
		win_highdpi: true
	}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	state.offscreen_pass = via.g.new_offscreen_pass(256, 256)
	state.atlas = via.g.new_texture_atlas('assets/adventurer.atlas')
	state.batch = graphics.quadbatch(20)

	quad1 := state.atlas.get_quad('adventurer-run-04')
}

pub fn (state mut AppState) update(via mut via.Via) {
	state.rot += 0.5
	igCheckbox(c'No Border', &state.pp_no_border)

	pp_cfg := if state.pp_no_border {
		state.offscreen_pass.get_pixel_perfect_no_border_config()
	} else {
		state.offscreen_pass.get_pixel_perfect_config()
	}
	sx := f32(state.offscreen_pass.color_tex.w) / pp_cfg.sx
	sy := f32(state.offscreen_pass.color_tex.h) / pp_cfg.sy

	wx, wy := window.size()
	C.igText(c'Win size: %d, %d', wx, wy)
	rx, ry := window.drawable_size()
	C.igText(c'Win draw: %d, %d', rx, ry)
	C.igText(c'Scale, Offset: %f, (%f, %f)', pp_cfg.sx, pp_cfg.x, pp_cfg.y)

	msx, msy := input.mouse_pos_scaled(pp_cfg.sx, pp_cfg.sy, pp_cfg.x, pp_cfg.y)
	C.igText(c'Mouse Scaled: %d, %d', msx, msy)

	x, y := input.mouse_pos()
	C.igText(c'Mouse Raw: %d, %d', x, y)

	mut cx, mut cy := state.cam.screen_to_world(x, y)
	C.igText(c'Mouse World: %d, %d', cx, cy)

	cx, cy = state.cam.screen_to_offscreen_world(msx, msy, 256, 256, pp_cfg.sx, pp_cfg.sy)
	C.igText(c'Mouse Offscreen World: %d, %d', cx, cy)

	C.igText(c'RT Offset: %f, %f', pp_cfg.x, pp_cfg.y)
	C.igText(c'RT size: %d, %d', state.offscreen_pass.color_tex.w, state.offscreen_pass.color_tex.h)

	C.igText(c'Camera')
	C.igDragFloat2(c'Position', &state.cam.pos, 1, -200, 200, C.NULL, 1)
	C.igSliderAngle('Rotation', &state.cam.rot, -360, 360, C.NULL)
	C.igDragFloat2(c'Scale', &state.cam.scale, 0.01, 0.1, 4, C.NULL, 1)
}

pub fn (state mut AppState) draw(via mut via.Via) {
	trans_mat := state.cam.trans_mat()

	via.g.begin_offscreen_pass(state.offscreen_pass, {color:math.color_cornflower_blue()}, {trans_mat:&trans_mat})
	debug.set_color(math.color_deep_sky_blue())
	debug.draw_filled_rect(0, 0, 100, 100)
	debug.set_color(math.color_yellow())
	debug.draw_hollow_rect(0, 0, 100, 100)
	debug.reset_color()
	debug.draw_filled_rect(0, 0, 25, 25)
	debug.draw_text(0, 0, 'holy crap does it work?', {color:math.color_red() scale:2.0})
	debug.draw_text(0, 10, 'holy crap does it work?', {color:math.color_red()})

	state.batch.begin()
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x: 0, y: 0, sx: 1, sy: 1})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-03'), {x: -50, y: 50, sx: 1, sy: 1})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-02'), {x: -100, y: -50, sx: 1, sy: 1})
	state.batch.end()
	via.g.end_pass()

	via.g.begin_default_pass({color:math.color_from_floats(0.7, 0.4, 0.8, 1.0)}, {blit_pass:true})

	if state.pp_no_border {
		state.batch.draw(state.offscreen_pass.color_tex, state.offscreen_pass.get_pixel_perfect_no_border_config())
	} else {
		state.batch.draw(state.offscreen_pass.color_tex, state.offscreen_pass.get_pixel_perfect_config())
	}
	state.batch.end()
	via.g.end_pass()
}