Shader "Custom/PageFlipping"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Smoothness ("Smoothness", Range(0,1)) = 0.5
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
