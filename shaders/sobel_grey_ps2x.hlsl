sampler BASETEXTURE : register(s0);

float4 main(float2 texCoord : TEXCOORD0) : COLOR
{
    // Sample the neighboring pixels
    float2 texelSize = 1.0 / float2(1024, 1024); // Anpassen an Ihre Auflösung
    
    float3 sample00 = tex2D(BASETEXTURE, texCoord + float2(-1, -1) * texelSize).rgb;
    float3 sample10 = tex2D(BASETEXTURE, texCoord + float2( 0, -1) * texelSize).rgb;
    float3 sample20 = tex2D(BASETEXTURE, texCoord + float2( 1, -1) * texelSize).rgb;
    float3 sample01 = tex2D(BASETEXTURE, texCoord + float2(-1,  0) * texelSize).rgb;
    float3 sample21 = tex2D(BASETEXTURE, texCoord + float2( 1,  0) * texelSize).rgb;
    float3 sample02 = tex2D(BASETEXTURE, texCoord + float2(-1,  1) * texelSize).rgb;
    float3 sample12 = tex2D(BASETEXTURE, texCoord + float2( 0,  1) * texelSize).rgb;
    float3 sample22 = tex2D(BASETEXTURE, texCoord + float2( 1,  1) * texelSize).rgb;
    
    // Convert to grayscale
    float gray00 = dot(sample00, float3(0.299, 0.587, 0.114));
    float gray10 = dot(sample10, float3(0.299, 0.587, 0.114));
    float gray20 = dot(sample20, float3(0.299, 0.587, 0.114));
    float gray01 = dot(sample01, float3(0.299, 0.587, 0.114));
    float gray21 = dot(sample21, float3(0.299, 0.587, 0.114));
    float gray02 = dot(sample02, float3(0.299, 0.587, 0.114));
    float gray12 = dot(sample12, float3(0.299, 0.587, 0.114));
    float gray22 = dot(sample22, float3(0.299, 0.587, 0.114));
    
    // Sobel operators
    float sobelX = gray00 + 2.0 * gray10 + gray20 - gray02 - 2.0 * gray12 - gray22;
    float sobelY = gray00 + 2.0 * gray01 + gray02 - gray20 - 2.0 * gray21 - gray22;
    
    float edge = sqrt(sobelX * sobelX + sobelY * sobelY);
    
    // Invertieren für weiße Kanten auf schwarzem Hintergrund
    edge = 1.0 - saturate(edge);
    
    return float4(edge, edge, edge, 1.0);
}