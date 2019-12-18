module image

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

fn C.stbi_write_png(filename byteptr, w int, h int, comp int, data voidptr, stride_in_bytes int) int
fn C.stbi_write_bmp(filename byteptr, w int, h int, comp int, data voidptr) int
fn C.stbi_write_tga(filename byteptr, w int, h int, comp int, data voidptr) int
fn C.stbi_write_hdr(filename byteptr, w int, h int, comp int, data voidptr) int
fn C.stbi_write_jpg(filename byteptr, x int, y int, comp int, data voidptr, quality int) int


pub fn write_png(filename string, width int, height int, channels int, data voidptr) int {
	// if 0 (.default) is passed in assume 4 channels
	stride_mult := if channels == 0 { 4 } else { channels }
	return C.stbi_write_png(filename.str, width, height, channels, data, width * stride_mult)
}

pub fn write_bmp(filename string, width int, height int, channels int, data voidptr) int {
	return C.stbi_write_bmp(filename.str, width, height, channels, data)
}

pub fn write_tga(filename string, width int, height int, channels int, data voidptr) int {
	return C.stbi_write_tga(filename.str, width, height, channels, data)
}

pub fn write_hdr(filename string, width int, height int, channels int, data voidptr) int {
	return C.stbi_write_hdr(filename.str, width, height, channels, data)
}

pub fn write_jpg(filename string, width int, height int, channels int, data voidptr, quality int) int {
	return C.stbi_write_jpg(filename.str, width, height, channels, data, quality)
}


pub fn (img Image) save_as_png(filename string) int {
	return C.stbi_write_png(filename.str, img.width, img.height, img.channels, img.data, img.width * img.channels)
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