Shader "Custom/4_EnvironmentReflection_Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SkyBox ("Sky Box", CUBE) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        samplerCUBE _SkyBox;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldRefl;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
            o.Emission = texCUBE(_SkyBox, IN.worldRefl).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
