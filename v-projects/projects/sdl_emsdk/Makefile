
build:
	emcc wasm.c \
	-s WASM=1 \
	-s USE_SDL=2 \
	-s USE_SDL_IMAGE=2 \
	-s USE_SDL_TTF=2 \
	-s SDL2_IMAGE_FORMATS='["png"]' \
	--preload-file ../assets \
	-o wasm.js

run:
	emrun wasm.html

open:
	emrun --no_browser --port 8080 .


build-and-run: build
	emrun --no_browser --port 8080 .
