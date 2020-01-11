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

	s := via.audio.new_sound('assets/skid.wav')
	s.play(0)
	_, name := s.get_name()
	println('sound name: $name')
}

pub fn (state &AppState) update(via &via.Via) {

}

pub fn (state &AppState) draw(via &via.Via) {

}