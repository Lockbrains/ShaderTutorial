Shader "Unlit/Dissolve_Easy"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Gradient("Gradient", 2D) = "white" {}
        _EdgeWidth ("Edge Width", Float) = 0.1 
        _EdgeColor ("Edge Color", Color) = (0,0,0,1)
        _EdgeIntensity("Edge Intensity", Float) = 1.0
        _ChangeAmount ("Change Amount", Range(-1,1)) = 0.5 
        _DissolveThreshold ("Dissolve Threshold", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha
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
            float _DissolveThreshold;
            float _ChangeAmount;
            float _EdgeWidth;
            float _EdgeIntensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float grad = tex2D(_Gradient, i.uv).r - _ChangeAmount;
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a = step(0.5, grad);
                
                fixed edge = clamp(1 - abs(grad - 0.5) / _EdgeWidth, 0 , 1);
                col.rgb = lerp(col.rgb, _EdgeColor.rgb * _EdgeIntensity, edge);

                return col;
            }
            ENDCG
        }
    }
}
