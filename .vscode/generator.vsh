import filepath

struct Arg {
    name string
    @type string
}

fn main() {
    src := os.args[1]
    src_dir := os.dir(src)
    src_name := os.filename(src)
    dst_name := src_name.replace('.v', '_gen.v')
    dst := filepath.join(src_dir, dst_name)

    println('')
    println('using src file: $src_dir\nusing dest file: $dst')

    lines := read_lines(src) or { panic(err) }
    mut out_file := create(dst) or { panic(err) }
    defer { out_file.close() }

    out_file.writeln(lines[0])
    out_file.writeln('')

    // state machine
    mut in_comment := false

    for line in lines {
        ln := line.trim_space()
        if ln.len == 0 { continue }

        // direct write comments into generated file
        if in_comment || ln.starts_with('/') {
            if ln.starts_with('/*') { in_comment = true }
            if ln.ends_with('*/') { in_comment = false }
            out_file.writeln(ln)
        }

        // parse functions
        if ln.starts_with('fn') {
            name, ret_type, args := parse_function(ln)
            has_return := ret_type.len > 0
            ret_w_space := if has_return { ' ' + ret_type } else { '' }

            out_file.writeln('[inline]')
            out_file.write('pub fn ${name}(')
            print_args(mut out_file, args, true)
            out_file.write(')$ret_w_space')
            out_file.write(' {\n')

            if has_return { out_file.write('\treturn ') } else { out_file.write('\t') }
            out_file.write('C.${name}(')
            print_args(mut out_file, args, false)
            out_file.write(')\n')

            out_file.writeln('}')
            out_file.writeln('')
        }
    }
}

fn print_args(out_file mut os.File, args []Arg, is_def bool) {
    for i, arg in args {
        out_file.write('${arg.name')

        // if our parameter is an array, we need to pass the arr.data to it
        if !is_def && arg.@type.contains('[') { out_file.write('.data') }

        // if this is the function definition it needs the type
        if is_def { out_file.write(' ${arg.@type}') }

        // add a comma for all but the last param
        if i < args.len - 1 { out_file.write(', ') }
    }
}

fn parse_function(line string) (string, string, []Arg) {
    mut args := []Arg

    paren_index := line.index('(') or { panic(err) }
    last_paren_index := line.index(')') or { panic(err) }
    name := line[5..paren_index]

    mut ret_type := line[last_paren_index + 1..].trim_space()
    // check for and rip out comments
    if ret_type.contains('//') {
        if ind := ret_type.index('//') {
            ret_type = ret_type[..ind].trim_space()
            ret_type = ''
        }
    }

    arg_str := line[paren_index + 1..last_paren_index]
    for a in arg_str.split(',') {
        arg_parts := a.trim_space().split(' ')
        args << Arg{arg_parts[0], arg_parts[1]}
    }

    return name, ret_type, args
}