module sdl2

#flag darwin -L /usr/local/lib -lSDL2 -lSDL2_TTF -lSDL2_MIXER
#flag darwin -I /usr/local/opt/sdl2/include/SDL2
#flag darwin -I /usr/local/opt/sdl2_ttf/include/SDL2
#flag darwin -I /usr/local/opt/sdl2_mixer/include/SDL2

#flag linux `sdl2-config --cflags --libs`  -lSDL2_ttf -lSDL2_mixer

#flag windows -I/msys64/mingw64/include/SDL2
#flag windows -Dmain=SDL_main
#flag windows -L/mingw64/lib -lmingw32 -lSDL2main -lSDL2 -lSDL2_ttf -lSDL2_mixer

#flag -DSDL_DISABLE_IMMINTRIN_H

#include <SDL.h>
#include <SDL_ttf.h>
#include <SDL_mixer.h>