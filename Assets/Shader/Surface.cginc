// Flip book effect example
// https://github.com/keijiro/FlipBook

#include "Common.cginc"

sampler2D _MainTex;
half3 _BackColor;
half _Param;

struct Input
{
    float2 uv_MainTex;
    half vface : VFACE;
};

void vert(inout appdata_full v, out Input data)
{
    UNITY_INITIALIZE_OUTPUT(Input, data);

    float2 uv = v.texcoord.xy;

    const float epsilon = 0.001;
    float3 p0 = CalculateVertex(uv.x, uv.y - epsilon, _Param);
    float3 p1 = CalculateVertex(uv.x, uv.y,           _Param);
    float3 p2 = CalculateVertex(uv.x, uv.y + epsilon, _Param);

    v.vertex = float4(p1, 1);
    v.normal = cross(p2 - p0, float3(-1, 0, 0));
    v.texcoord.xy = 1 - uv;
}

void surf(Input IN, inout SurfaceOutputStandard o)
{
    o.Albedo = IN.vface < 0 ? _BackColor : tex2D(_MainTex, IN.uv_MainTex).rgb;
    o.Normal = half3(0, 0, IN.vface < 0 ? -1 : 1);
}
