module via

struct Timer {
	tmp int
}

fn create_timer(config ViaConfig) &Timer {
	return &Timer{}
}

fn (t &Timer) free() {
	free(t)
}