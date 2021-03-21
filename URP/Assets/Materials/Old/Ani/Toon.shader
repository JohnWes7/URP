Shader "Learn/Toon"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LightTex ("Light", 2D) = "white" {}
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        
        _AmbientStrength ("AmbientStrenght", float) = 1
        _DiffuseStrenght ("DiffuseStrenght", float) = 1
        _SpecStrenght ("SpecStrenght", float) = 1
        _RimStrenght ("RimStrenght", float) = 1
        _RimColor ("RimColor", Color) = (1, 1, 1, 1)
        _RimAmount ("RimAmount", float) = 0.5
        _Gloss ("Gloss", Range(2, 256)) = 4
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode" = "UniversalForward"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 worldPos : TEXCOORD1;
                float3 worldNormal : NORMAL;
            };

            sampler2D _MainTex;
            sampler2D _LightTex;
            float4 _MainTex_ST;
            float4 _MainColor;
            float _AmbientStrength;
            float _DiffuseStrenght;
            float _SpecStrenght;
            float _RimStrenght;
            float4 _RimColor;
            float _RimAmount;
            float _Gloss;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = mul(unity_ObjectToWorld, v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {   
                float4 tex = tex2D(_MainTex, i.uv);

                float3 n_worldNormal = normalize(i.worldNormal);
                float3 n_worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

                //DIFFUSE
                float NdotL = dot(n_worldNormal, n_worldLightDir) * 0.5 + 0.5;
                float2 lightuv = float2(NdotL, 1);
                float3 l = tex2D(_LightTex, lightuv);
                
                float3 diffuse = _LightColor0 * l.x * _DiffuseStrenght;

                float3 n_viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                //SPECULAR
                float3 reflectLight = reflect(-n_worldLightDir, n_worldNormal);
                float VdotRe = smoothstep(0.5, 0.51, pow(max(0, dot(reflectLight, n_viewDir)), _Gloss));
                float3 specular = _LightColor0 * VdotRe * _SpecStrenght;

                //Ambient
                float3 ambient = _LightColor0 * _AmbientStrength;

                //Rim
                float NdotV = 1 - dot(n_viewDir, n_worldNormal);
                float rimSmooth = max(0, dot(n_worldNormal, n_worldLightDir)) * smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, NdotV);
                float3 rim = rimSmooth * _LightColor0 * _RimColor * _RimStrenght;

                // if(NdotV > _RimAmount)
                //     return float4((ambient + diffuse + specular), 1) * _RimColor;

                float4 final = float4((ambient + diffuse + specular + rim), 1) * tex * _MainColor;

                return final;
            }
            ENDCG
        }
    }
}
