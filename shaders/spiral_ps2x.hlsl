/* 
Not exactly what I wanted but works
Credits: https://www.shadertoy.com/view/33VGzW
and ChatGPT
*/

sampler2D BASETEXTURE : register(s0);
float4 C0 : register(c0); // C0.x = time

struct PS_INPUT {
    float2 uv : TEXCOORD0;
};

float4 main(PS_INPUT IN) : COLOR {
    float2 uv = IN.uv * 2.0 - 1.0; // center coords
    float time = C0.x;

    // Simpler spiral approximation
    float angle = atan2(uv.y, uv.x);
    float radius = length(uv);

    // Time-based twist and noise simulation
    float twist = sin(time + radius * 10.0) * 0.5;
    angle += twist;

    // Spiral lines
    float lines = sin(12.0 * angle + radius * 20.0 - time * 2.0);

    // Fade by radius
    float fade = exp(-radius * 2.5);

    float brightness = lines * fade;

    return float4(brightness, brightness, brightness, 1.0);
}
