module via
import os
import prime31.physfs

struct FileSystem {
	tmp int
}

fn create_filesystem(config ViaConfig) &FileSystem {
	if physfs.initialize() != 1 { panic('could not initialize PhysFS') }

	physfs.permit_symbolic_links(1)
	physfs.mount(os.dir(os.realpath(os.executable())), '', 1)

	mut identity := config.identity
	if identity.len == 0 {
		identity = os.filename(os.executable())
	}

	// setup save directory and add it to search path
	pref_path_raw := SDL_GetPrefPath(C.NULL, identity.str)
	pref_path := tos2(pref_path_raw)
	physfs.set_write_dir(pref_path)

	append := if config.append_identity { 1 } else { 0 }
	physfs.mount(pref_path, '', append)
	SDL_free(pref_path_raw)

	return &FileSystem{}
}

fn (fs &FileSystem) free() {
	physfs.deinit()
	free(fs)
}