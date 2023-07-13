Shader "Holistic/MetallicReflectiveBump"
{
    Properties
    {
        _diffuseTex("Diffuse Texture", 2D) = "white" {}
        _bumpTex("Bump Texture", 2D) = "bump" {}
        _slider ("Bump Amount", Range(0, 10)) = 1
        _bright ("Brightness", Range(0, 10)) = 1
        _cube("Cube Map", CUBE) = "white" {}
    }
        SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        sampler2D _diffuseTex;
        sampler2D _bumpTex;
        half _slider;
        half _bright;
        samplerCUBE _cube;

        struct Input
        {
            float2 uv_diffuseTex;
            float2 uv_bumpTex;
            float3 worldRefl; INTERNAL_DATA
        };


        void surf(Input IN, inout SurfaceOutput o)
        {
            //o.Albedo = (tex2D(_diffuseTex, IN.uv_diffuseTex)).rgb;
            o.Albedo = texCUBE(_cube, WorldReflectionVector(IN, o.Normal)).rgb;
            o.Normal = UnpackNormal(tex2D(_bumpTex, IN.uv_bumpTex)) * 0.3;
        }
        ENDCG
    }
        FallBack "Diffuse"
}