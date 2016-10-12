half _Curve;

float3 CalculateVertex(float2 uv, float time01)
{
    float l = uv.x;

    float time = time01 * (_Curve + 1) - l * _Curve;
    float phi = saturate(time) * UNITY_PI / 2;

    float sn, cs;
    sincos(phi, sn, cs);

    return float3(float2(sn, cs) * l, uv.y);
}
