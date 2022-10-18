Shader "Custom/11_ManualLightingAndShadow_Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            sampler2D _MainTex;
            sampler2D _NormalMap;
            float4 _MainTex_ST;

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 position : SV_POSITION;
                fixed4 diffuse: COLOR0;
                fixed3 ambient: COLOR1;
            };

            v2f vert (appdata_base v)
            {
                v2f OUT;

                OUT.position = UnityObjectToClipPos(v.vertex);
                OUT.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                // calculate Lambert lighting -----------------------------------------------------------
                float3 lightDirection = _WorldSpaceLightPos0.xyz;

                half3 worldNormal = UnityObjectToWorldNormal(v.normal);

                // dot product between normal and light vector, provide the basis for the lit shading
                half lightInfluence = max(0, dot(worldNormal, lightDirection)); // avoid negative values

                OUT.diffuse = lightInfluence * _LightColor0;

                // calculate ambient illumination -------------------------------------------------------
                OUT.ambient = ShadeSH9(half4(worldNormal, 1));

                return OUT;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 color = tex2D(_MainTex, i.uv);

                // combine lighting and shadows
                fixed shadow = 1;
                fixed3 lighting = i.diffuse * shadow + i.ambient;

                return fixed4(color * lighting, 1);
            }
            ENDCG
        }
    }
}
