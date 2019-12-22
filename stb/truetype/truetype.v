module truetype
import prime31.math

#flag -I @VMOD/prime31/stb/truetype/thirdparty

#define STB_RECT_PACK_IMPLEMENTATION
#include "stb_rect_pack.h"

#define STB_TRUETYPE_IMPLEMENTATION
#define STBTT_STATIC
#include "stb_truetype.h"

pub struct C.stbtt_pack_context {}

pub struct C.stbtt_packedchar {
pub:
   x0 u16 // coordinates of bbox in bitmap
   y0 u16
   x1 u16
   y1 u16
   xoff f32
   yoff f32
   xadvance f32
   xoff2 f32
   yoff2 f32
}
pub fn (c stbtt_packedchar) str() string {
   return 'bbox coords: $c.x0,$c.y0  $c.x1,$c.y1  off=$c.xoff, $c.yoff  xadv=$c.xadvance  off2=$c.xoff2, $c.yoff2'
}

pub struct C.stbtt_aligned_quad {
pub mut:
   x0 f32 // top-left
   y0 f32
   s0 f32
   t0 f32
   x1 f32 // bottom-right
   y1 f32
   s1 f32
   t1 f32
}
pub fn (quad stbtt_aligned_quad) str() string {
   return 'x0=$quad.x0, y0=$quad.y0  s0=$quad.s0, t0=$quad.t0 - x1=$quad.x1, y1=$quad.y1  s1=$quad.s1, t1=$quad.t1'
}

//int  stbtt_PackBegin(stbtt_pack_context *spc, unsigned char *pixels, int width, int height,
	// int stride_in_bytes, int padding, void *alloc_context)
fn C.stbtt_PackBegin(spc &C.stbtt_pack_context, pixels voidptr, width int, height int, stride_in_bytes int, padding int, ctx voidptr) int

// void stbtt_PackSetOversampling(stbtt_pack_context *spc, unsigned int h_oversample, unsigned int v_oversample)
fn C.stbtt_PackSetOversampling(spc &C.stbtt_pack_context, h_oversample u32, v_oversample u32)

// int stbtt_PackFontRange(stbtt_pack_context *spc, const unsigned char *fontdata, int font_index, float font_size,
//             int first_unicode_codepoint_in_range, int num_chars_in_range, stbtt_packedchar *chardata_for_range)
fn C.stbtt_PackFontRange(spc &C.stbtt_pack_context, fontdata charptr, font_index int, font_size f32, first_unicode_codepoint_in_range int, num_chars_in_range int, chardata_for_range &C.stbtt_packedchar) int

// void stbtt_PackEnd  (stbtt_pack_context *spc)
fn C.stbtt_PackEnd(spc &C.stbtt_pack_context)

// void stbtt_GetPackedQuad(const stbtt_packedchar *chardata, int pw, int ph,  // same data as above
//                                int char_index,             // character to display
//                                float *xpos, float *ypos,   // pointers to current position in screen pixel space
//                                stbtt_aligned_quad *q,      // output: quad to draw
//                                int align_to_integer)
fn C.stbtt_GetPackedQuad(chardata &C.stbtt_packedchar, pw int, ph int, char_index int, xpos &f32, ypos &f32, q &stbtt_aligned_quad, align_to_int int)

fn C.stbtt_GetScaledFontVMetrics(fontdata charptr, index int, size f32, ascent &f32, descent &f32, lineGap &f32)

// .ttc files may contain multiple fonts
fn C.stbtt_GetNumberOfFonts(fontdata charptr) int


pub fn get_packed_quad(chardata []stbtt_packedchar, pw int, ph int, char_index int, align_to_int bool) stbtt_aligned_quad {
	ipw := 1.0 / pw
	iph := 1.0 / ph
	b := chardata[char_index]
	mut q := stbtt_aligned_quad{}

	if align_to_int {
		x := f32(math.ifloor((b.xoff) + 0.5))
		y := f32(math.ifloor((b.yoff) + 0.5))
		q.x0 = x
		q.y0 = y
		q.x1 = x + b.xoff2 - b.xoff
		q.y1 = y + b.yoff2 - b.yoff
	} else {
		q.x0 = b.xoff
		q.y0 = b.yoff
		q.x1 = b.xoff2
		q.y1 = b.yoff2
	}

	q.s0 = f32(b.x0) * ipw
	q.t0 = f32(b.y0) * iph
	q.s1 = f32(b.x1) * ipw
	q.t1 = f32(b.y1) * iph

	return q
}