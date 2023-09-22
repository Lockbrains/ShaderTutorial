// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EasyImageEffect"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Brightness("Brightness", Range( 0 , 5)) = 3
		_Saturation("Saturation", Range( -1 , 1)) = 0
		_Contrast("Contrast", Range( 0 , 2)) = 0
		_AddTex("AddTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _AddTex;
			uniform float4 _AddTex_ST;
			uniform float _Brightness;
			uniform float _Saturation;
			uniform float _Contrast;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv_AddTex = i.uv.xy * _AddTex_ST.xy + _AddTex_ST.zw;
				float4 blendOpSrc13 = tex2D( _MainTex, uv_MainTex );
				float4 blendOpDest13 = tex2D( _AddTex, uv_AddTex );
				float3 desaturateInitialColor7 = ( ( saturate( max( blendOpSrc13, blendOpDest13 ) )) * _Brightness ).rgb;
				float desaturateDot7 = dot( desaturateInitialColor7, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar7 = lerp( desaturateInitialColor7, desaturateDot7.xxx, _Saturation );
				float3 lerpResult9 = lerp( float3(0.5,0.5,0.5) , desaturateVar7 , _Contrast);
				

				finalColor = float4( lerpResult9 , 0.0 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-220.3544,203.4954;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-766.3544,225.4954;Inherit;False;Property;_Brightness;Brightness;0;0;Create;True;0;0;0;False;0;False;3;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-772.0985,-89.53043;Inherit;True;0;0;_MainTex;Pass;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-766.498,328.5628;Inherit;False;Property;_Saturation;Saturation;1;0;Create;True;0;0;0;False;0;False;0;-0.163;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;7;-54.15147,304.982;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;9;201.0175,354.892;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;591.481,188.275;Float;False;True;-1;2;ASEMaterialInspector;0;9;EasyImageEffect;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;True;0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-765.4315,437.8083;Inherit;False;Property;_Contrast;Contrast;2;0;Create;True;0;0;0;False;0;False;0;1.079;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;10;62.68793,114.2151;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-477.714,-211.4536;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-475.3392,2.968353;Inherit;True;Property;_AddTex;AddTex;3;0;Create;True;0;0;0;False;0;False;-1;None;14cd49417086b4c4f82f7601ab83b064;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;13;50.40123,-92.01381;Inherit;False;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
WireConnection;3;0;13;0
WireConnection;3;1;4;0
WireConnection;7;0;3;0
WireConnection;7;1;8;0
WireConnection;9;0;10;0
WireConnection;9;1;7;0
WireConnection;9;2;12;0
WireConnection;6;0;9;0
WireConnection;1;0;2;0
WireConnection;13;0;1;0
WireConnection;13;1;14;0
ASEEND*/
//CHKSM=F5E3824A03F8FA4F9DDE95396F488491094822B4