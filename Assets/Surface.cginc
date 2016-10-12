#include "Common.cginc"

struct Input
{
    float2 uv_MainTex;
};

sampler2D _MainTex;
fixed4 _Color;

half _Metallic;
half _Smoothness;

half _Progress;

void vert(inout appdata_full v, out Input data)
{
    UNITY_INITIALIZE_OUTPUT(Input, data);
    v.vertex = float4(CalculateVertex(v.texcoord.xy, _Progress), 1);
    v.texcoord.xy = float2(v.texcoord.y, 1 - v.texcoord.x);
}

void surf(Input IN, inout SurfaceOutputStandard o)
{
    fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
    o.Albedo = c.rgb;
    o.Metallic = _Metallic;
    o.Smoothness = _Smoothness;
}
