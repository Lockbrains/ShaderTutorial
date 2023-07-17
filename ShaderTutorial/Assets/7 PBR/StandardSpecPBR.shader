Shader "Holistic/PBR/StandardSpecPBR"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MetallicTex("Metallic (R)", 2D) = "white" {}
        _SpecColor("Specular", Color) = (1,1,1,1)
        _Emission("Emisssion", Range(0.0,10.0)) = 1.0 
    }

    SubShader
    {
        Tags {
            "Queue" = "Geometry"
        }

        CGPROGRAM
        #pragma surface surf StandardSpecular

        sampler2D _MetallicTex;
        half _Emission;
        fixed4 _Color;
            

        struct Input
        {
            float2 uv_MetallicTex;
        };



        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            o.Albedo = _Color.rgb;
            o.Smoothness = tex2D(_MetallicTex, IN.uv_MetallicTex).r;
            o.Specular = _SpecColor.rgb;
            o.Emission = (tex2D(_MetallicTex, IN.uv_MetallicTex).r) * _Emission;
        }
        ENDCG
    }
        FallBack "Diffuse"
}
