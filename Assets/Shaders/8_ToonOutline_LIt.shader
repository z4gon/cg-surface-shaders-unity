Shader "Custom/8_ToonOutline_Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (1,1,1,1)
        _OutlineWidth ("Outline Width", Range(0.1, 2)) = 0.2
        _ToonShadeLevelCount ("Toon Shade Level Count", Range(1, 10)) = 4
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf LambertToon

        sampler2D _MainTex;
        fixed4 _OutlineColor;
        float _OutlineWidth;
        int _ToonShadeLevelCount;

        struct Input
        {
            float2 uv_MainTex;
        };

        half4 LightingLambertToon (SurfaceOutput s, half3 lightDir, half atten){
            // dot product between normal and light vector, provide the basis for the lit shading
            half lightInfluence = max(0, dot(s.Normal, lightDir)); // avoid negative values

            half3 ramp = floor(lightInfluence * _ToonShadeLevelCount) / _ToonShadeLevelCount;

            half4 color;
            color.rgb = s.Albedo * _LightColor0.rgb * ramp * atten;
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
