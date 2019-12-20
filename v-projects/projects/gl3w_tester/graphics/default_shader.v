module graphics

const (
	shader_syntax = '#if defined(GL_FRAGMENT_PRECISION_HIGH)
	#define HIGHP_OR_MEDIUMP highp
#else
	#define HIGHP_OR_MEDIUMP mediump
#endif

#ifdef GL_EXT_texture_array
	#extension GL_EXT_texture_array : enable
#endif
#ifdef GL_OES_standard_derivatives
	#extension GL_OES_standard_derivatives : enable
#endif'

	vert_main = 'uniform HIGHP_OR_MEDIUMP mat4 TransformProjectionMatrix;
uniform HIGHP_OR_MEDIUMP vec4 via_ScreenSize;

layout (location = 0) in vec2 VertPosition;
layout (location = 1) in vec2 VertTexCoord;
layout (location = 2) in vec4 VertColor;
layout (location = 3) in vec4 ConstantColor;

out vec2 VaryingTexCoord;
out vec4 VaryingColor;

vec4 position(mat4 TransformProjectionMatrix, vec4 localPosition);

void main() {
	VaryingTexCoord = VertTexCoord;
	VaryingColor = VertColor * ConstantColor;
	gl_Position = position(TransformProjectionMatrix, vec4(VertPosition, 0, 1));
}'
	vert_default = 'vec4 position(mat4 transformProjectionMatrix, vec4 localPosition) {
	return transformProjectionMatrix * localPosition;
}'

	frag_main = 'layout(location = 0) out vec4 via_PixelColor;

#define via_PixelCoord (vec2(gl_FragCoord.x, (gl_FragCoord.y * via_ScreenSize.z) + via_ScreenSize.w))

uniform HIGHP_OR_MEDIUMP mat4 TransformProjectionMatrix;
uniform HIGHP_OR_MEDIUMP vec4 via_ScreenSize;
uniform sampler2D MainTex;

out HIGHP_OR_MEDIUMP vec2 VaryingTexCoord;
out mediump vec4 VaryingColor;

vec4 effect(vec4 vcolor, sampler2D tex, vec2 texcoord);

void main() {
	via_PixelColor = effect(VaryingColor, MainTex, VaryingTexCoord.st);
}'
	frag_default = 'vec4 effect(vec4 vcolor, sampler2D tex, vec2 texcoord) {
	return texture(tex, texcoord) * vcolor;
}'
)