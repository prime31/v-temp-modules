VMOD := $${HOME}/.vmodules/

build:
	emcc wasm.c \
	-s WASM=1 \
	-s USE_SDL=2 \
	--preload-file ../assets \
	-s -I$(VMOD)prime31/flecs/thirdparty \
	-s -I$(VMOD)prime31/flecs/thirdparty/include \
	-s -I$(VMOD)prime31/flecs/thirdparty/include/util \
	-s $(VMOD)prime31/flecs/thirdparty/webgl/libflecs_static.a \
	-o wasm.html

run:
	emrun wasm.html

open:
	emrun --no_browser --port 8080 .


build-and-run: build
	emrun --no_browser --port 8080 .
