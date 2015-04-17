#version 330
in vec2 uv0;
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
    /*if (mode == 0)
    {
        vec4 color = texture(tex0, uv0);
        vec2 apa = vec2(gl_FragCoord.xy / 320.0);
        apa.x += sin(anim*0.1);
        apa.y += cos(anim*0.1);
        // anim
        vec4 mixer = vec4( apa, vec2(1.0));
        fragColor = vec4(color.rgb * mixer.rgb, color.a);
    } else { //if (mode == 1)
        vec4 color = texture(tex0, uv0);
        vec3 apa = vec3(anim * 0.01);
        apa.r += abs(sin((6.0 - offset)*0.2));
        apa.g += abs(cos((6.0 - offset)*0.1));
        apa.b += abs(sin((6.0 - offset)*0.1+anim*0.01));
        apa = fract(apa);
        apa = max(apa, vec3(0.3));
        // vec4 mixer = vec4( hsv2rgb(apa), 1.0);
        vec4 mixer = vec4( apa, 1.0);
        // fragColor = color;
        fragColor = vec4(color.rgb * mixer.rgb, color.a * (offset / 6.0));
    }*/
    // fragColor = vec4(color.rgb * vec3(uv0, 1.0), color.a);
    fragColor = vec4(uv0, 1.0, 1.0);
}
