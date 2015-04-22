#version 330
in vec2 uv0;
in vec3 world;
in vec3 normal;
out vec4 fragColor;

uniform sampler2D tex0;
uniform float waterFade;
uniform float waterTime;
uniform float logoFade;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
	vec4 mat, stdmat;

	vec3 campos = vec3(0,50,100);
	vec3 incoming = normalize(world - campos);
	vec3 fake = normalize(incoming - 0.05f * (normal - vec3(0,1,0)));

	float tobottom = world.y + 40;
	float length = -tobottom / fake.y;
	vec3 target = campos + length * fake;

	if ((int(floor(target.x/12) + floor((target.z - 20.0*waterTime)/12)) & 1) == 0)
	{
		stdmat = vec4(0.2,0.2,0.2,1);
		mat = vec4(0.0, 0.1, 0.2, 1.0);
	}
	else
	{
		stdmat = vec4(0.1,0.1,0.1,1);
		mat = vec4(0.0, 0.3, 0.4, 1.0);
	}


	float atten = 25000 / (1000 + world.x * world.x + world.z * world.z);
	mat = atten * mat;
	stdmat = atten * stdmat;

	float spec = pow(dot(normal, vec3(0,0,1)), 5);
	fragColor = mix(stdmat, mat + vec4(1,1,1,1) * spec * 1, waterFade) * vec4(1-logoFade) * vec4(1-logoFade);
}
