#version 330
in vec2 uv0;
in vec3 world;
in vec3 normal;
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
	vec4 mat;
	if ((int(floor(uv0.x*64) + floor(uv0.y*64)) & 1) == 0)
		mat = vec4(0.0, 0.1, 0.2, 1.0);
	else
		mat = vec4(0.0, 0.3, 0.4, 1.0);

//	float atten = 500 / (10 + world.x * world.x + world.y * world.y);
//	mat = atten * mat;

	float spec = pow(dot(normal, vec3(-0.4,0,-.4)), 4);

	fragColor = mat + vec4(1,1,1,1) * spec;

//	fragColor = vec4(1,1,1,1) * dot(normal, vec3(0,1,0)); //mat * texture(tex0, uv0).rrrr;
}
