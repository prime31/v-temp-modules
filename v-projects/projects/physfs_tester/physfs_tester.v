import prime31.physfs
import prime31.sdl2
import os


fn main() {
	init_res := physfs.initialize()
	println('physfs init=$init_res')

	version := physfs.get_linked_version()
	println('physfs version=$version')

	physfs.mount(os.dir(os.realpath(os.executable())), '', 1)

	types := physfs.supported_archive_types()
	println('physfs supported types:')
	for info in types {
		println('\t$info')
	}

	println('dir seperator: ${physfs.get_dir_separator()}')

	physfs.permit_symbolic_links(1)
	physfs.set_write_dir(tos2(SDL_GetPrefPath(C.NULL, 'game_name')))

	println('base dir: ${physfs.get_base_dir()}')
	println('write dir: ${physfs.get_write_dir()}')

	search_path := physfs.get_search_path()
	println('physfs search path:')
	for path in search_path {
		println('\t$path')
	}

	physfs.get_search_path_callback(string_callback, voidptr(0))
	enum_res := physfs.enumerate('/', enum_callback, voidptr(0))
	println('enum_res=$enum_res')

	println('is init: ${physfs.is_init()}')
	read_txt_file()

	C.IMG_Init(C.IMG_INIT_PNG)
	surface := physfs.load_surface('assets/beach.png'.str)
	println('surface=$surface')

	out_file := os.home_dir() + 'Desktop/shit.png'
	C.IMG_SavePNG(surface, out_file.str)

	physfs.unmount(os.getwd())

	println('physfs deinit=${physfs.deinit()}')
}

fn string_callback(data voidptr, str byteptr) {
	println('string_callback: $str')
}

fn enum_callback(data voidptr, dir byteptr, fname byteptr) int {
	println('enum_callback: dir=$dir, fname=$fname')
	return C.PHYSFS_ENUM_OK
}

fn read_txt_file() {
	fp := physfs.open_read(c'assets/json.json')
	len := physfs.file_length(fp)
	println('json file len=$len')

	// buf := [len]byte // doesnt work
	buf := [`0`].repeat(int(len))
	physfs.read_bytes(fp, buf.data, u64(len))
	println('file contents: ${tos(buf.data, buf.len)}')
	physfs.file_close(fp)
}