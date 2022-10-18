Shader "Custom/11_ManualLightingAndShadow_Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // compile shader into multiple variants, with and without shadows
            // (we don't care about any lightmaps yet, so skip these variants)
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            sampler2D _MainTex;
            sampler2D _NormalMap;
            float4 _MainTex_ST;

            struct v2f
            {
                float2 uv : TEXCOORD0;
                SHADOW_COORDS(1)
                float4 pos : SV_POSITION;
                fixed3 diff: COLOR0;
                fixed3 ambient: COLOR1;
            };

            v2f vert (appdata_base v)
            {
                v2f OUT;

                OUT.pos = UnityObjectToClipPos(v.vertex);
                OUT.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                // calculate Lambert lighting -----------------------------------------------------------
                float3 lightDirection = _WorldSpaceLightPos0.xyz;

                half3 worldNormal = UnityObjectToWorldNormal(v.normal);

                // dot product between normal and light vector, provide the basis for the lit shading
                half lightInfluence = max(0, dot(worldNormal, lightDirection)); // avoid negative values

                OUT.diff = lightInfluence * _LightColor0.rgb;

                // calculate ambient illumination -------------------------------------------------------
                OUT.ambient = ShadeSH9(half4(worldNormal, 1));

                // calculate shadows --------------------------------------------------------------------
                // compute shadows data
                TRANSFER_SHADOW(OUT)

                return OUT;
            }

            fixed4 frag (v2f IN) : SV_Target
            {
                // sample the texture
                fixed4 color = tex2D(_MainTex, IN.uv);

                // combine lighting and shadows
                fixed shadow = SHADOW_ATTENUATION(IN);
                fixed3 lighting = IN.diff * shadow + IN.ambient;

                return fixed4(color * lighting, 1);
            }
            ENDCG
        }
    }
}
