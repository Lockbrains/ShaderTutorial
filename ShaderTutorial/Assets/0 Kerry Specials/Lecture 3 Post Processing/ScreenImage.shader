Shader "Unlit/ScreenImage"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 screen_pos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                // clip space to NDC to screen coordinates
                //o.screen_pos = o.pos;
                //o.screen_pos.y *= _ProjectionParams.x;
                o.screen_pos = ComputeScreenPos(o.pos);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // perspective division, don't do this step in vertex
                half2 screen_uv = i.screen_pos.xy / (i.screen_pos.w + 0.000001);
                // remap to 0-1
                // screen_uv = (screen_uv + 1.0) * 0.5;
                // sample the texture
                half4 col = tex2D(_MainTex, screen_uv);

                return col;
            }
            ENDCG
        }
    }
}
