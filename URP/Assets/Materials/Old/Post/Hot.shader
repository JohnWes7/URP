Shader "Learn/Hot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MoveTex ("MoveTex", 2D) = "white" {}
        _Magnitude ("Magnitude", Range(0,0.1)) = 0
    }
    SubShader
    {
        Tags 
        { 
            "PreviewType" = "Plane"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _MoveTex;
            float4 _MoveTex_ST;

            float _Magnitude;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 mtexuv = float2(i.uv.x + _Time.x, i.uv.y + _Time.x);
                float2 Mtex = tex2D(_MoveTex, mtexuv).xy;//此偏移值全部会大于1，要和法线贴图一样把（0，1）转换为（-1，1）或者（-0.5，0.5）
                Mtex = ((Mtex * 2) - 1) * _Magnitude;
                float4 col = tex2D(_MainTex, i.uv + Mtex);

                return col;
            }
            ENDCG
        }
    }
}
