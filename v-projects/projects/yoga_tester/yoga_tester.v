import prime31.yoga

fn main() {
	root := YGNodeNew()
	println('alive. node: ${&root}')

	for i := 0; i < 10; i++ {
		child := yoga.node_new()
		child.style_set_height(20)
		child.set_measure_func(measure)
		root.insert_child(child, 0)
	}

	root.calculate_layout(C.YGUndefined, C.YGUndefined, .ltr)
    root.free_recursive()
}

fn measure(node C.YGNodeRef, width f32, width_mode yoga.YGMeasureMode, height f32, height_mode yoga.YGMeasureMode) C.YGSize {
	println('node: ${&node}, w=$width, wMode=$width_mode, h=$height, hMode=$height_mode')
	return YGSize{
		width: if width_mode == .undefined { 10 } else { width }
		height: if height_mode == .undefined { 10 } else { width }
	}
}