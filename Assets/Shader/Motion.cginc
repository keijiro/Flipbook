// Flip book effect example
// https://github.com/keijiro/FlipBook

#include "UnityCG.cginc"
#include "Common.cginc"

float4x4 _NonJitteredVP;
half _PrevParam, _Param;

struct v2f
{
    float4 vertex : SV_POSITION;
    float4 transfer0 : TEXCOORD0;
    float4 transfer1 : TEXCOORD1;
};

v2f vert(float2 uv : TEXCOORD0)
{
    float3 p0 = CalculateVertex(uv.x, uv.y, _PrevParam);
    float3 p1 = CalculateVertex(uv.x, uv.y, _Param);

    v2f o;
    o.vertex = UnityObjectToClipPos(float4(p1, 1));
    o.transfer0 = mul(_NonJitteredVP, mul(unity_ObjectToWorld, float4(p0, 1)));
    o.transfer1 = mul(_NonJitteredVP, mul(unity_ObjectToWorld, float4(p1, 1)));
    return o;
}

half4 frag(v2f i) : SV_Target
{
    float2 vp0 = (i.transfer0.xy / i.transfer0.w + 1) / 2;
    float2 vp1 = (i.transfer1.xy / i.transfer1.w + 1) / 2;
#if UNITY_UV_STARTS_AT_TOP
    vp0.y = 1 - vp0.y;
    vp1.y = 1 - vp1.y;
#endif
    return half4(vp1 - vp0, 0, 1);
}
