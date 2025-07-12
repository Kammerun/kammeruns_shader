sampler BASETEXTURE : register(s0);

float4 main(float2 texCoord : TEXCOORD0) : COLOR
{
    // 1. Bestimme die Texturgröße
    float2 texelSize = 1.0 / float2(1024, 1024);
    
    // 2. Sampling der Nachbarpixel (leicht optimiert)
    float3 samples[9];
    samples[0] = tex2D(BASETEXTURE, texCoord + float2(-1,-1) * texelSize).rgb; // oben links
    samples[1] = tex2D(BASETEXTURE, texCoord + float2( 0,-1) * texelSize).rgb; // oben
    samples[2] = tex2D(BASETEXTURE, texCoord + float2( 1,-1) * texelSize).rgb; // oben rechts
    samples[3] = tex2D(BASETEXTURE, texCoord + float2(-1, 0) * texelSize).rgb; // links
    samples[4] = tex2D(BASETEXTURE, texCoord).rgb; // mittelpunkt
    samples[5] = tex2D(BASETEXTURE, texCoord + float2( 1, 0) * texelSize).rgb; // rechts
    samples[6] = tex2D(BASETEXTURE, texCoord + float2(-1, 1) * texelSize).rgb; // unten links
    samples[7] = tex2D(BASETEXTURE, texCoord + float2( 0, 1) * texelSize).rgb; // unten
    samples[8] = tex2D(BASETEXTURE, texCoord + float2( 1, 1) * texelSize).rgb; // unten rechts

    // 3. Graustufenkonvertierung mit Luminanz
    float grays[9];
    for(int i = 0; i < 9; i++) {
        grays[i] = dot(samples[i], float3(0.299, 0.587, 0.114));
    }

    // 4. Abgeschwächter Sobel-Operator
    float sobelX = grays[0] + 2.0*grays[1] + grays[2] - grays[6] - 2.0*grays[7] - grays[8];
    float sobelY = grays[0] + 2.0*grays[3] + grays[6] - grays[2] - 2.0*grays[5] - grays[8];
    
    // 5. Sanftere Kantenerkennung
    float edge = sqrt(sobelX*sobelX + sobelY*sobelY);
    edge = smoothstep(0.1, 0.3, edge); // Weicher Übergang
    
    // 6. Subtrakte Farbmischung mit Kontrolle
    float edgeStrength = 0.8; // Wert zwischen 0.1 (sehr schwach) und 0.8 (stark)
    float3 originalColor = samples[4];
    float3 edgeColor = originalColor * (1.0 - edge * edgeStrength);
    
    return float4(edgeColor, 1.0);
}