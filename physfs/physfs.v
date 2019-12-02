module physfs


pub fn initialize() int {
	return C.PHYSFS_init(C.NULL)
}

pub fn deinit() int {
	return C.PHYSFS_deinit()
}

pub fn get_linked_version() C.PHYSFS_Version {
	version := C.PHYSFS_Version{}
	C.PHYSFS_getLinkedVersion(&version)
	return version
}

pub fn supported_archive_types() []ArchiveInfo {
	ptr := C.PHYSFS_supportedArchiveTypes()

	mut arr := []ArchiveInfo
	info_ptr_array := **ArchiveInfo(ptr)

	mut i := 0
	for voidptr(info_ptr_array[i]) != voidptr(0) {
		info := *ArchiveInfo(info_ptr_array[i])
		arr << *info
		i++
	}

	return arr
}

pub fn get_dir_separator() string {
	return string(C.PHYSFS_getDirSeparator())
}

pub fn permit_symbolic_links(allow int) {
	C.PHYSFS_permitSymbolicLinks(allow)
}

pub fn get_base_dir() string {
	return string(C.PHYSFS_getBaseDir())
}

pub fn get_write_dir() string {
	str := C.PHYSFS_getWriteDir()
	if str == C.NULL {
		return ''
	}
	return string(str)
}

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

pub fn is_init() int {
	return C.PHYSFS_isInit()
}

pub fn mount(newDir string, mountPoint string, appendToPath int) int {
	return C.PHYSFS_mount(newDir.str, mountPoint.str, appendToPath)
}

pub fn unmount(oldDir string) int {
	return C.PHYSFS_unmount(oldDir.str)
}

pub fn get_search_path_callback(cb fn(voidptr, byteptr), d voidptr) {
	C.PHYSFS_getSearchPathCallback(cb, d)
}

// typedef PHYSFS_EnumerateCallbackResult (*PHYSFS_EnumerateCallback)(void *data, const char *origdir, const char *fname)
pub fn enumerate(dir string, cb fn(voidptr, byteptr, byteptr) int, d voidptr) int {
	return C.PHYSFS_enumerate(dir.str, cb, d)
}
