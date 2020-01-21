import prime31.stb.truetype as tt
import via.libs.stb.image
import via.math
import os

fn main() {
	load_font()
}

fn load_font() {
	first_char := ` `
	total_chars := 100
	font_size := 10.0

	total_pixels := int(font_size * font_size) * total_chars
	root := int(math.sqrt(total_pixels / 2))
	tex_size := math.ceilpow2_int(root)

	w := tex_size
	h := tex_size / 2 // TODO: is this too aggressively small?
	bitmap := malloc(w * h)

	ctx := C.stbtt_pack_context{}
	if (C.stbtt_PackBegin(&ctx, bitmap, w, h, 0, 1, C.NULL) != 1) {
		println('Error initializing font map in stbtt_PackBegin')
		return
	}

	stbtt_PackSetOversampling(&ctx, 1, 1)

	font_data := os.read_bytes('/Users/desaro/Library/Fonts/ProggyTiny.ttf') or { panic('file not loaded') }

	ascent := 0.0
	descent := 0.0
	linegap := 0.0
	stbtt_GetScaledFontVMetrics(font_data.data, 0, font_size, &ascent, &descent, &linegap)
	println('ascent=$ascent, descent=$descent, linegap=$linegap')

	// char_info := [total_chars]C.stbtt_packedchar
	//char_info := malloc(sizeof(C.stbtt_packedchar) * total_chars)
	char_info := make(total_chars, total_chars, sizeof(C.stbtt_packedchar))
	if (stbtt_PackFontRange(&ctx, font_data.data, 0, font_size, first_char, total_chars, char_info.data) != 1) {
		stbtt_PackEnd(&ctx)
		free(char_info)
		free(font_data)
		free(bitmap)
		return
	}

	stbtt_PackEnd(&ctx)

	mut c := `z`
	xpos := 0.0
	ypos := 0.0
	quad := stbtt_aligned_quad{}
	// stbtt_GetPackedQuad(char_info.data, w, h, c - first_char, &xpos, &ypos, &quad, 1)
	q := tt.get_packed_quad(char_info, w, h, int(c - first_char), true)
	println('$xpos, $ypos')
	println('$q')

	c = `z`
	// stbtt_GetPackedQuad(char_info.data, w, h, c - first_char, &xpos, &ypos, &quad, 1)
	q2 := tt.get_packed_quad(char_info, w, h, int(c - first_char), true)
	println('$xpos, $ypos')
	println('$q2')

	// image.write_png('/Users/desaro/Desktop/font.png', w, h, 1, bitmap)

	char_info.free()
	free(bitmap)
}
