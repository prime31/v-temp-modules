WASM_BIN := /Users/mikedesaro/Desktop/Dump/emscripten/emsdk/upstream/emscripten

build: setup-emsdk
	$(WASM_BIN)/emcc wasm.c \
	-s WASM=1 \
	-s USE_SDL=2 \
	-s USE_SDL_IMAGE=2 \
	-s USE_SDL_TTF=2 \
	-s SDL2_IMAGE_FORMATS='["png"]' \
	--preload-file ../assets \
	-o wasm.js

setup-emsdk:
	source ~/Desktop/Dump/emscripten/emsdk/emsdk_env.sh --build=Release

run:
	$(WASM_BIN)/emrun wasm.html

open:
	$(WASM_BIN)/emrun --no_browser --port 8080 .


build-and-run: build
	$(WASM_BIN)/emrun --no_browser --port 8080 .
