#version 330
in vec2 uv0;
in vec3 world;
out vec4 fragColor;

uniform sampler2D tex0;
uniform float anim;
uniform float offset;
uniform int mode;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec2 p = uv0 * 2.0 - 1.0;
    float d = 1.0 - length(p);

    if (world.y < 0)
	fragColor = vec4(0.04*d);
    else
    	fragColor = vec4(d);
}
