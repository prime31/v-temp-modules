module via

struct Graphics {
	tmp int
}

fn create_graphics(config ViaConfig) &Graphics {
	return &Graphics{}
}

fn (g &Graphics) free() {
	free(g)
}