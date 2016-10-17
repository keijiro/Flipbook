#include "Common.cginc"

struct Input
{
    float2 uv_MainTex;
};

sampler2D _MainTex;
fixed4 _Color;
half _Progress;

void vert(inout appdata_full v, out Input data)
{
    UNITY_INITIALIZE_OUTPUT(Input, data);

    float2 uv = v.texcoord.xy;

    float epsilon = 0.001;
    float3 p0 = CalculateVertex(uv.x, uv.y - epsilon, _Progress);
    float3 p1 = CalculateVertex(uv.x, uv.y,           _Progress);
    float3 p2 = CalculateVertex(uv.x, uv.y + epsilon, _Progress);

    v.vertex = float4(p1, 1);
    v.normal = cross(p2 - p0, float3(1, 0, 0));
    v.texcoord.xy = 1 - float2(uv.x, uv.y);
}

void surf(Input IN, inout SurfaceOutputStandard o)
{
    o.Albedo = tex2D (_MainTex, IN.uv_MainTex) * _Color;
    o.Metallic = 0;
    o.Smoothness = 0;
}
