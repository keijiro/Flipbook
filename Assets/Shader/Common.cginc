// Flip book effect example
// https://github.com/keijiro/FlipBook

half _Curvature;

float3 CalculateVertex(float u, float v, float param)
{
    param = 1 - param;
    float phi = param * (UNITY_PI / 2 + _Curvature * v);
    v /= 1 + _Curvature / UNITY_PI * param;
    return float3(0.5 - u, 0.5 - cos(phi) * v, -sin(phi) * v);
}
