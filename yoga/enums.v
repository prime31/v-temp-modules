module yoga

pub enum YGUnit {
	undefined
	point
	percent
	auto
}

pub enum YGDirection {
	inherit
	ltr
	rtl
}

pub enum YGPrintOptions {
	layout = 1
    style = 2
    children = 4
}

pub enum YGMeasureMode {
	undefined
	exactly
	at_most
}

pub enum YGFlexDirection {
	column
	column_reverse
	row
	row_reverse
}

pub enum YGJustify {
	flex_start
	center
	flex_end
	space_between
	space_around
	space_evenly
}

pub enum YGLogLevel {
	error
	warn
	info
	debug
	verbose
	fatal
}

pub enum YGOverflow {
	visible
	hidden
	scroll
}

pub enum YGPositionType {
	relative
	absolute
}

pub enum YGWrap {
	no_wrap
	wrap
	wrap_reverse
}

pub enum YGAlign {
	auto
	flex_start
	center
	flex_end
	stretch
	baseline
	space_between
	space_around
}

pub enum YGDisplay {
	flex
	@none
}

pub enum YGEdge {
	left
	top
	right
	bottom
	start
	end
	horizontal
	vertical
	all
}

pub enum YGExperimentalFeature {
	web_flex_basis
}