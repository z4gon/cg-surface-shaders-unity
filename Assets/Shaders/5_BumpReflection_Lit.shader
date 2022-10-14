Shader "Custom/5_BumpReflection_Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "white" {}
        _SkyBox ("Sky Box", CUBE) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _NormalMap;
        samplerCUBE _SkyBox;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
            o.Normal = tex2D(_NormalMap, IN.uv_NormalMap);
            o.Emission = texCUBE(_SkyBox, WorldReflectionVector(IN, o.Normal)).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
