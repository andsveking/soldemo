#version 330
in vec2 uv0;
in vec3 org;
out vec4 fragColor;

uniform sampler2D tex0;
uniform float anim;
uniform float offset;
uniform int mode;

void main() {
	vec3 a = vec3(253.0f / 256.0f, 144.0f / 256.0f, 23.0f / 256.0f);
	vec3 b = vec3(22.0f / 256.0f, 130.0f / 256.0f, 225.0f / 256.0f);
	vec3 tot = a * uv0.x + b * uv0.y;
	fragColor = vec4(tot,1) + org.x * vec4(0.02) + org.y * vec4(0.02);
	fragColor.w = 1;
}

