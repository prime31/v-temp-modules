#include "fmod.h"
#include "fmod_errors.h"
#include <stdio.h>

// https://github.com/vovoid/vsxu-module-sound.fmod/blob/master/fmodapi43800linux64/examples/filecallbacks/main.cpp

void ERRCHECK(FMOD_RESULT result) {
    if (result != FMOD_OK) {
        printf("FMOD error! (%d) %s\n", result, FMOD_ErrorString(result));
        exit(-1);
    }
}

FMOD_RESULT F_CALLBACK c_file_system_open(const char *name, unsigned int *filesize, void **handle, void *userdata) {
    if (name) {
        FILE *fp;

        fp = fopen(name, "rb");
        if (!fp)
            return FMOD_ERR_FILE_NOTFOUND;

        fseek(fp, 0, SEEK_END);
        *filesize = ftell(fp);
        fseek(fp, 0, SEEK_SET);

        *handle = fp;
    }

    return FMOD_OK;
}

FMOD_RESULT F_CALLBACK c_file_system_close(void *handle, void *userdata) {
    if (!handle)
        return FMOD_ERR_INVALID_PARAM;

    fclose((FILE*)handle);

    return FMOD_OK;
}

FMOD_RESULT F_CALLBACK c_file_system_read(void *handle, void *buffer, unsigned int sizebytes, unsigned int *bytesread, void *userdata) {
    if (!handle)
        return FMOD_ERR_INVALID_PARAM;

    if (bytesread) {
        *bytesread = (int)fread(buffer, 1, sizebytes, (FILE *)handle);

        if (*bytesread < sizebytes)
            return FMOD_ERR_FILE_EOF;
    }

    return FMOD_OK;
}

FMOD_RESULT F_CALLBACK c_file_system_seek(void *handle, unsigned int pos, void *userdata) {
    if (!handle)
        return FMOD_ERR_INVALID_PARAM;

    fseek((FILE*)handle, pos, SEEK_SET);

    return FMOD_OK;
}

void set_c_file_system(FMOD_SYSTEM *s) {
    FMOD_System_SetFileSystem(s, c_file_system_open, c_file_system_close, c_file_system_read, c_file_system_seek, 0, 0, 2048);
}