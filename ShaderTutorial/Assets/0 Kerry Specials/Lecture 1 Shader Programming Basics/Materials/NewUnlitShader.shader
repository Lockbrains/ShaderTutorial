Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _Color("Color", Color) = (0.5,0.5,0.5,0.5)
        _MainTex("MainTex", 2D) = "white" {} 
    }
    
    SubShader
    {
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
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
        
            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            
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
                float4 col = tex2D(_MainTex, i.uv);
                return col;
            }
        
            ENDCG
        }
    }
}