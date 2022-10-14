Shader "Custom/7_CustomLambertLighting_Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf MyCustomLambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half4 LightingMyCustomLambert (SurfaceOutput s, half3 lightDir, half atten){
            // dot product between normal and light vector, provide the basis for the lit shading
            half lightInfluence = max(0, dot(s.Normal, lightDir)); // avoid negative values

            half4 color;
            color.rgb = s.Albedo * _LightColor0.rgb * lightInfluence * atten;
            color.a = s.Alpha;

            return color;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
