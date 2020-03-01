import via
import via.math
import via.graphics

struct AppState {}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{
		win_width: 500
		win_height: 300
	}, mut state)
}

pub fn (state mut AppState) initialize() {}

pub fn (state mut AppState) update() {}

pub fn (state mut AppState) draw() {}