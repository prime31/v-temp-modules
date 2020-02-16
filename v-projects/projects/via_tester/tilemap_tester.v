import via
import via.math
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

	via.run(via.ViaConfig{
		win_highdpi: false
		resolution_policy: .show_all_pixel_perfect
		design_width: 640
		design_height: 480
		win_width: 640 * 2
		win_height: 480 * 2
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	filesystem.mount('assets', '', true)
	map := json.decode(tilemap.Map, filesystem.read_text_c(c'assets/platformer.json')) or { panic('could not load map') }
	state.renderer = tilemap.maprenderer(map)
	state.layer_batch = state.renderer.tilelayer_atlasbatch(map.tile_layers[0])

	t1 := map.tilesets[0].tileset_tile(2)
	for p in t1.props {
		println('$p.key -> $p.value')
	}
}

pub fn (state &AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_pass({color:math.color_from_floats(0.3, 0.1, 0.4, 1.0)})
	//state.renderer.render()
	state.layer_batch.draw()
	graphics.end_pass()
}