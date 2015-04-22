#version 330
in vec2 uv0;
// in vec3 world;
out vec4 fragColor;

uniform sampler2D tex0;
uniform float anim;
uniform float offset;
uniform int mode;

void main() {
    vec2 p = uv0 * 2.0 - 1.0;
    float d = length(p);

#if 0
        // float foobar = float(int(texture( tex0, vec2(0.5, uv0.t) ).b * 30.0)) / 30.0 * 0.5;
        vec4 foobar = texture( tex0, vec2(0.5, float( int(uv0.t*30.0) ) / 30.0 )) * 0.2;
        // p.s += foobar;
        // p.s = foobar.r;
        p.s += foobar.r;
#endif

    // vec2 roff = (p) * vec2(d*0.01);
    // vec2 goff = (p) * vec2(d*0.02);
    // vec2 boff = (p) * vec2(d*0.03);
    // vec2 roff = vec2(p*0.01);
    // vec2 goff = vec2(p*0.02);
    // vec2 boff = vec2(p*0.03);

#if 0
    vec2 roff = vec2(p.s*0.01, 0.0);
    vec2 goff = vec2(p.s*0.02, 0.0);
    vec2 boff = vec2(p.s*0.03, 0.0);

    vec4 rval = texture( tex0, uv0 + roff );
    vec4 gval = texture( tex0, uv0 + goff );
    vec4 bval = texture( tex0, uv0 + boff );

    fragColor = vec4( rval.r, gval.g, bval.b, 1.0 );
#else
    fragColor = texture( tex0, uv0 );
#endif
    // fragColor = vec4( p, 0.0 , 1.0 );

    // if (world.y < 0)
    // vec2 uv_fix = uv0;
    // uv_fix.s += sin(uv0.t*30.0) * 0.01;
    // fragColor = texture( tex0, uv_fix );
    // fragColor = vec4(uv0, 1.0, 1.0);
    // else
        // fragColor = vec4(d);
}
