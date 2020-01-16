import via.libs.physfs
import via.libs.sdl2
import via.utils
import os


fn main() {
	init_res := physfs.initialize()
	println('physfs init=$init_res')

	version := physfs.get_linked_version()
	println('physfs version=$version')

	physfs.mount(os.dir(os.realpath(os.executable())), '', true)

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

	enum_files := physfs.enumerate_files('/')
	for f in enum_files { println('enum: $f')}

	println('is init: ${physfs.is_init()}')
	read_txt_file()

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
	fp := physfs.open_read('assets/json.json')
	// fp := physfs.open_read(charptr('assets/json.json'.str))
	len := physfs.file_length(fp)
	println('json file len=$len')

	// buf := [len]byte // doesnt work
	buf := utils.make_array<int>(int(len), int(len))
	physfs.read_bytes(fp, buf.data, u64(len))
	println('file contents: ${tos(buf.data, buf.len)}')
	physfs.close(fp)
}