module truetype

#flag -I @VMOD/prime31/stb/truetype/thirdparty

#define STB_RECT_PACK_IMPLEMENTATION
#include "stb_rect_pack.h"

#define STB_TRUETYPE_IMPLEMENTATION 
#include "stb_truetype.h"

pub struct C.stbtt_packedchar {
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

pub struct C.stbtt_aligned_quad {
   x0 f32 // top-left
   y0 f32
   s0 f32
   t0 f32
   x1 f32 // bottom-right
   y1 f32
   s1 f32
   t1 f32
}

//int  stbtt_PackBegin(stbtt_pack_context *spc, unsigned char *pixels, int width, int height,
	// int stride_in_bytes, int padding, void *alloc_context)
fn C.stbtt_PackBegin(spc voidptr, pixels voidptr, width int, height int, stride_in_bytes int, padding int, ctx voidptr) int

// void stbtt_PackSetOversampling(stbtt_pack_context *spc, unsigned int h_oversample, unsigned int v_oversample)
fn C.stbtt_PackSetOversampling(spc voidptr, h_oversampe u32, v_oversample u32)

// int stbtt_PackFontRange(stbtt_pack_context *spc, const unsigned char *fontdata, int font_index, float font_size,
//             int first_unicode_codepoint_in_range, int num_chars_in_range, stbtt_packedchar *chardata_for_range)
fn C.stbtt_PackFontRange(spc voidptr, fontdata charptr, font_index int, font_size f32, first_unicode_codepoint_in_range int, num_chars_in_range int, chardata_for_range &C.stbtt_packedchar) int

// void stbtt_PackEnd  (stbtt_pack_context *spc)
fn C.stbtt_PackEnd(spc voidptr)

// void stbtt_GetPackedQuad(const stbtt_packedchar *chardata, int pw, int ph,  // same data as above
//                                int char_index,             // character to display
//                                float *xpos, float *ypos,   // pointers to current position in screen pixel space
//                                stbtt_aligned_quad *q,      // output: quad to draw
//                                int align_to_integer)
fn C.stbtt_GetPackedQuad(chardata &C.stbtt_packedchar, pw int, ph int, char_index int, xpos &f32, ypos &f32, q &stbtt_aligned_quad, align_to_int int)

