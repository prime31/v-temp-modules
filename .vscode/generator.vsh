import filepath

fn C.isupper(argument int) int

struct Arg {
    name string
    @type string
}

fn main() {
    src := os.args[1]
    src_dir := filepath.dir(src)
    src_name := filepath.filename(src)
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
            out_file.write('pub fn ${to_snake_case(name)}(')
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
    last_paren_index := line.last_index(')') or { panic(err) }
    name := line[5..paren_index]

    mut ret_type := line[last_paren_index + 1..].trim_space()
    // check for and rip out comments
    if ret_type.contains('//') {
        if ind := ret_type.index('//') {
            ret_type = ret_type[..ind].trim_space()
            ret_type = ''
        }
    }

    mut arg_str := line[paren_index + 1..last_paren_index]
    // special parsing for parameters with callback functions
    if arg_str.contains('fn(') {
        for arg_str.len > 0 {
            mut index := 0
            // find the param name by finding the first space
            space_index := arg_str.index(' ') or { panic(err) }
            param_name := arg_str[index..space_index]
            index = space_index + 1

            // reset arg_str to remove the first param and the space
            arg_str = arg_str[index..]
            if arg_str.starts_with('fn(') {
                println('-----------')
                close_paren_index := arg_str.index(')') or { panic(err) }
                param_val := arg_str[..close_paren_index + 1]
                args << Arg{param_name, param_val}
                println('adding $param_name -> $param_val')
                arg_str = arg_str[close_paren_index + 2..].trim_space()
            } else {
                // last param will have no comma
                mut last_param := false
                comma_index := arg_str.index(',') or {
                    last_param = true
                    arg_str.len
                }
                param_val := arg_str[..comma_index]
                args << Arg{param_name, param_val}
                println('adding $param_name -> $param_val')

                if last_param { break }
                arg_str = arg_str[comma_index + 2..]
            }
            println('-- remaining arg_str: ${arg_str}')
        }
    } else {
        for a in arg_str.split(',') {
            arg_parts := a.trim_space().split_nth(' ', 0)
            args << Arg{arg_parts[0], arg_parts[1].trim_space()}
        }
    }

    return name, ret_type, args
}

fn to_snake_case(name string) string {
    mut snake_name := ''
    mut has_capital := false
    mut last_index := 0

    for i, c in name {
        if c >= `A` && c <= `Z` {
            has_capital = true

            len := snake_name.len
            snake_name += name[last_index..i]
            snake_name.str[len] = C.tolower(snake_name.str[len])
            snake_name += '_'
            last_index = i
        }
    }

    if has_capital {
        len := snake_name.len
        snake_name += name[last_index..]
        snake_name.str[len] = C.tolower(snake_name.str[len])
    }

    return if has_capital { snake_name } else { name }
}

fn sanitize_variable_name(name string) string {
    return name
}