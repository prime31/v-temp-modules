module sdl2

#flag darwin -L /usr/local/lib -lSDL2
#flag darwin -I /usr/local/opt/sdl2/include/SDL2

#flag windows -I/msys64/mingw64/include/SDL2
#flag windows -Dmain=SDL_main
#flag windows -L/mingw64/lib -lmingw32 -lSDL2main -lSDL2

#flag -DSDL_DISABLE_IMMINTRIN_H

#include <SDL.h>