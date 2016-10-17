half _Curve;

float3 CalculateVertex(float u, float v, float time01)
{
    float time = time01 * (_Curve + 1) - v * _Curve;
    float phi = saturate(time) * UNITY_PI / 2;

    float sn, cs;
    sincos(phi, sn, cs);

    return float3(u, float2(cs, sn) * v);
}
