module physfs


[inline]
pub fn initialize() int {
	return C.PHYSFS_init(C.NULL)
}

[inline]
pub fn deinit() int {
	return C.PHYSFS_deinit()
}

[inline]
pub fn get_linked_version() PHYSFS_Version {
	version := PHYSFS_Version{}
	C.PHYSFS_getLinkedVersion(&version)
	return version
}

[inline]
pub fn supported_archive_types() []PHYSFS_ArchiveInfo {
	ptr := C.PHYSFS_supportedArchiveTypes()

	mut arr := []PHYSFS_ArchiveInfo
	info_ptr_array := **PHYSFS_ArchiveInfo(ptr)

	// iterate until we find a null element
	for i := 0; info_ptr_array[i]; i++ {
		info := *PHYSFS_ArchiveInfo(info_ptr_array[i])
		arr << *info
	}

	return arr
}

[inline]
pub fn get_dir_separator() string {
	return string(C.PHYSFS_getDirSeparator())
}

[inline]
pub fn permit_symbolic_links(allow int) {
	C.PHYSFS_permitSymbolicLinks(allow)
}

[inline]
pub fn get_base_dir() string {
	return string(C.PHYSFS_getBaseDir())
}

[inline]
pub fn get_write_dir() string {
	str := C.PHYSFS_getWriteDir()
	if str == C.NULL {
		return ''
	}
	return string(str)
}

[inline]
pub fn get_search_path() []string {
	ptr := C.PHYSFS_getSearchPath()

	mut arr := []string
	string_ptr_array := **byteptr(ptr)

	mut i := 0
	for voidptr(string_ptr_array[i]) != voidptr(0) {
		arr << string(string_ptr_array[i])
		i++
	}

	return arr
}

[inline]
pub fn is_init() int {
	return C.PHYSFS_isInit()
}

[inline]
pub fn mount(newDir string, mountPoint string, appendToPath int) int {
	return C.PHYSFS_mount(newDir.str, mountPoint.str, appendToPath)
}

[inline]
pub fn unmount(oldDir string) int {
	return C.PHYSFS_unmount(oldDir.str)
}

[inline]
pub fn get_search_path_callback(cb fn(voidptr, byteptr), d voidptr) {
	C.PHYSFS_getSearchPathCallback(cb, d)
}

// (*PHYSFS_EnumerateCallback)(void *data, const char *origdir, const char *fname)
[inline]
pub fn enumerate(dir string, cb fn(voidptr, byteptr, byteptr) int, d voidptr) int {
	return C.PHYSFS_enumerate(dir.str, cb, d)
}

[inline]
pub fn exists(fname byteptr) int {
	return PHYSFS_exists(fname)
}

[inline]
pub fn open_read(fname charptr) &C.PHYSFS_File {
	return PHYSFS_openRead(fname)
}

[inline]
pub fn file_length(handle &PHYSFS_File) i64 {
	return PHYSFS_fileLength(handle)
}

[inline]
pub fn file_close(handle &PHYSFS_File) int {
	return PHYSFS_close(handle)
}

[inline]
pub fn read_bytes(handle &PHYSFS_File, buffer voidptr, len u64) i64 {
	return PHYSFS_readBytes(handle, buffer, len)
}