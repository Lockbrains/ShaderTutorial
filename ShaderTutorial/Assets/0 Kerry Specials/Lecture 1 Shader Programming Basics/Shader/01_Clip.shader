Shader "Special/Basics/Clip"
{
    Properties
    {
        _Color("Color", Color) = (0.5,0.5,0.5,0.5)
        _Cutout("Cutout", Range(-0.1, 1.1)) = 0.0
        _Speed("Speed", Vector) = (1,1,0,0)
        _NoiseTex("Noise", 2D) = "white" {}
        _MainTex("MainTex", 2D) = "white" {}
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("CullMode", float) = 2
    }

    SubShader
    {
        Pass
        {
            Cull[_CullMode]
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 pos_uv : TEXCOORD1;
            };

            float4 _Color;
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float4 _MainTex_ST;
            float4 _NoiseTex_ST;
            float _Cutout;
            float4 _Speed;

            v2f vert(appdata v)
            {
                v2f o;
                float4 pos_world = mul(unity_ObjectToWorld, v.vertex);
                float4 pos_view = mul(UNITY_MATRIX_V, pos_world);
                float4 pos_clip = mul(UNITY_MATRIX_P, pos_view);
                o.pos = pos_clip;
                o.uv = v.texcoord0 * _MainTex_ST.xy + _MainTex_ST.zw;
                o.pos_uv = pos_world.xz * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                // read the r
                half gradient = tex2D(_MainTex, i.uv + _Time.y * _Speed.xy).r;
                half noise = tex2D(_NoiseTex, i.uv + _Time.y * _Speed.zw).r;
                clip(gradient - noise - _Cutout);
                // gradient.xxxx === float4(gradient, gradient, gradient, gradient)
                return _Color;
            }

            ENDCG
        }
    }
}