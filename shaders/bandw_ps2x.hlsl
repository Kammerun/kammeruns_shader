sampler BASETEXTURE : register(s0);

float4 main( float2 texCoord : TEXCOORD0 ) : COLOR
{
    float4 color = tex2D( BASETEXTURE, texCoord );

    // Standard-Luminanz-Graustufen-Berechnung
    float gray = (color.r + color.g + color.b) / 5.0;
    return float4(gray, gray, gray, color.a);
}