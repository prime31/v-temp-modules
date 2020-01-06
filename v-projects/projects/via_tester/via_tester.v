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
}

pub fn (state &AppState) update(via &via.Via) {
	println('update called')
}

pub fn (state &AppState) draw(via &via.Via) {
	println('draw called')
}