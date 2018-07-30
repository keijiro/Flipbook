// Flip book effect example
// https://github.com/keijiro/FlipBook

Shader "Hidden/Flipbook"
{
    Properties
    {
        _MainTex("", 2D) = "white" {}
        _BackColor("", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Cull Off

        Pass
        {
            Tags { "LightMode" = "MotionVectors" }
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
        #pragma surface surf Standard vertex:vert addshadow nolightmap
        #pragma target 3.0
        #include "Surface.cginc"
        ENDCG
    }
    FallBack "Diffuse"
}
