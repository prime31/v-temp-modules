module emscripten

// until we get top level $if's we inject this include in the generated C file
//#include <emscripten.h>

fn C.emscripten_set_main_loop_arg(func fn(voidptr), arg voidptr, fps, simulate_infinite_loop int)