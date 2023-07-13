Shader "Holistic/DotProduct/Cutoff" {

	Properties{
		_MainTex("Base Color", 2D) = "white" {} 
		_RimColor("Rim Color", Color) = (0, 0.5, 0.5, 0.0)
		_RimPower("Rim Power", Range(0.5, 8.0)) = 3.0
		_StripeSize("StripeSize", Range(1, 20)) = 10
	}

	SubShader{

		CGPROGRAM
		#pragma surface surf Lambert

		struct Input {
			// the viewing direction
			float3 viewDir;
			float3 worldPos;
			float2 uv_MainTex;
		};

		float4 _RimColor;
		float _RimPower;
		float _StripeSize;
		sampler2D _MainTex;

		void surf(Input IN, inout SurfaceOutput o) {
			// saturate will reduce a value between (0,1) 
			// 1 on the outside, 0 facing the viewer
			half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));

			o.Albedo = o.Albedo = (tex2D(_MainTex, IN.uv_MainTex)).rgb;
			// pow pushes the light more to the boundary
			//o.Emission = IN.worldPos.y > 1 ? float3(0,1,0): float3(1,0,0);
			o.Emission = frac(IN.worldPos.y * (20-_StripeSize) * 0.5) > 0.4 ?
				float3(0, 1, 0) * rim : float3(1, 0, 0) * rim;
		}

	ENDCG
	}

	FallBack "Diffuse"
}