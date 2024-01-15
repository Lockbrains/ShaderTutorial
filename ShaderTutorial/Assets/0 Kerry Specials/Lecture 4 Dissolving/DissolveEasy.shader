Shader "Dissolve/DissolveEasy"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Gradient ("Gradient", 2D) = "white" {}
        _EdgeColor ("Edge Color", Color) = (1,1,1,1)
        _EdgeWidth ("Edge Width", float) = 0.1
        _DissolveThreshold("Dissolve Threshold", Range(-1,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100
        
        Blend SrcAlpha OneMinusSrcAlpha
        // fragments with alpha less than 0.5 will be discarded
        AlphaTest Greater 0.5
        ZWrite Off

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

            sampler2D _Gradient;
            float4 _Gradient_ST;

            fixed4 _EdgeColor;
            fixed _EdgeWidth;

            float _DissolveThreshold;
            
            v2f vert (appdata v)
            {
                v2f o;
                // the clip space position for the vertex
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the main texture for base color 
                fixed4 col = tex2D(_MainTex, i.uv);

                // sample the gradient for alpha color
                // set the alpha value of color for the fragment as the r-channel of the grad texel
                fixed4 grad = tex2D(_Gradient, i.uv);
                col.a = step(_DissolveThreshold, grad.r);
                
                float edge = smoothstep(_DissolveThreshold - _EdgeWidth, _DissolveThreshold, grad);
                
                col.rgb += _EdgeColor.rgb * edge; // 添加边缘颜色

                return col;
            }
            ENDCG
        }
    }
}
