module image

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

fn C.stbi_write_png(filename byteptr, w int, h int, comp int, data voidptr, stride_in_bytes int) int
fn C.stbi_write_bmp(filename byteptr, w int, h int, comp int, data voidptr) int
fn C.stbi_write_tga(filename byteptr, w int, h int, comp int, data voidptr) int
fn C.stbi_write_hdr(filename byteptr, w int, h int, comp int, data voidptr) int
fn C.stbi_write_jpg(filename byteptr, x int, y int, comp int, data voidptr, quality int) int


pub fn (img Image) save_as_png(filename string) int {
	return C.stbi_write_png(filename.str, img.width, img.height, img.channels, img.data, img.width * 4)
}

pub fn (img Image) save_as_bmp(filename string) int {
	return C.stbi_write_bmp(filename.str, img.width, img.height, img.channels, img.data)
}

pub fn (img Image) save_as_tga(filename string) int {
	return C.stbi_write_tga(filename.str, img.width, img.height, img.channels, img.data)
}

pub fn (img Image) save_as_hdr(filename string) int {
	return C.stbi_write_hdr(filename.str, img.width, img.height, img.channels, img.data)
}

pub fn (img Image) save_as_jpg(filename string, quality int) int {
	return C.stbi_write_jpg(filename.str, img.width, img.height, img.channels, img.data, quality)
}