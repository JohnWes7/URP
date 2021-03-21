Shader "Unlit/2077"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("NoiseTex", 2D) = "white" {}
        _NoiseColor ("NoiseColor", 2D) = "white" {}
        _Intensity ("Intensity", Range(0, 1)) = 1
        _UVSlider ("UVSlider", Range(0, 1)) = 0
        _Offset ("Offset", float) = 0
        _BlackScreen_Slider ("_BlackScreen_Slider", Range(0, 1)) = 0
    }
    SubShader
    {
       

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _NoiseTex;
            sampler2D _NoiseColor;
            float _Intensity;
            float _Offset;
            float _UVSlider;
            float _BlackScreen_Slider;

            fixed4 frag (v2f_img i) : SV_Target
            {

                fixed4 col = tex2D(_MainTex, i.uv);
                float4 glitch = tex2D (_NoiseTex, i.uv);

                float2 uv = i.uv + float2(-0.1, 0);
                float4 offsetCol = tex2D(_MainTex, uv);
                

                if(glitch.g > 0.8)
                    i.uv += float2(_Offset * glitch.b * 2 - 1, 0);
                else if(glitch.g < 0.2)
                    i.uv += float2(0, -_Offset * glitch.b * 2 - 1);
                
                float4 noiseColor = tex2D(_NoiseColor, i.uv);

                float offsetColstep = step(_UVSlider * 1.001, glitch.g);
                float step1 = step(1.001 - _Intensity * 1.001, pow(glitch.b, 2.5));
                float blackStep = step(1.001 - _BlackScreen_Slider * 1.001, pow(glitch.b, 2.5));

                col = lerp(col, offsetCol, offsetColstep);
                col = lerp(col, noiseColor * glitch.a, step1);
                col = lerp(col, glitch.r, blackStep);
                return col;
            }

            ENDCG
        }
    }
}
