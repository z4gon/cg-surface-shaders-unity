Shader "Custom/6_BlinnPhong_Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _SpecPower("Specular Power", Range(0,1)) = 0.5
        _Glossiness("Glossiness", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf BlinnPhong

        sampler2D _MainTex;
        float _SpecPower;
        float _Glossiness;

        // this is added automatically by Unity
        // when setting lighting model macro to BlinnPhong
        // fixed4 _SpecColor;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
            o.Specular = _SpecPower;
            o.Gloss = _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
