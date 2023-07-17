Shader "Holistic/LightingModel/BasicLambert"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
    }
        SubShader
    {
        Tags { "Queue" = "Geometry" }

        CGPROGRAM
        #pragma surface surf BasicLambert

        half4 LightingBasicLambert(SurfaceOutput s, half3 lightDir, half atten) {

            // the dot product between the normal of the surface and the direction of the light source
            // 1 if directly over, 0 if parallel with the surface
            half NdotL = dot(s.Normal, lightDir);
            half4 c;
            // Multiplied with the light
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
        FallBack "Diffuse"
}
