Shader "Holistic/DotProduct/RimColors" {

	Properties{

		_RimColor("Rim Color", Color) = (0, 0.5, 0.5, 0.0)
		_RimPower("Rim Power", Range(0.5, 8.0)) = 3.0
	}

	SubShader{

		CGPROGRAM
		#pragma surface surf Lambert

		struct Input {
			// the viewing direction
			float3 viewDir;
		};

		float4 _RimColor;
		float _RimPower;

		void surf(Input IN, inout SurfaceOutput o) {
			// saturate will reduce a value between (0,1)
			half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));

			// pow pushes the light more to the boundary
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
		}

	ENDCG
	}

	FallBack "Diffuse"
}