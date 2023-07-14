Shader "Holistic/Blinn-Phong/BasicBlinnPhong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        //_SpecColor is already defined by unity
        // Lambert lighting has no specular light so this should do nothing
        _SpecColor("Specular Reflection Color", Color) = (1,1,1,1)
        _Spec("Specular", Range(0,1)) = 0.5
        _Gloss("Gloss", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }

        CGPROGRAM
        #pragma surface surf BlinnPhong
        float4 _Color;
        half _Spec;
        fixed _Gloss;

        struct Input
        {
            float2 uv_MainTex;
        };

        

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
            o.Specular = _Spec;
            o.Gloss = _Gloss;
            // Don't define anything with _SpecColor because it's already defined by unity

        }
        ENDCG
    }
    FallBack "Diffuse"
}
