Shader "Holistic/Normal Mapping/NM1"
{
    Properties
    {
        _diffuseTex("Diffuse (RGB)", 2D) = "white" {}

        // bump texture is for normal mapping
        _bumpTex("Normal (RGB)", 2D) = "bump" {}

        _slider("Bump Amount", Range(0,10)) = 1

    }
        SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        sampler2D _diffuseTex;
        sampler2D _bumpTex;
        half _slider;

        struct Input
        {
            float2 uv_diffuseTex;
            float2 uv_bumpTex;
        };


        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = (tex2D(_diffuseTex, IN.uv_diffuseTex)).rgb;
            o.Normal = UnpackNormal(tex2D(_bumpTex, IN.uv_bumpTex));
            o.Normal *= float3(_slider, _slider, 1);
        }
        ENDCG
    }
        FallBack "Diffuse"
}