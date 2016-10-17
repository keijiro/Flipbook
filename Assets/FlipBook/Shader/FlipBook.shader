Shader "Custom/FlipBook"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Curve ("Curve", Float) = 0.15
        _Progress ("Progress", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Tags { "LightMode" = "MotionVectors" }
            Cull Off
            ZWrite Off
            Offset -1, -1
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "Motion.cginc"
            ENDCG
        }

        CGPROGRAM
        #pragma surface surf Standard vertex:vert nolightmap
        #pragma target 3.0
        #include "Surface.cginc"
        ENDCG
    }
    FallBack "Diffuse"
}
