Shader "Special/Basics/Blending"
{
    Properties
    {
        _Color("Color", Color) = (0.5,0.5,0.5,0.5)
        _MainTex("MainTex", 2D) = "white" {}
        _Emiss("Emiss", Float) = 1.0
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("CullMode", float) = 2
    }

        SubShader
        {
            Tags{"Queue" = "Transparent"}
            Pass
            {
                ZWrite Off
                Blend SrcAlpha OneMinusSrcAlpha
                Cull[_CullMode]
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
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float2 pos_uv : TEXCOORD1;
                };

                float4 _Color;
                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _Emiss;

                v2f vert(appdata v)
                {
                    v2f o;
                    float4 pos_world = mul(unity_ObjectToWorld, v.vertex);
                    float4 pos_view = mul(UNITY_MATRIX_V, pos_world);
                    float4 pos_clip = mul(UNITY_MATRIX_P, pos_view);
                    o.pos = pos_clip;
                    o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                    return o;
                }

                float4 frag(v2f i) : SV_Target
                {
                    half3 col = _Color.xyz;
                    half alpha = saturate(tex2D(_MainTex, i.uv).r * _Color.a * _Emiss);
                    return float4(col, alpha);
                }

                ENDCG
            }
        }
}