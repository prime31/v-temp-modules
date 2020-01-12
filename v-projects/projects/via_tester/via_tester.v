import via

struct AppState {
	data int
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, state)
}

pub fn (state &AppState) initialize(via &via.Via) {
	println('initialize called')
	t := via.graphics.new_texture('assets/beach.png')
	println('t: $t')
	t.free()

	s := via.audio.new_stream('assets/skid.wav')
	_, channel := s.play(0)
	s.set_loop_count(4)
	_, name := s.get_name()
	loops := 0
	s.get_loop_count(&loops)
	println('sound name: $name, loops: $loops')
}

pub fn (state &AppState) update(via &via.Via) {

}

pub fn (state &AppState) draw(via &via.Via) {

}