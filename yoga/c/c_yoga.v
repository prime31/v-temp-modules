module c

#flag -I @VMOD/prime31/yoga/thirdparty
#flag darwin @VMOD/prime31/yoga/thirdparty/libyogacore.a
#flag darwin -lc++

#flag linux @VMOD/prime31/yoga/thirdparty/libyogacore.a
#flag linux -lstdc++

#include "Yoga.h"

pub struct C.YGNodeRef {}

pub struct C.YGSize {
	width f32
	height f32
}

// typedef YGSize (*YGMeasureFunc)(YGNodeRef node, float width, YGMeasureMode widthMode, float height, YGMeasureMode heightMode);
// type C.YGMeasureFunc fn(node C.YGNodeRef, width f32, widthMode int, height f32, heightMode int) YGSize

fn C.YGNodeNew() YGNodeRef
fn C.YGNodeFreeRecursive(node YGNodeRef)
fn C.YGNodeStyleSetHeight(node YGNodeRef, height f32)
fn C.YGNodeSetMeasureFunc(node YGNodeRef, measureFunc voidptr /*YGMeasureFunc*/)
fn C.YGNodeInsertChild(node YGNodeRef, child YGNodeRef, index u32)
fn C.YGNodeCalculateLayout(node YGNodeRef, availableWidth f32, availableHeight f32, ownerDirection int)