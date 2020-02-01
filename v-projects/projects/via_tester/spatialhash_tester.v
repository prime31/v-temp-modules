import via
import via.math
import via.time
import via.input
import via.debug
import via.graphics
import via.filesystem
import via.collections
import via.libs.imgui

struct Sprite {
pub mut:
	col collections.Collider = collections.Collider{
		w: 32.0
		h: 32.0
	}
	vx f32
	vy f32
	id int
}

struct AppState {
mut:
	batch &graphics.QuadBatch = &graphics.QuadBatch(0)
	dude_tex graphics.Texture
	sprites []&Sprite
	space &collections.SpatialHash = &collections.SpatialHash(0)
	dude &Sprite
}

const (
	width = 1024.0
	height = 768.0
)

fn main() {
	state := AppState{
		space: collections.spatialhash(150)
	}
	filesystem.mount('../assets', 'assets', true)
	via.run(via.ViaConfig{
		window_resizable: false
	}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	state.dude_tex = via.g.new_texture('assets/dude.png')
	state.batch = graphics.quadbatch(4001)
	for i in 0..4000 {
		state.add_sprite(math.range(-width, width), math.range(-height, height))
	}

	state.dude = &Sprite {}
	state.dude.id = state.space.add(state.dude.col)
}

fn (state mut AppState) add_sprite(x, y f32) {
	mut sprite := &Sprite {
		vx: math.range(-150, 150)
		vy: math.range(-150, 150)
	}
	sprite.col.x = x
	sprite.col.y = y
	sprite.id = state.space.add(sprite.col)
	state.sprites << sprite
}

pub fn (state mut AppState) update(via &via.Via) {
	dt := time.get_dt()
	for i, sprite in state.sprites {
		mut s := state.sprites[i]
		s.col.x += s.vx * dt
		s.col.y += s.vy * dt

		if s.col.x + s.col.w > width {
			s.vx *= -1
			s.col.x = width - s.col.w
		} else 	if s.col.x < -width {
			s.vx *= -1
			s.col.x = -width
		}
		if s.col.y + s.col.h > height {
			s.vy *= -1
			s.col.y = height - s.col.h
		} else if s.col.y < -height {
			s.vy *= -1
			s.col.y = -height
		}

		// println('---------------- s.id: $s.id')
		state.space.update(s.id, s.col)
	}

	mut mx, mut my := input.mouse_pos()
	mx -= int(width)
	my -= int(height)
	state.dude.col.x = mx
	state.dude.col.y = my
	state.space.update(state.dude.id, state.dude.col)
}

pub fn (state mut AppState) draw(via mut via.Via) {
	via.g.begin_default_pass({color:math.color_from_floats(0.5, 0.4, 0.8, 1.0)}, {})

	state.batch.begin()
	for s in state.sprites {
		state.batch.draw(state.dude_tex, {x:s.col.x, y:s.col.y})
	}
	state.batch.draw(state.dude_tex, {x:state.dude.col.x, y:state.dude.col.y})
	debug.draw_text(state.dude.col.x, state.dude.col.y, '$state.dude.col.x,$state.dude.col.y', {scale:3})
	state.batch.end()

	state.space.debug_draw()
	debug.draw_text(-width, -height, 'FPS: $time.fps()', {align:.top scale:6 color:math.color_black()})
	via.g.end_pass()
}