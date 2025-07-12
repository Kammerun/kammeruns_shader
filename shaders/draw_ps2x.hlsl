sampler BASETEXTURE : register(s0);

// Hatching-Funktion (angepasst für HLSL)
float3 applyHatching(float2 uv, float luminance, float edge)
{
    // Schraffurwinkel und -dichte
    float hatchAngle1 = 45.0 * 3.14159 / 180.0;
    float hatchAngle2 = 135.0 * 3.14159 / 180.0;
    float hatchDensity = 15.0;
    
    // Erzeuge Schraffurmuster
    float hatch1 = abs(sin(dot(uv, float2(cos(hatchAngle1), sin(hatchAngle1)) * hatchDensity)));
    float hatch2 = abs(sin(dot(uv, float2(cos(hatchAngle2), sin(hatchAngle2)) * hatchDensity)));
    
    // Kombiniere Muster basierend auf Helligkeit
    float hatch = saturate((hatch1 + hatch2) * 0.7 - luminance * 2.0 + 0.5);
    
    // Mische mit Kantenerkennung
    return lerp(float3(1,1,1), float3(0.7,0.7,0.7), hatch * edge);
}

float4 main(float2 texCoord : TEXCOORD0) : COLOR
{
    // 1. Bestimme die Texturgröße
    float2 texelSize = 1.0 / float2(1024, 1024);
    
    // 2. Sampling der Nachbarpixel
    float3 samples[9];
    samples[0] = tex2D(BASETEXTURE, texCoord + float2(-1,-1) * texelSize).rgb;
    samples[1] = tex2D(BASETEXTURE, texCoord + float2(0,-1) * texelSize).rgb;
    samples[2] = tex2D(BASETEXTURE, texCoord + float2(1,-1) * texelSize).rgb;
    samples[3] = tex2D(BASETEXTURE, texCoord + float2(-1,0) * texelSize).rgb;
    samples[4] = tex2D(BASETEXTURE, texCoord).rgb;
    samples[5] = tex2D(BASETEXTURE, texCoord + float2(1,0) * texelSize).rgb;
    samples[6] = tex2D(BASETEXTURE, texCoord + float2(-1,1) * texelSize).rgb;
    samples[7] = tex2D(BASETEXTURE, texCoord + float2(0,1) * texelSize).rgb;
    samples[8] = tex2D(BASETEXTURE, texCoord + float2(1,1) * texelSize).rgb;

    // 3. Graustufenkonvertierung
    float grays[9];
    for(int i = 0; i < 9; i++) {
        grays[i] = dot(samples[i], float3(0.299, 0.587, 0.114));
    }

    // 4. Sobel-Operator
    float sobelX = grays[0] + 2.0*grays[1] + grays[2] - grays[6] - 2.0*grays[7] - grays[8];
    float sobelY = grays[0] + 2.0*grays[3] + grays[6] - grays[2] - 2.0*grays[5] - grays[8];
    
    // 5. Kantenerkennung
    float edge = sqrt(sobelX*sobelX + sobelY*sobelY);
    edge = smoothstep(0.1, 0.3, edge);
    
    // 6. Helligkeitsberechnung
    float luminance = grays[4];
    
    // 7. Kombiniere Hatching mit Kanten
    float3 hatching = applyHatching(texCoord * 10.0, luminance, edge);
    float3 edgeColor = samples[4] * (1.0 - edge * 0.8);
    
    // 8. Finale Kombination
    float3 finalColor = edgeColor * hatching;
    
    return float4(finalColor, 1.0);
}