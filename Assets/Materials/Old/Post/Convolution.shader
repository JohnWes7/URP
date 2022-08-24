Shader "Learn/Convolution"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Slider ("Slider", Range(0,1)) = 1
        _MATRIX1 ("MATRIX1", vector) = (1, 1, 1)
        _MATRIX2 ("MATRIX1", vector) = (1, 1, 1)
        _MATRIX3 ("MATRIX1", vector) = (1, 1, 1)
        _BackColor ("BackColor", Color) = (1, 1, 1, 1)
        
        _Threshold ("Threshold", Range(0, 3)) = 1 

    }
    SubShader
    {
        Tags 
        { 
            "PreviewType" = "Plane"
        }
        

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
            float4 _MainTex_TexelSize;
            float4 _MATRIX1;
            float4 _MATRIX2;
            float4 _MATRIX3;

            float _Threshold;
            float4 _BackColor;
            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            float4 box(sampler2D Tex, float2 uv, float4 TexelSize)
            {
                float4 col = 
                tex2D(Tex, uv + float2(-TexelSize.x, TexelSize.y)) * _MATRIX1.x +
                tex2D(Tex, uv + float2(0, TexelSize.y)) * _MATRIX1.y +
                tex2D(Tex, uv + float2(TexelSize.x, TexelSize.y)) * _MATRIX1.z +
                tex2D(Tex, uv + float2(-TexelSize.x, 0)) * _MATRIX2.x +
                tex2D(Tex, uv + float2(0, 0)) * _MATRIX2.y +
                tex2D(Tex, uv + float2(TexelSize.x, 0)) * _MATRIX2.z +
                tex2D(Tex, uv + float2(-TexelSize.x, -TexelSize.y)) * _MATRIX3.x +
                tex2D(Tex, uv + float2(0, -TexelSize.y)) * _MATRIX3.y +
                tex2D(Tex, uv + float2(TexelSize.x, -TexelSize.y)) * _MATRIX3.z;

                return col;

            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = box(_MainTex, i.uv, _MainTex_TexelSize);
                float4 tex = tex2D(_MainTex, i.uv);

                if(col.r < _Threshold && col.g < _Threshold && col.b < _Threshold)
                    return col;
                else
                    return _BackColor;
                //return _BackColor;
            }
            ENDCG
        }
    }
}
