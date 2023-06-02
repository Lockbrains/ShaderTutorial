Shader "Holistic/HelloShader" {

	Properties{
		_myColour ("Albedo", Color) = (1,1,1,1)
		_myEmission ("Emission", Color) = (1,1,1,1)
		_myNormal ("Normal", Color) = (1,1,1,1)
	}

	SubShader{

		CGPROGRAM
			#pragma surface surf Lambert

			struct Input {
				float2 uvMainTex;
			};

			// remember to also declare the variable here
			// also in Propereties of course
			fixed4 _myColour;
			fixed4 _myEmission;
			fixed4 _myNormal;

			void surf(Input IN, inout SurfaceOutput o) {
				o.Albedo = _myColour.rgb;
				o.Emission = _myEmission.rgb;
				o.Normal = _myNormal.rgb;
			}

		ENDCG
	}

	FallBack "Diffuse"
}