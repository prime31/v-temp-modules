import via
import via.math
import via.time
import via.debug
import via.window
import via.graphics
import via.filesystem
import via.comps
import via.comps.tilemap
import json

struct AppState {
mut:
	renderer tilemap.MapRenderer
	layer_batch &graphics.AtlasBatch
}

fn main() {
	state := AppState{
		layer_batch: 0
	}

	via.run({
		win_highdpi: true
		resolution_policy: .show_all_pixel_perfect
		design_width: 640
		design_height: 480
		win_width: 640
		win_height: 480
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	filesystem.mount('assets', '', true)

	now0s := time.now()
	map0 := tilemap.load(filesystem.read_bytes_c(c'assets/platformer.json'))
	now0e := time.now()

	now1s := time.now()
	map := json.decode(tilemap.Map, filesystem.read_text_c(c'assets/platformer.json')) or { panic('could not load map') }
	now1e := time.now()

	state.renderer = tilemap.maprenderer(map0)
	state.layer_batch = state.renderer.tilelayer_atlasbatch(map0.tile_layers[0])

	// t1 := map0.tilesets[0].tileset_tile(2)
	// for p in t1.props {
	// 	println('$p.key -> $p.value')
	// }

	jsmnt := now0e - now0s
	jst := now1e - now1s
	debug.warn('-- jsmn: ${f32(jsmnt) / 1000}, jst: ${f32(jst) / 1000} --')
}

pub fn (state &AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_pass({color:math.color_from_floats(0.3, 0.1, 0.4, 1.0)})
	// state.renderer.render()
	state.layer_batch.draw()
	graphics.end_pass()
}