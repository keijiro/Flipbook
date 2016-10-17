#include "UnityCG.cginc"
#include "Common.cginc"

float4x4 _NonJitteredVP;
float4x4 _PreviousVP;
float4x4 _PreviousM;

half _Progress;
half _PreviousProgress;

struct appdata
{
    float4 vertex : POSITION;
    float2 texcoord : TEXCOORD0;
};

struct v2f
{
    float4 vertex : SV_POSITION;
    float4 transfer0 : TEXCOORD0;
    float4 transfer1 : TEXCOORD1;
};

v2f vert(appdata v)
{
    float3 p0 = CalculateVertex(v.texcoord.xy, _PreviousProgress);
    float3 p1 = CalculateVertex(v.texcoord.xy, _Progress);

    float4 wp0 = mul(_PreviousM,  float4(p0, 1));
    float4 wp1 = mul(unity_ObjectToWorld, float4(p1, 1));

    // Transfer the data to the pixel shader.
    v2f o;
    o.vertex = UnityObjectToClipPos(float4(p1, 1));
    o.transfer0 = mul(_PreviousVP, wp0);
    o.transfer1 = mul(_NonJitteredVP, wp1);
    return o;
}

half4 frag(v2f i) : SV_Target
{
    float3 hp0 = i.transfer0.xyz / i.transfer0.w;
    float3 hp1 = i.transfer1.xyz / i.transfer1.w;

    float2 vp0 = (hp0.xy + 1) / 2;
    float2 vp1 = (hp1.xy + 1) / 2;

#if UNITY_UV_STARTS_AT_TOP
    vp0.y = 1 - vp0.y;
    vp1.y = 1 - vp1.y;
#endif

    return half4(vp1 - vp0, 0, 1);
}
