sampler2D BASETEXTURE : register(s0);
float4 C0 : register(c0); // C0.x = Zeit, C0.y = Geschwindigkeit

struct PS_INPUT {
    float2 uv : TEXCOORD0;
};

// Chaos-Fraktion (angepasste Version von Kali's Loop)
float3 chaosLoop(float3 p) {
    for (int i = 0; i < 10; i++) {
        p = abs(p * 2.04) / max(dot(p, p), 0.001) - 0.9;
    }
    return p;
}

float4 main(PS_INPUT IN) : COLOR {
    float2 uv = IN.uv * 2.0 - 1.0; // Zentrierte Koordinaten (-1 bis 1)
    float time = C0.x * 58.0;      // Beschleunigte Zeit für den Warp-Effekt
    float speed = C0.y;             // Kontrolliert die Intensität
    
    float3 col = float3(0, 0, 0);
    float s = 0.0;
    float v = 0.0;
    
    // Initialposition mit leichter Animation
    float3 init = float3(
        sin(time * 0.0032) * 0.3,
        0.35 - cos(time * 0.005) * 0.3,
        time * 0.002
    );
    
    // Haupt-Loop (reduziert auf 50 Iterationen für Performance)
    for (int r = 0; r < 50; r++) {
        float3 p = init + s * float3(uv, 0.05);
        p.z = frac(p.z); // Wiederholung entlang der Z-Achse
        
        // Chaos-Fraktion anwenden
        p = chaosLoop(p);
        
        v += pow(max(dot(p, p), 0.001), 0.7) * 0.06;
        col += float3(
            v * 0.2 + 0.4,
            12.0 - s * 2.0,
            0.1 + v * 1.0
        ) * v * 0.00003 * speed;
        
        s += 0.025;
    }
    
    // Farbkorrektur und Clamping
    col = clamp(col, 0.0, 1.0);
    return float4(col, 1.0);
}