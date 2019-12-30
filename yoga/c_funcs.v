module yoga

fn C.YGNodeNew() C.YGNodeRef
fn C.YGNodeNewWithConfig(config C.YGConfigRef) C.YGNodeRef
fn C.YGNodeClone(node C.YGNodeRef) C.YGNodeRef
fn C.YGNodeFree(node C.YGNodeRef)
fn C.YGNodeFreeRecursiveWithCleanupFunc(node C.YGNodeRef, cleanup fn(node YGNodeRef))
fn C.YGNodeFreeRecursive(node C.YGNodeRef)
fn C.YGNodeReset(node C.YGNodeRef)
fn C.YGNodeInsertChild(node C.YGNodeRef, child C.YGNodeRef, index u32)
fn C.YGNodeRemoveChild(node C.YGNodeRef, child C.YGNodeRef)
fn C.YGNodeRemoveAllChildren(node C.YGNodeRef)
fn C.YGNodeGetChild(node C.YGNodeRef, index u32) C.YGNodeRef
fn C.YGNodeGetOwner(node C.YGNodeRef) C.YGNodeRef
fn C.YGNodeGetParent(node C.YGNodeRef) C.YGNodeRef
fn C.YGNodeGetChildCount(node C.YGNodeRef) u32
fn C.YGNodeSetChildren(owner C.YGNodeRef, children []C.YGNodeRef, count u32)
fn C.YGNodeSetIsReferenceBaseline(node C.YGNodeRef, isReferenceBaseline bool)
fn C.YGNodeIsReferenceBaseline(node C.YGNodeRef) bool
fn C.YGNodeCalculateLayout(node C.YGNodeRef, availableWidth f32, availableHeight f32, ownerDirection YGDirection)
fn C.YGNodeMarkDirty(node C.YGNodeRef)
fn C.YGNodeMarkDirtyAndPropogateToDescendants(node C.YGNodeRef)
fn C.YGNodePrint(node C.YGNodeRef, options YGPrintOptions)
fn C.YGFloatIsUndefined(value f32) bool
fn C.YGNodeCanUseCachedMeasurement(widthMode YGMeasureMode, width f32, heightMode YGMeasureMode, height f32, lastWidthMode YGMeasureMode, lastWidth f32, lastHeightMode YGMeasureMode, lastHeight f32, lastComputedWidth f32, lastComputedHeight f32, marginRow f32, marginColumn f32, config C.YGConfigRef) bool
fn C.YGNodeCopyStyle(dstNode C.YGNodeRef, srcNode C.YGNodeRef)
fn C.YGNodeGetContext(node C.YGNodeRef) voidptr
fn C.YGNodeSetContext(node C.YGNodeRef, context voidptr)
fn C.YGNodeSetMeasureFunc(node C.YGNodeRef, measureFunc voidptr)
fn C.YGNodeGetHasNewLayout(node C.YGNodeRef) bool
fn C.YGNodeSetHasNewLayout(node C.YGNodeRef, hasNewLayout bool)
fn C.YGNodeIsDirty(node C.YGNodeRef) bool
fn C.YGNodeStyleSetDirection(node C.YGNodeRef, direction YGDirection)
fn C.YGNodeStyleGetDirection(node C.YGNodeConstRef) YGDirection
fn C.YGNodeStyleSetFlexDirection(node C.YGNodeRef, flexDirection YGFlexDirection)
fn C.YGNodeStyleGetFlexDirection(node C.YGNodeConstRef) YGFlexDirection
fn C.YGNodeStyleSetJustifyContent(node C.YGNodeRef, justifyContent YGJustify)
fn C.YGNodeStyleGetJustifyContent(node C.YGNodeConstRef) YGJustify
fn C.YGNodeStyleSetAlignContent(node C.YGNodeRef, alignContent YGAlign)
fn C.YGNodeStyleGetAlignContent(node C.YGNodeConstRef) YGAlign
fn C.YGNodeStyleSetAlignItems(node C.YGNodeRef, alignItems YGAlign)
fn C.YGNodeStyleGetAlignItems(node C.YGNodeConstRef) YGAlign
fn C.YGNodeStyleSetAlignSelf(node C.YGNodeRef, alignSelf YGAlign)
fn C.YGNodeStyleGetAlignSelf(node C.YGNodeConstRef) YGAlign
fn C.YGNodeStyleSetPositionType(node C.YGNodeRef, positionType YGPositionType)
fn C.YGNodeStyleGetPositionType(node C.YGNodeConstRef) YGPositionType
fn C.YGNodeStyleSetFlexWrap(node C.YGNodeRef, flexWrap YGWrap)
fn C.YGNodeStyleGetFlexWrap(node C.YGNodeConstRef) YGWrap
fn C.YGNodeStyleSetOverflow(node C.YGNodeRef, overflow YGOverflow)
fn C.YGNodeStyleGetOverflow(node C.YGNodeConstRef) YGOverflow
fn C.YGNodeStyleSetDisplay(node C.YGNodeRef, display YGDisplay)
fn C.YGNodeStyleGetDisplay(node C.YGNodeConstRef) YGDisplay
fn C.YGNodeStyleSetFlex(node C.YGNodeRef, flex f32)
fn C.YGNodeStyleGetFlex(node C.YGNodeConstRef) f32
fn C.YGNodeStyleSetFlexGrow(node C.YGNodeRef, flexGrow f32)
fn C.YGNodeStyleGetFlexGrow(node C.YGNodeConstRef) f32
fn C.YGNodeStyleSetFlexShrink(node C.YGNodeRef, flexShrink f32)
fn C.YGNodeStyleGetFlexShrink(node C.YGNodeConstRef) f32
fn C.YGNodeStyleSetFlexBasis(node C.YGNodeRef, flexBasis f32)
fn C.YGNodeStyleSetFlexBasisPercent(node C.YGNodeRef, flexBasis f32)
fn C.YGNodeStyleSetFlexBasisAuto(node C.YGNodeRef)
fn C.YGNodeStyleGetFlexBasis(node C.YGNodeConstRef) C.YGValue
fn C.YGNodeStyleSetPosition(node C.YGNodeRef, edge YGEdge, position f32)
fn C.YGNodeStyleSetPositionPercent(node C.YGNodeRef, edge YGEdge, position f32)
fn C.YGNodeStyleGetPosition(node C.YGNodeConstRef, edge YGEdge) C.YGValue
fn C.YGNodeStyleSetMargin(node C.YGNodeRef, edge YGEdge, margin f32)
fn C.YGNodeStyleSetMarginPercent(node C.YGNodeRef, edge YGEdge, margin f32)
fn C.YGNodeStyleSetMarginAuto(node C.YGNodeRef, edge YGEdge)
fn C.YGNodeStyleGetMargin(node C.YGNodeConstRef, edge YGEdge) C.YGValue
fn C.YGNodeStyleSetPadding(node C.YGNodeRef, edge YGEdge, padding f32)
fn C.YGNodeStyleSetPaddingPercent(node C.YGNodeRef, edge YGEdge, padding f32)
fn C.YGNodeStyleGetPadding(node C.YGNodeConstRef, edge YGEdge) C.YGValue
fn C.YGNodeStyleSetBorder(node C.YGNodeRef, edge YGEdge, border f32)
fn C.YGNodeStyleGetBorder(node C.YGNodeConstRef, edge YGEdge) f32
fn C.YGNodeStyleSetWidth(node C.YGNodeRef, width f32)
fn C.YGNodeStyleSetWidthPercent(node C.YGNodeRef, width f32)
fn C.YGNodeStyleSetWidthAuto(node C.YGNodeRef)
fn C.YGNodeStyleGetWidth(node C.YGNodeConstRef) C.YGValue
fn C.YGNodeStyleSetHeight(node C.YGNodeRef, height f32)
fn C.YGNodeStyleSetHeightPercent(node C.YGNodeRef, height f32)
fn C.YGNodeStyleSetHeightAuto(node C.YGNodeRef)
fn C.YGNodeStyleGetHeight(node C.YGNodeConstRef) C.YGValue
fn C.YGNodeStyleSetMinWidth(node C.YGNodeRef, minWidth f32)
fn C.YGNodeStyleSetMinWidthPercent(node C.YGNodeRef, minWidth f32)
fn C.YGNodeStyleGetMinWidth(node C.YGNodeConstRef) C.YGValue
fn C.YGNodeStyleSetMinHeight(node C.YGNodeRef, minHeight f32)
fn C.YGNodeStyleSetMinHeightPercent(node C.YGNodeRef, minHeight f32)
fn C.YGNodeStyleGetMinHeight(node C.YGNodeConstRef) C.YGValue
fn C.YGNodeStyleSetMaxWidth(node C.YGNodeRef, maxWidth f32)
fn C.YGNodeStyleSetMaxWidthPercent(node C.YGNodeRef, maxWidth f32)
fn C.YGNodeStyleGetMaxWidth(node C.YGNodeConstRef) C.YGValue
fn C.YGNodeStyleSetMaxHeight(node C.YGNodeRef, maxHeight f32)
fn C.YGNodeStyleSetMaxHeightPercent(node C.YGNodeRef, maxHeight f32)
fn C.YGNodeStyleGetMaxHeight(node C.YGNodeConstRef) C.YGValue
fn C.YGNodeStyleSetAspectRatio(node C.YGNodeRef, aspectRatio f32)
fn C.YGNodeStyleGetAspectRatio(node C.YGNodeConstRef) f32
fn C.YGNodeLayoutGetLeft(node C.YGNodeRef) f32
fn C.YGNodeLayoutGetTop(node C.YGNodeRef) f32
fn C.YGNodeLayoutGetRight(node C.YGNodeRef) f32
fn C.YGNodeLayoutGetBottom(node C.YGNodeRef) f32
fn C.YGNodeLayoutGetWidth(node C.YGNodeRef) f32
fn C.YGNodeLayoutGetHeight(node C.YGNodeRef) f32
fn C.YGNodeLayoutGetDirection(node C.YGNodeRef) YGDirection
fn C.YGNodeLayoutGetHadOverflow(node C.YGNodeRef) bool
fn C.YGNodeLayoutGetMargin(node C.YGNodeRef, edge YGEdge) f32
fn C.YGNodeLayoutGetBorder(node C.YGNodeRef, edge YGEdge) f32
fn C.YGNodeLayoutGetPadding(node C.YGNodeRef, edge YGEdge) f32
fn C.YGConfigSetLogger(config C.YGConfigRef, logger voidptr)
fn C.YGAssert(condition bool, message byteptr)
fn C.YGAssertWithNode(node C.YGNodeRef, condition bool, message byteptr)
fn C.YGAssertWithConfig(config C.YGConfigRef, condition bool, message byteptr)
fn C.YGConfigSetPointScaleFactor(config C.YGConfigRef, pixelsInPoint f32)
fn C.YGConfigSetUseLegacyStretchBehaviour(config C.YGConfigRef, useLegacyStretchBehaviour bool)
fn C.YGConfigNew() C.YGConfigRef
fn C.YGConfigFree(config C.YGConfigRef)
fn C.YGConfigCopy(dest C.YGConfigRef, src C.YGConfigRef)
fn C.YGConfigGetInstanceCount() int
fn C.YGConfigSetExperimentalFeatureEnabled(config C.YGConfigRef, feature YGExperimentalFeature, enabled bool)
fn C.YGConfigIsExperimentalFeatureEnabled(config C.YGConfigRef, feature YGExperimentalFeature) bool
fn C.YGConfigSetUseWebDefaults(config C.YGConfigRef, enabled bool)
fn C.YGConfigGetUseWebDefaults(config C.YGConfigRef) bool
fn C.YGConfigSetCloneNodeFunc(config C.YGConfigRef, callback fn(oldNode C.YGNodeRef, owner C.YGNodeRef, childIndex int))
fn C.YGConfigGetDefault() C.YGConfigRef
fn C.YGConfigSetContext(config C.YGConfigRef, context voidptr)
fn C.YGConfigGetContext(config C.YGConfigRef) voidptr
fn C.YGRoundValueToPixelGrid(value f32, pointScaleFactor f32, forceCeil bool, forceFloor bool) f32
