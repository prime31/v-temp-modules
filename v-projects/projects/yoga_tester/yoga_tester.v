import prime31.yoga.c

fn main() {
	root := YGNodeNew()
	println('alive. node: ${&root}')

	for i := 0; i < 10; i++ {
		child := YGNodeNew()
		YGNodeStyleSetHeight(child, 20)
		YGNodeSetMeasureFunc(child, measure)
		YGNodeInsertChild(root, child, 0)
	}

	YGNodeCalculateLayout(root, C.YGUndefined, C.YGUndefined, C.YGDirectionLTR)
    YGNodeFreeRecursive(root)
}

fn measure(node C.YGNodeRef, width f32, widthMode int, height f32, heightMode int) YGSize {
	println('node: ${&node}, w=$width, wMode=$widthMode, h=$height, hMode=$heightMode')
	return YGSize{
		width: if widthMode == C.YGMeasureModeUndefined { 10 } else { width }
		height: if heightMode == C.YGMeasureModeUndefined { 10 } else { width }
	}
}