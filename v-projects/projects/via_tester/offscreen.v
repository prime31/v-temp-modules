import via
import via.math
import via.input
import via.debug
import via.window
import via.graphics
import via.components
import via.components.posteffects
import via.libs.imgui

const (
	frag_sepia = '
	vec4 effect(vec4 vcolor, sampler2D tex, vec2 texcoord) {
		vec4 color = texture(tex, texcoord);

		vec3 _sepia_tone = vec3(1.2, 1.0, 0.8);
		// first we need to convert to greyscale
		float gray_scale = dot(color.rgb, vec3(0.3, 0.59, 0.11));
		color.rgb = gray_scale * _sepia_tone;

		return color;
	}'
)

struct AppState {
mut:
	atlas graphics.TextureAtlas
	offscreen_pass graphics.OffScreenPass
	rot f32
	pp_no_border bool
	cam components.Camera

	pp_stack &graphics.EffectStack
	vig posteffects.Vignette
	noise posteffects.Noise
}

fn main() {
	state := AppState{
		pp_stack: 0
	}

	via.run(via.ViaConfig{
		imgui: true
		imgui_gfx_debug: true
		win_highdpi: true
		resolution_policy: .show_all_pixel_perfect // .no_border_pixel_perfect
		design_width: 256
		design_height: 256
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.cam = components.camera()
	state.offscreen_pass = graphics.new_offscreenpass(256, 256)
	state.atlas = graphics.new_texture_atlas('assets/adventurer.atlas')

	state.pp_stack = graphics.new_effectstack()
	state.noise = posteffects.noise()
	state.noise.add_to_stack(mut state.pp_stack)
	state.vig = posteffects.vignette()
	state.vig.add_to_stack(mut state.pp_stack)
}

pub fn (state mut AppState) update() {
	state.rot += 0.5
	igCheckbox(c'No Border', &state.pp_no_border)

	scaler := graphics.get_resolution_scaler()
	sx := f32(state.offscreen_pass.color_tex.w) / scaler.scale
	sy := f32(state.offscreen_pass.color_tex.h) / scaler.scale

	wx, wy := window.size()
	C.igText(c'Win size: %d, %d', wx, wy)
	rx, ry := window.drawable_size()
	C.igText(c'Win draw: %d, %d', rx, ry)
	C.igText(c'RT Scale, Offset: %f, (%d, %d)', scaler.scale, scaler.x, scaler.y)

	C.igText(c'Mouse')
	msx, msy := input.mouse_pos_scaled()
	C.igText(c'Mouse Scaled: %d, %d', msx, msy)

	x, y := input.mouse_pos()
	C.igText(c'Mouse Raw: %d, %d', x, y)

	cx, cy := state.cam.screen_to_world(msx, msy)
	C.igText(c'Mouse to World: %d, %d', cx, cy)

	C.igText(c'Camera')
	C.igDragFloat2(c'Position', &state.cam.pos, 1, -200, 200, C.NULL, 1)
	C.igSliderAngle('Rotation', &state.cam.rot, -360, 360, C.NULL)
	C.igDragFloat2(c'Scale', &state.cam.scale, 0.01, 0.1, 4, C.NULL, 1)

	state.vig.imgui()
	state.noise.imgui()
}

pub fn (state mut AppState) draw() {
	trans_mat := state.cam.trans_mat()

	// render pass to the default offscreen pass
	graphics.begin_pass({color:math.color_cornflower_blue() trans_mat:&trans_mat})
	debug.set_color(math.color_deep_sky_blue())
	debug.draw_filled_rect(0, 0, 100, 100)
	debug.set_color(math.color_yellow())
	debug.draw_hollow_rect(0, 0, 100, 100)
	debug.reset_color()
	debug.draw_filled_rect(0, 0, 25, 25)
	debug.draw_text(0, 0, 'holy crap does it work?', {color:math.color_red() scale:2.0})
	debug.draw_text(0, 10, 'holy crap does it work?', {color:math.color_red()})

	mut batch := graphics.spritebatch()
	batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x:0 y:-50 sx:1 sy:1})
	batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-attack2-01'), {x:-50 y:50 sx:1 sy:1})
	batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-crnr-grb-02'), {x:-100 y:-100 sx:1 sy:1})
	graphics.end_pass()

	// optional post processing and blit to the backbuffer
	graphics.postprocess(state.pp_stack)
	graphics.blit_to_screen(math.color_from_floats(0.0, 0.0, 0.0, 1.0))

	// screenspace, full resolution rendering directly to the backbuffer
	graphics.begin_pass({color_action:.dontcare})
	batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x:0 y:0 sx:1 sy:1})
	batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-attack2-01'), {x:50 y:50 sx:1 sy:1})
	batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-crnr-grb-02'), {x:100 y:100 sx:1 sy:1})
	graphics.end_pass()
}