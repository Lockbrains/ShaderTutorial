Shader "Holistic/PropertyChallenge4"
{
    Properties
    {
        _diffuseTex ("Diffuse (RGB)", 2D) = "white" {}
        _emissiveTex("Emission (RGB)", 2D) = "black" {}
        
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        sampler2D _diffuseTex;
        sampler2D _emissiveTex;

        struct Input
        {
            float2 uv_diffuseTex;
            float2 uv_emissiveTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = (tex2D(_diffuseTex, IN.uv_diffuseTex)).rgb;
            o.Emission = (tex2D(_emissiveTex, IN.uv_emissiveTex)).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
