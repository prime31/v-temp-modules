# doesnt quite work yet with sdl_gl/clear_flext.v
# test instructions:
# - export WASM from v
# - use this Makefile

VMOD := $${HOME}/.vmodules/

build:
	emcc wasm.c \
	$(VMOD)via/libs/flextGL/thirdparty/ES30/flextGL.c \
	-s ERROR_ON_UNDEFINED_SYMBOLS=0 \
	-s WASM=1 \
	-s USE_SDL=2 \
	-s -I$(VMOD)via/libs/flextGL/thirdparty/ES30 \
	-s -I$(VMOD)via/libs/sokol/thirdparty \
	-DSOKOL_GLES3 \
	-o wasm.html

run:
	emrun wasm.html

open:
	emrun --no_browser --port 8080 .


build-and-run: build
	emrun --no_browser --port 8080 .
