import prime31.via

struct AppState {
	data int
}

fn main() {
	state := AppState{}
	via := via.create(via.ViaConfig{})
	via.run(state)
}

pub fn (state &AppState) update(via &via.Via) {
	println('update called')
}

pub fn (state &AppState) draw(via &via.Via) {
	println('draw called')
}