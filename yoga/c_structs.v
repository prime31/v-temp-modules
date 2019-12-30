module yoga

pub struct C.YGNodeConstRef {}

pub struct C.YGConfigRef {}

pub struct C.YGSize {
	width f32
	height f32
}

pub struct C.YGValue {
	value f32
	unit YGUnit
}

// cant typedef a function yet...
// typedef int (*YGLogger)(YGConfigRef config, YGNodeRef node, YGLogLevel level, const char* format, va_list args);
// type YGLogger fn(config C.YGConfigRef, node C.YGNodeRef, level YGLogLevel, format byteptr, a...voidptr) int

// typedef YGSize (*YGMeasureFunc)(YGNodeRef node, float width, YGMeasureMode widthMode, float height, YGMeasureMode heightMode);
// type YGMeasureFunc fn(node C.YGNodeRef, width f32, widthMode YGMeasureMode, height f32, heightMode YGMeasureMode) C.YGSize

// typedef void (*YGNodeCleanupFunc)(YGNodeRef node);
// type YGNodeCleanupFunc fn(node YGNodeRef)

// typedef YGNodeRef (*YGCloneNodeFunc)(YGNodeRef oldNode, YGNodeRef owner, int childIndex);
// type YGCloneNodeFunc fn(oldNode C.YGNodeRef, owner C.YGNodeRef, childIndex int)
