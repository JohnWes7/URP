Shader "Learn/RGBoffset"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Offset ("Offset", float) = 0
        _offTime ("Time", float) = 0
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
            float _Offset;
            float _offTime;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                if(abs(_offTime - 1) < 0.05)
                {
                    fixed4 red = tex2D(_MainTex, i.uv + _Offset * 2);
                    fixed4 green = tex2D(_MainTex, i.uv);
                    fixed4 blue = tex2D(_MainTex, i.uv - _Offset * 2);

                    return fixed4(red.r , green.g , blue.b , 1);
                }

                fixed4 red = tex2D(_MainTex, i.uv + _Offset);
                fixed4 green = tex2D(_MainTex, i.uv);
                fixed4 blue = tex2D(_MainTex, i.uv - _Offset);

                return fixed4(red.r, green.g, blue.b, 1);
            }
            ENDCG
        }
    }
}
