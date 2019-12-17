module via

struct FileSystem {
	tmp int
}

fn create_filesystem(config ViaConfig) &FileSystem {
	return &FileSystem{}
}

fn (fs &FileSystem) free() {
	free(fs)
}