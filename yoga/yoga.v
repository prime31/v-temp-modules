module yoga

pub struct C.YGNodeRef {}

pub fn node_new() C.YGNodeRef {
	return C.YGNodeNew()
}

pub fn node_new_with_config(config C.YGConfigRef) C.YGNodeRef {
	return C.YGNodeNewWithConfig(config)
}

pub fn (n C.YGNodeRef) clone() C.YGNodeRef {
	return C.YGNodeClone(n)
}

pub fn (n C.YGNodeRef) free() {
	C.YGNodeFree(n)
}

pub fn (n C.YGNodeRef) free_recursive_with_cleanup_func(cleanup fn(node YGNodeRef)) {
	C.YGNodeFreeRecursiveWithCleanupFunc(n, cleanup)
}

pub fn (n C.YGNodeRef) free_recursive() {
	C.YGNodeFreeRecursive(n)
}

pub fn (n C.YGNodeRef) reset() {
	C.YGNodeReset(n)
}

pub fn (n C.YGNodeRef) insert_child(child C.YGNodeRef, index u32) {
	C.YGNodeInsertChild(n, child, index)
}

pub fn (n C.YGNodeRef) remove_child(child C.YGNodeRef) {
	C.YGNodeRemoveChild(n, child)
}

pub fn (n C.YGNodeRef) remove_all_children() {
	C.YGNodeRemoveAllChildren(n)
}

pub fn (n C.YGNodeRef) get_child(index u32) C.YGNodeRef {
	return C.YGNodeGetChild(n, index)
}

pub fn (n C.YGNodeRef) get_owner() C.YGNodeRef {
	return C.YGNodeGetOwner(n)
}

pub fn (n C.YGNodeRef) get_parent() C.YGNodeRef {
	return C.YGNodeGetParent(n)
}

pub fn (n C.YGNodeRef) get_child_count() u32 {
	return C.YGNodeGetChildCount(n)
}

pub fn (n C.YGNodeRef) set_children(children []C.YGNodeRef, count u32) {
	C.YGNodeSetChildren(n, children.data, count)
}

pub fn (n C.YGNodeRef) set_is_reference_baseline(is_reference_baseline bool) {
	C.YGNodeSetIsReferenceBaseline(n, is_reference_baseline)
}

pub fn (n C.YGNodeRef) is_reference_baseline() bool {
	return C.YGNodeIsReferenceBaseline(n)
}

pub fn (n C.YGNodeRef) calculate_layout(available_width f32, available_height f32, owner_direction YGDirection) {
	C.YGNodeCalculateLayout(n, available_width, available_height, owner_direction)
}

pub fn (n C.YGNodeRef) mark_dirty() {
	C.YGNodeMarkDirty(n)
}

pub fn (n C.YGNodeRef) mark_dirty_and_propogate_to_descendants() {
	C.YGNodeMarkDirtyAndPropogateToDescendants(n)
}

pub fn (n C.YGNodeRef) print(options YGPrintOptions) {
	println('YGNodePrint doesnt compile for some reason...')
//	C.YGNodePrint(n, options)
}

pub fn float_is_undefined(value f32) bool {
	return C.YGFloatIsUndefined(value)
}

pub fn node_can_use_cached_measurement(width_mode YGMeasureMode, width f32, height_mode YGMeasureMode, height f32, last_width_mode YGMeasureMode, last_width f32, last_height_mode YGMeasureMode, last_height f32, last_computed_width f32, last_computed_height f32, margin_row f32, margin_column f32, config C.YGConfigRef) bool {
	return C.YGNodeCanUseCachedMeasurement(width_mode, width, height_mode, height, last_width_mode, last_width, last_height_mode, last_height, last_computed_width, last_computed_height, margin_row, margin_column, config)
}

pub fn (n C.YGNodeRef) copy_style(src_node C.YGNodeRef) {
	C.YGNodeCopyStyle(n, src_node)
}

pub fn (n C.YGNodeRef) get_context() voidptr {
	return C.YGNodeGetContext(n)
}

pub fn (n C.YGNodeRef) set_context(context voidptr) {
	C.YGNodeSetContext(n, context)
}

pub fn (n C.YGNodeRef) set_measure_func(measure_func voidptr) {
	C.YGNodeSetMeasureFunc(n, measure_func)
}

pub fn (n C.YGNodeRef) get_has_new_layout() bool {
	return C.YGNodeGetHasNewLayout(n)
}

pub fn (n C.YGNodeRef) set_has_new_layout(has_new_layout bool) {
	C.YGNodeSetHasNewLayout(n, has_new_layout)
}

pub fn (n C.YGNodeRef) is_dirty() bool {
	return C.YGNodeIsDirty(n)
}

pub fn (n C.YGNodeRef) style_set_direction(direction YGDirection) {
	C.YGNodeStyleSetDirection(n, direction)
}

pub fn (n C.YGNodeRef) style_get_direction() YGDirection {
	return C.YGNodeStyleGetDirection(n)
}

pub fn (n C.YGNodeRef) style_set_flex_direction(flex_direction YGFlexDirection) {
	C.YGNodeStyleSetFlexDirection(n, flex_direction)
}

pub fn (n C.YGNodeRef) style_get_flex_direction() YGFlexDirection {
	return C.YGNodeStyleGetFlexDirection(n)
}

pub fn (n C.YGNodeRef) style_set_justify_content(justify_content YGJustify) {
	C.YGNodeStyleSetJustifyContent(n, justify_content)
}

pub fn (n C.YGNodeRef) style_get_justify_content() YGJustify {
	return C.YGNodeStyleGetJustifyContent(n)
}

pub fn (n C.YGNodeRef) style_set_align_content(align_content YGAlign) {
	C.YGNodeStyleSetAlignContent(n, align_content)
}

pub fn (n C.YGNodeRef) style_get_align_content() YGAlign {
	return C.YGNodeStyleGetAlignContent(n)
}

pub fn (n C.YGNodeRef) style_set_align_items(align_items YGAlign) {
	C.YGNodeStyleSetAlignItems(n, align_items)
}

pub fn (n C.YGNodeRef) style_get_align_items() YGAlign {
	return C.YGNodeStyleGetAlignItems(n)
}

pub fn (n C.YGNodeRef) style_set_align_self(align_self YGAlign) {
	C.YGNodeStyleSetAlignSelf(n, align_self)
}

pub fn (n C.YGNodeRef) style_get_align_self() YGAlign {
	return C.YGNodeStyleGetAlignSelf(n)
}

pub fn (n C.YGNodeRef) style_set_position_type(position_type YGPositionType) {
	C.YGNodeStyleSetPositionType(n, position_type)
}

pub fn (n C.YGNodeRef) style_get_position_type() YGPositionType {
	return C.YGNodeStyleGetPositionType(n)
}

pub fn (n C.YGNodeRef) style_set_flex_wrap(flex_wrap YGWrap) {
	C.YGNodeStyleSetFlexWrap(n, flex_wrap)
}

pub fn (n C.YGNodeRef) style_get_flex_wrap() YGWrap {
	return C.YGNodeStyleGetFlexWrap(n)
}

pub fn (n C.YGNodeRef) style_set_overflow(overflow YGOverflow) {
	C.YGNodeStyleSetOverflow(n, overflow)
}

pub fn (n C.YGNodeRef) style_get_overflow() YGOverflow {
	return C.YGNodeStyleGetOverflow(n)
}

pub fn (n C.YGNodeRef) style_set_display(display YGDisplay) {
	C.YGNodeStyleSetDisplay(n, display)
}

pub fn (n C.YGNodeRef) style_get_display() YGDisplay {
	return C.YGNodeStyleGetDisplay(n)
}

pub fn (n C.YGNodeRef) style_set_flex(flex f32) {
	C.YGNodeStyleSetFlex(n, flex)
}

pub fn (n C.YGNodeRef) style_get_flex() f32 {
	return C.YGNodeStyleGetFlex(n)
}

pub fn (n C.YGNodeRef) style_set_flex_grow(flex_grow f32) {
	C.YGNodeStyleSetFlexGrow(n, flex_grow)
}

pub fn (n C.YGNodeRef) style_get_flex_grow() f32 {
	return C.YGNodeStyleGetFlexGrow(n)
}

pub fn (n C.YGNodeRef) style_set_flex_shrink(flex_shrink f32) {
	C.YGNodeStyleSetFlexShrink(n, flex_shrink)
}

pub fn (n C.YGNodeRef) style_get_flex_shrink() f32 {
	return C.YGNodeStyleGetFlexShrink(n)
}

pub fn (n C.YGNodeRef) style_set_flex_basis(flex_basis f32) {
	C.YGNodeStyleSetFlexBasis(n, flex_basis)
}

pub fn (n C.YGNodeRef) style_set_flex_basis_percent(flex_basis f32) {
	C.YGNodeStyleSetFlexBasisPercent(n, flex_basis)
}

pub fn (n C.YGNodeRef) style_set_flex_basis_auto() {
	C.YGNodeStyleSetFlexBasisAuto(n)
}

pub fn (n C.YGNodeRef) style_get_flex_basis() C.YGValue {
	return C.YGNodeStyleGetFlexBasis(n)
}

pub fn (n C.YGNodeRef) style_set_position(edge YGEdge, position f32) {
	C.YGNodeStyleSetPosition(n, edge, position)
}

pub fn (n C.YGNodeRef) style_set_position_percent(edge YGEdge, position f32) {
	C.YGNodeStyleSetPositionPercent(n, edge, position)
}

pub fn (n C.YGNodeRef) style_get_position(edge YGEdge) C.YGValue {
	return C.YGNodeStyleGetPosition(n, edge)
}

pub fn (n C.YGNodeRef) style_set_margin(edge YGEdge, margin f32) {
	C.YGNodeStyleSetMargin(n, edge, margin)
}

pub fn (n C.YGNodeRef) style_set_margin_percent(edge YGEdge, margin f32) {
	C.YGNodeStyleSetMarginPercent(n, edge, margin)
}

pub fn (n C.YGNodeRef) style_set_margin_auto(edge YGEdge) {
	C.YGNodeStyleSetMarginAuto(n, edge)
}

pub fn (n C.YGNodeRef) style_get_margin(edge YGEdge) C.YGValue {
	return C.YGNodeStyleGetMargin(n, edge)
}

pub fn (n C.YGNodeRef) style_set_padding(edge YGEdge, padding f32) {
	C.YGNodeStyleSetPadding(n, edge, padding)
}

pub fn (n C.YGNodeRef) style_set_padding_percent(edge YGEdge, padding f32) {
	C.YGNodeStyleSetPaddingPercent(n, edge, padding)
}

pub fn (n C.YGNodeRef) style_get_padding(edge YGEdge) C.YGValue {
	return C.YGNodeStyleGetPadding(n, edge)
}

pub fn (n C.YGNodeRef) style_set_border(edge YGEdge, border f32) {
	C.YGNodeStyleSetBorder(n, edge, border)
}

pub fn (n C.YGNodeRef) style_get_border(edge YGEdge) f32 {
	return C.YGNodeStyleGetBorder(n, edge)
}

pub fn (n C.YGNodeRef) style_set_width(width f32) {
	C.YGNodeStyleSetWidth(n, width)
}

pub fn (n C.YGNodeRef) style_set_width_percent(width f32) {
	C.YGNodeStyleSetWidthPercent(n, width)
}

pub fn (n C.YGNodeRef) style_set_width_auto() {
	C.YGNodeStyleSetWidthAuto(n)
}

pub fn (n C.YGNodeRef) style_get_width() C.YGValue {
	return C.YGNodeStyleGetWidth(n)
}

pub fn (n C.YGNodeRef) style_set_height(height f32) {
	C.YGNodeStyleSetHeight(n, height)
}

pub fn (n C.YGNodeRef) style_set_height_percent(height f32) {
	C.YGNodeStyleSetHeightPercent(n, height)
}

pub fn (n C.YGNodeRef) style_set_height_auto() {
	C.YGNodeStyleSetHeightAuto(n)
}

pub fn (n C.YGNodeRef) style_get_height() C.YGValue {
	return C.YGNodeStyleGetHeight(n)
}

pub fn (n C.YGNodeRef) style_set_min_width(min_width f32) {
	C.YGNodeStyleSetMinWidth(n, min_width)
}

pub fn (n C.YGNodeRef) style_set_min_width_percent(min_width f32) {
	C.YGNodeStyleSetMinWidthPercent(n, min_width)
}

pub fn (n C.YGNodeRef) style_get_min_width() C.YGValue {
	return C.YGNodeStyleGetMinWidth(n)
}

pub fn (n C.YGNodeRef) style_set_min_height(min_height f32) {
	C.YGNodeStyleSetMinHeight(n, min_height)
}

pub fn (n C.YGNodeRef) style_set_min_height_percent(min_height f32) {
	C.YGNodeStyleSetMinHeightPercent(n, min_height)
}

pub fn (n C.YGNodeRef) style_get_min_height() C.YGValue {
	return C.YGNodeStyleGetMinHeight(n)
}

pub fn (n C.YGNodeRef) style_set_max_width(max_width f32) {
	C.YGNodeStyleSetMaxWidth(n, max_width)
}

pub fn (n C.YGNodeRef) style_set_max_width_percent(max_width f32) {
	C.YGNodeStyleSetMaxWidthPercent(n, max_width)
}

pub fn (n C.YGNodeRef) style_get_max_width() C.YGValue {
	return C.YGNodeStyleGetMaxWidth(n)
}

pub fn (n C.YGNodeRef) style_set_max_height(max_height f32) {
	C.YGNodeStyleSetMaxHeight(n, max_height)
}

pub fn (n C.YGNodeRef) style_set_max_height_percent(max_height f32) {
	C.YGNodeStyleSetMaxHeightPercent(n, max_height)
}

pub fn (n C.YGNodeRef) style_get_max_height() C.YGValue {
	return C.YGNodeStyleGetMaxHeight(n)
}

pub fn (n C.YGNodeRef) style_set_aspect_ratio(aspect_ratio f32) {
	C.YGNodeStyleSetAspectRatio(n, aspect_ratio)
}

pub fn (n C.YGNodeRef) style_get_aspect_ratio() f32 {
	return C.YGNodeStyleGetAspectRatio(n)
}

pub fn (n C.YGNodeRef) layout_get_left() f32 {
	return C.YGNodeLayoutGetLeft(n)
}

pub fn (n C.YGNodeRef) layout_get_top() f32 {
	return C.YGNodeLayoutGetTop(n)
}

pub fn (n C.YGNodeRef) layout_get_right() f32 {
	return C.YGNodeLayoutGetRight(n)
}

pub fn (n C.YGNodeRef) layout_get_bottom() f32 {
	return C.YGNodeLayoutGetBottom(n)
}

pub fn (n C.YGNodeRef) layout_get_width() f32 {
	return C.YGNodeLayoutGetWidth(n)
}

pub fn (n C.YGNodeRef) layout_get_height() f32 {
	return C.YGNodeLayoutGetHeight(n)
}

pub fn (n C.YGNodeRef) layout_get_direction() YGDirection {
	return C.YGNodeLayoutGetDirection(n)
}

pub fn (n C.YGNodeRef) layout_get_had_overflow() bool {
	return C.YGNodeLayoutGetHadOverflow(n)
}

pub fn (n C.YGNodeRef) layout_get_margin(edge YGEdge) f32 {
	return C.YGNodeLayoutGetMargin(n, edge)
}

pub fn (n C.YGNodeRef) layout_get_border(edge YGEdge) f32 {
	return C.YGNodeLayoutGetBorder(n, edge)
}

pub fn (n C.YGNodeRef) layout_get_padding(edge YGEdge) f32 {
	return C.YGNodeLayoutGetPadding(n, edge)
}

pub fn config_set_logger(config C.YGConfigRef, logger voidptr) {
	C.YGConfigSetLogger(config, logger)
}

pub fn yg_assert(condition bool, message byteptr) {
	C.YGAssert(condition, message)
}

pub fn assert_with_node(node C.YGNodeRef, condition bool, message byteptr) {
	C.YGAssertWithNode(node, condition, message)
}

pub fn assert_with_config(config C.YGConfigRef, condition bool, message byteptr) {
	C.YGAssertWithConfig(config, condition, message)
}

pub fn config_set_point_scale_factor(config C.YGConfigRef, pixels_in_point f32) {
	C.YGConfigSetPointScaleFactor(config, pixels_in_point)
}

pub fn config_set_use_legacy_stretch_behaviour(config C.YGConfigRef, use_legacy_stretch_behaviour bool) {
	C.YGConfigSetUseLegacyStretchBehaviour(config, use_legacy_stretch_behaviour)
}

pub fn config_new() C.YGConfigRef {
	return C.YGConfigNew()
}

pub fn config_free(config C.YGConfigRef) {
	C.YGConfigFree(config)
}

pub fn config_copy(dest C.YGConfigRef, src C.YGConfigRef) {
	C.YGConfigCopy(dest, src)
}

pub fn config_get_instance_count() int {
	return C.YGConfigGetInstanceCount()
}

pub fn config_set_experimental_feature_enabled(config C.YGConfigRef, feature YGExperimentalFeature, enabled bool) {
	C.YGConfigSetExperimentalFeatureEnabled(config, feature, enabled)
}

pub fn config_is_experimental_feature_enabled(config C.YGConfigRef, feature YGExperimentalFeature) bool {
	return C.YGConfigIsExperimentalFeatureEnabled(config, feature)
}

pub fn config_set_use_web_defaults(config C.YGConfigRef, enabled bool) {
	C.YGConfigSetUseWebDefaults(config, enabled)
}

pub fn config_get_use_web_defaults(config C.YGConfigRef) bool {
	return C.YGConfigGetUseWebDefaults(config)
}

pub fn config_set_clone_node_func(config C.YGConfigRef, callback fn(oldNode C.YGNodeRef, owner C.YGNodeRef, childIndex int)) {
	C.YGConfigSetCloneNodeFunc(config, callback)
}

pub fn config_get_default() C.YGConfigRef {
	return C.YGConfigGetDefault()
}

pub fn config_set_context(config C.YGConfigRef, context voidptr) {
	C.YGConfigSetContext(config, context)
}

pub fn config_get_context(config C.YGConfigRef) voidptr {
	return C.YGConfigGetContext(config)
}

pub fn round_value_to_pixel_grid(value f32, point_scale_factor f32, force_ceil bool, force_floor bool) f32 {
	return C.YGRoundValueToPixelGrid(value, point_scale_factor, force_ceil, force_floor)
}

