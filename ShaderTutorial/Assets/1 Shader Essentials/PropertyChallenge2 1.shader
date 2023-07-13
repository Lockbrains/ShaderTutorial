Shader "Holistic/PropertyChallenge3"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            //note below how to create a colour on the fly with code
            float4 green = float4(0, 1, 0, 1);
            o.Albedo = (tex2D(_MainTex, IN.uv_MainTex) * green).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
