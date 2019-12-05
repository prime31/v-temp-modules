module gl3w

fn C.gl3wInit()

// shaders
fn C.glCreateShader(typ int) u32
fn C.glShaderSource(shader u32, a int, source &byteptr, b int)
fn C.glCompileShader(shader u32)
fn C.glCreateProgram() u32
fn C.glDeleteProgram(program u32)
fn C.glAttachShader(program u32, shader u32)
fn C.glLinkProgram(program u32)
fn C.glIsProgram(program u32) byte
fn C.glUseProgram(program u32)

fn C.glGetAttribLocation(program u32, name byteptr) int
fn C.glEnableVertexAttribArray(index u32)
fn C.glDisableVertexAttribArray(index u32)
fn C.glVertexAttribPointer(index int, size int, typ int, normalized bool, stride int, ptr int)

fn C.glDrawElements(mode int, count int, typ int, indices voidptr)
fn C.glDrawArrays(mode int, first int, count int)

// buffers
fn C.glGenBuffers(size int, vbo &u32) u32
fn C.glBindBuffer(typ int, vbo u32)
fn C.glBufferData(typ int, size int, arr voidptr, draw_typ int)
fn C.glDeleteBuffers(size int, buffers &u32)

fn C.glGenVertexArrays(size int, arrays &u32) u32
fn C.glBindVertexArray(vao u32)

// stuff
fn C.glClearColor(r f32, g f32, b f32, a f32)
fn C.glClear(mask int)