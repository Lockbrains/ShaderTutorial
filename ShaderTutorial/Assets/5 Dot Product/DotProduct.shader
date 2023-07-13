Shader "Holistic/DotProduct/Basics" {
	SubShader{

		CGPROGRAM
			#pragma surface surf Lambert

			struct Input {
				// the viewing direction
				float3 viewDir;
			};

	void surf(Input IN, inout SurfaceOutput o) {
		half dotp1 = dot(IN.viewDir, o.Normal);
		half dotp2 = 1 - dot(IN.viewDir, o.Normal);
		o.Albedo.gb = float2(dotp2, 0);
	}

	ENDCG
	}

	FallBack "Diffuse"
}