// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Special/Basics/Rim"
{
    Properties
    {
        _Color("Color", Color) = (0.5,0.5,0.5,0.5)
        _MainTex("MainTex", 2D) = "white" {}
        _Emiss("Emiss", Float) = 1.0
        _RimFalloff("RimFalloff", Float) = 1.0
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("CullMode", float) = 2
    }

        SubShader
        {
            Tags{"Queue" = "Transparent"}
            Pass
            {
                Cull Off
                ZWrite On
                ColorMask 0
                CGPROGRAM
                float4 _MainColor;
                #pragma vertex vert
                #pragma fragment frag
                
                float4 vert(float4 vertexPos : POSITION) : SV_POSITION
                {
                    return UnityObjectToClipPos(vertexPos);
                }

                    float4 frag(void) : COLOR
                {
                    return _MainColor;
                }

                ENDCG
            }

            Pass
            {
                ZWrite On
                Blend SrcAlpha One
                Cull[_CullMode]
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normal : NORMAL;
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normal_world : TEXCOORD1;
                    float3 view_world: TEXCOORD2;
                };

                float4 _Color;
                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _Emiss;
                float _RimFalloff;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.normal_world = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                    float3 pos_world = mul(unity_ObjectToWorld, v.vertex);
                    //_WorldSpaceCameraPos comes from the header UnityCG.cginc
                    o.view_world = normalize(_WorldSpaceCameraPos.xyz - pos_world);
                    o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                    return o;
                }

                float4 frag(v2f i) : SV_Target
                {
                    float3 normal_world = normalize(i.normal_world);
                    float3 view_world = normalize(i.view_world);
                    float3 color = _Color.xyz * _Emiss;
                    float NdotV = saturate(dot(normal_world, view_world));
                    float fresnel = pow((1.0 - NdotV), _RimFalloff);
                    float rim = saturate(fresnel * _Emiss);
                    return float4(color, rim);
                }

                ENDCG
            }
        }
}