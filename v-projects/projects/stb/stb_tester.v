import os
import prime31.stb.image
import prime31.stb.truetype

fn main() {
	println('hi')
	//load_image()
	// load_image_from_mem()
	load_high_level()
	load_high_level_from_memory()
}

fn load_high_level_from_memory() {
	data := read_bytes('assets/beach.png') or { panic('file not loaded') }
	img := image.load_from_memory(data.data, data.len)
	img.save_as_png('hl_mem_beach.png')
	img.free()

	w, h, comps := image.get_info_from_memory(data.data, data.len)
	println('image w=$w, h=$h, comps=$comps')
}

fn load_high_level() {
	img := image.load('assets/beach.png')
	img.save_as_png('hl_beach.png')
	img.free()

	w, h, comps := image.get_info('assets/beach.png')
	println('image w=$w, h=$h, comps=$comps')
}

fn load_image() {
	w := 0
	h := 0
	channels := 0
	flag := 0
	
	data := C.stbi_load('assets/beach.png', &w, &h, &channels, flag)
	if isnil(data) {
		println('stbi image failed to load')
		exit(1)
	}

	println('w=$w, h=$h, channels=$channels')
	C.stbi_write_png('img_write.png', w, h, channels, data, w * 4)
	C.stbi_write_jpg('img_write.jpg', w, h, channels, data, 100)

	C.stbi_image_free(data)
	println('freed image')
}

fn load_image_from_mem() {
	w := 0
	h := 0
	channels := 0
	flag := 0
	file_data := read_bytes('assets/beach.png') or { panic('file not loaded') }

	C.stbi_info_from_memory(file_data.data, file_data.len, &w, &h, &channels)
	println('loaded image info. w=$w, h=$h, channels=$channels')
}

// tmp until PR that fixes os.read_bytes is in
pub fn read_bytes(path string) ?[]byte {
	mut fp := C.fopen(path.str, 'rb')
	if isnil(fp) {
		return error('failed to open file "$path"')
	}
	C.fseek(fp, 0, C.SEEK_END)
	fsize := C.ftell(fp)
	C.rewind(fp)

	mut res	 := [`0`].repeat(fsize)
	nreadbytes := C.fread(res.data, fsize, 1, fp)
	C.fclose(fp)
	return res[0..nreadbytes * fsize]
}