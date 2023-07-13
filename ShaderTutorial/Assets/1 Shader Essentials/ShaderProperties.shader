Shader "Holistic/ShaderPropertiesExample" {

	Properties{
		// NO SEMICOLONS here

		// Color Pickers
		_myColour("Albedo", Color) = (1,1,1,1)
		_myEmission("Emission", Color) = (1,1,1,1)
		_myNormal("Normal", Color) = (1,1,1,1)

		// Value Range
		_myRange("Range", Range(0,5)) = 1
		
		// 2D Texture
		_myTex("2D Texture", 2D) = "white"{}
		
		// CUBE
		_myCube("Cube", CUBE) = ""{}

		// Float
		_myFloat("Float", Float) = 0.5
		
		// Vector
		_myVector("Vector", Vector) = (0.5, 1, 1, 1)
	}

		SubShader{

			CGPROGRAM
				#pragma surface surf Lambert

				struct Input {
					float2 uv_myTex;
					float3 worldRefl;
				};

				// remember to also declare the variable here
				// also in Propereties of course, the names should match the Properties
				fixed4 _myColour;
				fixed4 _myEmission;
				fixed4 _myNormal;
				half _myRange;
				sampler2D _myTex;
				samplerCUBE _myCube;
				float _myFloat;
				float4 _myVector;

				void surf(Input IN, inout SurfaceOutput o) {
					o.Albedo = (tex2D(_myTex, IN.uv_myTex) * _myRange).rgb + _myColour.rgb;        
					o.Emission = texCUBE (_myCube, IN.worldRefl).rgb;
				}

			ENDCG
		}

		FallBack "Diffuse"
}