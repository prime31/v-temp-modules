#include "fmod.h"
#include "physfs.h"
#include <stdio.h>


FMOD_RESULT F_CALLBACK physfs_file_system_open(const char *name, unsigned int *filesize, void **handle, void *userdata) {
    if (name) {
        PHYSFS_File *fp;

        fp = PHYSFS_openRead(name);
        if (!fp)
            return FMOD_ERR_FILE_NOTFOUND;

        *filesize = (unsigned int)PHYSFS_fileLength(fp);
        *handle = fp;
    }

    return FMOD_OK;
}

FMOD_RESULT F_CALLBACK physfs_file_system_close(void *handle, void *userdata) {
    if (!handle)
        return FMOD_ERR_INVALID_PARAM;

    PHYSFS_close((PHYSFS_File*)handle);

    return FMOD_OK;
}

FMOD_RESULT F_CALLBACK physfs_file_system_read(void *handle, void *buffer, unsigned int sizebytes, unsigned int *bytesread, void *userdata) {
    if (!handle)
        return FMOD_ERR_INVALID_PARAM;

    if (bytesread) {
        *bytesread = PHYSFS_readBytes((PHYSFS_File*)handle, buffer, sizebytes);

        if (*bytesread < sizebytes)
            return FMOD_ERR_FILE_EOF;
    }

    return FMOD_OK;
}

FMOD_RESULT F_CALLBACK physfs_file_system_seek(void *handle, unsigned int pos, void *userdata) {
    if (!handle)
        return FMOD_ERR_INVALID_PARAM;

    PHYSFS_seek((PHYSFS_File*)handle, pos);

    return FMOD_OK;
}

void set_physfs_file_system(FMOD_SYSTEM *s) {
    FMOD_System_SetFileSystem(s, physfs_file_system_open, physfs_file_system_close, physfs_file_system_read, physfs_file_system_seek, 0, 0, 2048);
}