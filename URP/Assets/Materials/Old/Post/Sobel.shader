Shader "Learn/Sobel"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Slider ("Slider", Range(0,1)) = 1
        _MATRIXV1 ("MATRIXV1", vector) = (1, 1, 1)
        _MATRIXV2 ("MATRIXV2", vector) = (1, 1, 1)
        _MATRIXV3 ("MATRIXV3", vector) = (1, 1, 1)
        _MATRIXH1 ("MATRIXH1", vector) = (1, 1, 1, 1)
        _MATRIXH2 ("MATRIXH2", vector) = (1, 1, 1, 1)
        _MATRIXH3 ("MATRIXH3", vector) = (1, 1, 1, 1)
        _BackColor ("BackColor", Color) = (1, 1, 1, 1)
        
        _Threshold ("Threshold", Range(0, 1)) = 1
        _EdgeColor ("EdgeColor", Color) = (0, 0, 0, 0)

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
            float4 _MATRIXV1;
            float4 _MATRIXV2;
            float4 _MATRIXV3;
            float4 _MATRIXH1;
            float4 _MATRIXH2;
            float4 _MATRIXH3;


            float _Threshold;
            float4 _BackColor;
            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            float sobel(sampler2D Tex, float2 uv, float4 TexelSize)
            {
                float4 Vcol = 
                tex2D(Tex, uv + float2(-TexelSize.x, TexelSize.y)) * _MATRIXV1.x +
                tex2D(Tex, uv + float2(0, TexelSize.y)) * _MATRIXV1.y +
                tex2D(Tex, uv + float2(TexelSize.x, TexelSize.y)) * _MATRIXV1.z +
                tex2D(Tex, uv + float2(-TexelSize.x, 0)) * _MATRIXV2.x +
                tex2D(Tex, uv + float2(0, 0)) * _MATRIXV2.y +
                tex2D(Tex, uv + float2(TexelSize.x, 0)) * _MATRIXV2.z +
                tex2D(Tex, uv + float2(-TexelSize.x, -TexelSize.y)) * _MATRIXV3.x +
                tex2D(Tex, uv + float2(0, -TexelSize.y)) * _MATRIXV3.y +
                tex2D(Tex, uv + float2(TexelSize.x, -TexelSize.y)) * _MATRIXV3.z;

                
                float4 Hcol = 
                tex2D(Tex, uv + float2(-TexelSize.x, TexelSize.y)) * _MATRIXH1.x +
                tex2D(Tex, uv + float2(0, TexelSize.y)) * _MATRIXH1.y +
                tex2D(Tex, uv + float2(TexelSize.x, TexelSize.y)) * _MATRIXH1.z +
                tex2D(Tex, uv + float2(-TexelSize.x, 0)) * _MATRIXH2.x +
                tex2D(Tex, uv + float2(0, 0)) * _MATRIXH2.y +
                tex2D(Tex, uv + float2(TexelSize.x, 0)) * _MATRIXH2.z +
                tex2D(Tex, uv + float2(-TexelSize.x, -TexelSize.y)) * _MATRIXH3.x +
                tex2D(Tex, uv + float2(0, -TexelSize.y)) * _MATRIXH3.y +
                tex2D(Tex, uv + float2(TexelSize.x, -TexelSize.y)) * _MATRIXH3.z;

                float sobelcol = sqrt(Vcol * Vcol + Hcol * Hcol); 
                return sobelcol;

            }

            fixed4 frag (v2f i) : SV_Target
            {
                float sobelcol = sobel(_MainTex, i.uv, _MainTex_TexelSize);
                float4 tex = tex2D(_MainTex, i.uv);

                float edgeMask = saturate(lerp(0, sobelcol, _Threshold));
                float3 EdgeMaskColor = float3(edgeMask, edgeMask, edgeMask);

                float4 final = float4(tex.rgb - EdgeMaskColor, 1);

                return final;
            }
            ENDCG
        }
    }
}
