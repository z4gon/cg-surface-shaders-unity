Shader "Custom/3_StandardSurfaceFresnel_Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "white" {}
        _FresnelColor ("Fresnel Color", Color) = (0,1,1,1)
        _FresnelWidth ("Fresnel Width", Range(0, 2)) = 0.5
        _FresnelPower ("Fresnel Power", Range(1, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _NormalMap;
        fixed4 _FresnelColor;
        float _FresnelWidth;
        float _FresnelPower;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 viewDir; // ray coming out of the camera into the pixel
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
            o.Normal = tex2D(_NormalMap, IN.uv_NormalMap);

            // fresnel
            float fresnelDot = dot(o.Normal, normalize(IN.viewDir));
            fresnelDot = saturate(fresnelDot); // clamp to 0,1
            float fresnel = max(0.0, _FresnelWidth - fresnelDot); // fresnelDot is zero when normal is 90 deg angle from view dir

            o.Emission = _FresnelColor * pow(fresnel, _FresnelPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
