// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Watersurface"
{
	Properties
	{
		[HDR]_ReflectionTex("ReflectionTex", 2D) = "white" {}
		_NormalTiling("NormalTiling", Float) = 8
		_UnderwaterTiling("UnderwaterTiling", Float) = 4
		_SpecTint("SpecTint", Color) = (1,1,1,1)
		_SpecIntensity("SpecIntensity", Float) = 0.7
		_SpecEnd("SpecEnd", Float) = 200
		_SpecStart("SpecStart", Float) = 0
		_UnderWater("UnderWater", 2D) = "white" {}
		_WaterNormal("WaterNormal", 2D) = "bump" {}
		_WaterSpeed("Water Speed", Float) = 1
		_WaterNoise("WaterNoise", Float) = 1
		_WaterOffset("WaterOffset", Float) = 0
		_WaterDepth("WaterDepth", Float) = -1
		_NormalIntensity("NormalIntensity", Float) = 1
		_BlinkingTiling("BlinkingTiling", Float) = 8
		_BlinkSpeed("BlinkSpeed", Float) = 1
		_BlinkNoise("BlinkNoise", Float) = 5
		_BlinkThreshold("BlinkThreshold", Float) = 2
		_BlinkIntensity("BlinkIntensity", Float) = 5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float3 viewDir;
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _UnderWater;
		uniform float _UnderwaterTiling;
		uniform sampler2D _WaterNormal;
		uniform float _NormalTiling;
		uniform float _WaterSpeed;
		uniform float _NormalIntensity;
		uniform float _WaterDepth;
		uniform sampler2D _ReflectionTex;
		uniform float _WaterNoise;
		uniform float _WaterOffset;
		uniform float _BlinkingTiling;
		uniform float _BlinkSpeed;
		uniform float _BlinkNoise;
		uniform float _BlinkThreshold;
		uniform float _BlinkIntensity;
		uniform float4 _SpecTint;
		uniform float _SpecIntensity;
		uniform float _SpecEnd;
		uniform float _SpecStart;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_8_0 = ( (ase_worldPos).xz / _NormalTiling );
			float temp_output_11_0 = ( _Time.y * 0.1 * _WaterSpeed );
			float2 temp_output_29_0 = ( (( UnpackNormal( tex2D( _WaterNormal, ( temp_output_8_0 + temp_output_11_0 ) ) ) + UnpackScaleNormal( tex2D( _WaterNormal, ( ( temp_output_8_0 * 1.5 ) + ( temp_output_11_0 * -1.0 ) ) ), _NormalIntensity ) )).xy * 0.5 );
			float dotResult32 = dot( temp_output_29_0 , temp_output_29_0 );
			float3 appendResult36 = (float3(temp_output_29_0 , sqrt( ( 1.0 - dotResult32 ) )));
			float3 WaterNormal38 = (WorldNormalVector( i , appendResult36 ));
			float2 paralaxOffset121 = ParallaxOffset( 0 , _WaterDepth , i.viewDir );
			float4 UnderwaterColor108 = tex2D( _UnderWater, ( ( (ase_worldPos).xz / _UnderwaterTiling ) + ( (WaterNormal38).xz * 0.1 ) + paralaxOffset121 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos45 = UnityObjectToClipPos( ase_vertex3Pos );
			float2 temp_output_155_0 = ( (ase_worldPos).xz / _BlinkingTiling );
			float temp_output_152_0 = ( _Time.y * 0.1 * _BlinkSpeed );
			float2 temp_output_135_0 = ( (( UnpackNormal( tex2D( _WaterNormal, ( temp_output_155_0 + temp_output_152_0 ) ) ) + UnpackNormal( tex2D( _WaterNormal, ( ( temp_output_155_0 * 1.5 ) + ( temp_output_152_0 * -1.0 ) ) ) ) )).xy * 0.5 );
			float dotResult136 = dot( temp_output_135_0 , temp_output_135_0 );
			float3 appendResult138 = (float3(temp_output_135_0 , sqrt( ( 1.0 - dotResult136 ) )));
			float3 WaterNormalBlink144 = (WorldNormalVector( i , appendResult138 ));
			float4 temp_cast_0 = (_BlinkThreshold).xxxx;
			float4 ReflectionBlink165 = ( max( ( tex2D( _ReflectionTex, ( (ase_screenPosNorm).xy + ( (WaterNormalBlink144).xz * _BlinkNoise ) ) ) - temp_cast_0 ) , float4( 0,0,0,0 ) ) * _BlinkIntensity );
			float4 Reflection51 = ( tex2D( _ReflectionTex, ( (ase_screenPosNorm).xy + ( _WaterNoise * ( (WaterNormal38).xz / ( 1.0 + unityObjectToClipPos45.w ) ) ) + _WaterOffset ) ) + ReflectionBlink165 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult111 = dot( ase_worldNormal , ase_worldViewDir );
			float clampResult113 = clamp( dotResult111 , 0.0 , 1.0 );
			float temp_output_114_0 = ( 1.0 - clampResult113 );
			float clampResult129 = clamp( ( temp_output_114_0 + 0.2 ) , 0.0 , 1.0 );
			float4 lerpResult115 = lerp( UnderwaterColor108 , ( Reflection51 * clampResult129 ) , temp_output_114_0);
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult57 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult58 = dot( WaterNormal38 , normalizeResult57 );
			float clampResult81 = clamp( ( ( _SpecEnd - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( _SpecEnd - _SpecStart ) ) , 0.0 , 1.0 );
			float4 SpecColor68 = ( ( ( pow( max( dotResult58 , 0.0 ) , ( 0.1 * 256.0 ) ) * _SpecTint ) * _SpecIntensity ) * clampResult81 );
			c.rgb = ( lerpResult115 + SpecColor68 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 screenPos : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.CommentaryNode;174;-9313.439,1749.32;Inherit;False;2149.594;604.9198;Comment;14;161;162;163;164;165;166;167;168;171;176;177;178;179;180;ReflectBlink;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;159;-9317.761,819.3044;Inherit;False;2759.183;850.8184;Comment;26;144;137;138;133;132;136;135;143;142;145;141;157;151;150;152;139;140;147;146;148;155;154;134;156;153;149;Blink;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;124;-2984.352,958.3062;Inherit;False;1750.576;975.4653;Comment;14;104;105;107;106;118;117;120;116;122;119;123;121;108;103;Underwater;0,0.6853347,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;69;-2981.303,2024.997;Inherit;False;2342.585;1191.132;Comment;25;67;72;61;64;65;63;62;58;59;57;55;56;68;66;54;73;74;75;76;77;78;79;80;81;82;Specular Color;0.7924528,0.6177934,0.1537914,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;49;-2990.527,-721.6574;Inherit;False;2142.361;614.5202;Comment;16;2;16;4;42;40;41;18;46;45;47;48;51;1;102;182;183;Reflection;0.5252224,0.8584906,0.4176753,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2982.238,-8.091865;Inherit;False;3460.209;870.0378;Comment;27;9;12;13;14;11;10;8;21;23;22;24;20;19;5;27;30;29;32;34;35;37;36;38;6;7;44;130;Water Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;54;-2905.893,2084.69;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1131.977,2356.57;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2676.303,2214.998;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;55;-2968.303,2228.998;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;57;-2475.304,2213.998;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-2508.304,2098.998;Inherit;False;38;WaterNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;58;-2263.304,2139.998;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2303.304,2333.998;Inherit;False;Constant;_SpecSmoothness;SpecSmoothness;5;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-2015.681,2371.474;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;256;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;-1735.978,2505.57;Inherit;False;Property;_SpecTint;SpecTint;3;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0.9162779,0.5902965,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1463.764,2302.141;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;61;-1792.667,2240.341;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;72;-2030.146,2195.127;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1463.717,2530.645;Inherit;False;Property;_SpecIntensity;SpecIntensity;4;0;Create;True;0;0;0;False;0;False;0.7;1.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;73;-2860.449,2770.541;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;75;-2923.449,2909.541;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;78;-2326.75,2842.641;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;79;-2327.048,2957.039;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;80;-2145.484,2906.136;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;81;-1946.484,2906.136;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-2581.449,2757.54;Inherit;False;Property;_SpecEnd;SpecEnd;5;0;Create;True;0;0;0;False;0;False;200;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;74;-2552.449,2870.541;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-2574.449,3000.54;Inherit;False;Property;_SpecStart;SpecStart;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-993.8799,2756.782;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-908.5417,2359.583;Inherit;True;SpecColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;104;-2692.148,1008.306;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;105;-2476.649,1026.706;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-2690.222,1190.042;Inherit;False;Property;_UnderwaterTiling;UnderwaterTiling;2;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;106;-2293.085,1140.056;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-2456.352,1408.394;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-2934.352,1376.394;Inherit;False;38;WaterNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;120;-2694.352,1377.394;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;116;-2156.352,1344.394;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;122;-2561.128,1706.771;Inherit;True;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;119;-2530.352,1615.394;Inherit;False;Property;_WaterDepth;WaterDepth;12;0;Create;True;0;0;0;False;0;False;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-2673.128,1487.771;Inherit;False;Constant;_Float5;Float 5;17;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;121;-2262.128,1592.771;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-1507.777,1335.527;Inherit;True;UnderwaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;103;-1920.278,1319.315;Inherit;True;Property;_UnderWater;UnderWater;7;0;Create;True;0;0;0;False;0;False;-1;453f0c345bf35cc49a87fc55742a2353;453f0c345bf35cc49a87fc55742a2353;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;110;-537.9402,-757.7646;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;112;-538.9402,-608.7651;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;71;-73.2468,-765.2441;Inherit;False;68;SpecColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;111;-306.9403,-674.7648;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;113;-131.6629,-546.753;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-73.49831,-692.6118;Inherit;False;108;UnderwaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-72.37331,-620.7717;Inherit;False;51;Reflection;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;114;3.059972,-500.7651;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;128;195.9624,-437.1209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;129;343.9624,-449.1209;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;520.479,-434.979;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;115;712.9332,-539.4675;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;869.4595,-770.2228;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1067.305,-835.4062;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Watersurface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.OneMinusNode;34;-559.2592,769.9259;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;35;-366.1753,767.0017;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2621.332,729.0513;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-929.0304,621.6581;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;32;-742.0302,702.6575;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;37;-18.18227,627.6421;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;36;-187.366,633.9861;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2441.335,642.1616;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-2077.608,555.3054;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;44;-1208.055,448.4714;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1211.581,591.2449;Inherit;False;Constant;_Float3;Float 3;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;123.1829,323.2846;Inherit;False;WaterNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-1416.013,450.7726;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2873.162,375.0804;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2371.78,395.3426;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-2913.878,517.9797;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2913.878,597.9791;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2917.524,681.2016;Inherit;False;Property;_WaterSpeed;Water Speed;9;0;Create;True;0;0;0;False;0;False;1;1.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2698.383,596.7509;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;6;-2909.822,41.90839;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;7;-2694.323,60.30838;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2861.896,242.6441;Inherit;False;Property;_NormalTiling;NormalTiling;1;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2070.718,390.7817;Inherit;False;Property;_NormalIntensity;NormalIntensity;13;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;46;-2940.527,-303.1616;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;41;-2704.293,-474.3123;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-2945.323,-473.6123;Inherit;False;38;WaterNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;4;-2697.226,-662.4431;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-2947.037,-668.2284;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-1121.443,-582.3273;Inherit;False;Reflection;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1599.804,-613.4153;Inherit;True;Property;_ReflectionTex;ReflectionTex;0;1;[HDR];Create;True;0;0;0;False;0;False;-1;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1835.026,-649.1673;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2345.109,-525.8275;Inherit;False;Property;_WaterNoise;WaterNoise;10;0;Create;True;0;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;45;-2726.545,-308.737;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-2472.867,-279.5958;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-2087.272,-525.4805;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;48;-2308.087,-449.5333;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-1844.324,-457.779;Inherit;False;Property;_WaterOffset;WaterOffset;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;338.2258,-241.0552;Inherit;False;165;ReflectionBlink;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-2226.664,229.7741;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;-2490.759,232.6585;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;164;-9263.439,1799.32;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;162;-9270.647,1984.002;Inherit;False;144;WaterNormalBlink;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;163;-9022.667,1800.09;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;161;-9011.361,1982.457;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-9038.568,1538.447;Inherit;False;Constant;_Float6;Float 2;5;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;154;-9046.56,898.7043;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;155;-8864.996,1010.054;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;148;-8551.358,1010.7;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-8854.398,1256.476;Inherit;False;Constant;_Float8;Float 1;5;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-8664.017,1234.739;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;-8483.995,1354.733;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-8660.572,1420.558;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-8936.62,1405.147;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-1814.839,433.5494;Inherit;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;5;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1818.18,196.2726;Inherit;True;Property;_WaterNormal;WaterNormal;8;0;Create;True;0;0;0;False;0;False;-1;bc2602d7a141b5e4c8ac590500d13fe2;bc2602d7a141b5e4c8ac590500d13fe2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;176;-8339.814,2044.595;Inherit;False;Property;_BlinkThreshold;BlinkThreshold;17;0;Create;True;0;0;0;False;0;False;2;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-7518.671,2185.091;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;165;-7427.425,1915.273;Inherit;False;ReflectionBlink;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;167;-8529.421,1814.401;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-8777.779,1984.27;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;-7945.023,1018.66;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;142;-7780.319,1022.125;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-7896.301,1185.083;Inherit;False;Constant;_Float7;Float 3;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;-7665.651,1192.429;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;136;-7487.299,1302.263;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;132;-7336.247,1401.25;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;133;-7143.163,1398.326;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;138;-6998.967,1193.223;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;153;-9280.611,889.8554;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;156;-9276.069,1054.056;Inherit;False;Property;_BlinkingTiling;BlinkingTiling;14;0;Create;True;0;0;0;False;0;False;8;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;149;-9268.682,1340.809;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-9270.965,1427.658;Inherit;False;Constant;_Float9;Float 0;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-9269.044,1510.881;Inherit;False;Property;_BlinkSpeed;BlinkSpeed;15;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;137;-6829.773,1194.185;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-6834.188,1361.079;Inherit;False;WaterNormalBlink;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-9272.62,2085.703;Inherit;False;Property;_BlinkNoise;BlinkNoise;16;0;Create;True;0;0;0;False;0;False;5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;157;-8306.849,994.7203;Inherit;True;Property;_WaterNormal2;WaterNormal;8;0;Create;True;0;0;0;False;0;False;-1;bc2602d7a141b5e4c8ac590500d13fe2;bc2602d7a141b5e4c8ac590500d13fe2;True;0;True;bump;Auto;True;Instance;5;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;141;-8304.327,1364.009;Inherit;True;Property;_TextureSample1;Texture Sample 0;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;5;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;177;-7908.565,2019.858;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-7955.671,2215.091;Inherit;False;Property;_BlinkIntensity;BlinkIntensity;18;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;178;-7725.25,2060.079;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-1276.721,-414.4956;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-1546.721,-310.4957;Inherit;False;165;ReflectionBlink;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;166;-8270.287,1815.975;Inherit;True;Property;_ReflectionTex1;ReflectionTex;0;1;[HDR];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;66;0;64;0
WireConnection;66;1;67;0
WireConnection;56;0;54;0
WireConnection;56;1;55;0
WireConnection;57;0;56;0
WireConnection;58;0;59;0
WireConnection;58;1;57;0
WireConnection;63;0;62;0
WireConnection;64;0;61;0
WireConnection;64;1;65;0
WireConnection;61;0;72;0
WireConnection;61;1;63;0
WireConnection;72;0;58;0
WireConnection;78;0;76;0
WireConnection;78;1;74;0
WireConnection;79;0;76;0
WireConnection;79;1;77;0
WireConnection;80;0;78;0
WireConnection;80;1;79;0
WireConnection;81;0;80;0
WireConnection;74;0;73;0
WireConnection;74;1;75;0
WireConnection;82;0;66;0
WireConnection;82;1;81;0
WireConnection;68;0;82;0
WireConnection;105;0;104;0
WireConnection;106;0;105;0
WireConnection;106;1;107;0
WireConnection;118;0;120;0
WireConnection;118;1;123;0
WireConnection;120;0;117;0
WireConnection;116;0;106;0
WireConnection;116;1;118;0
WireConnection;116;2;121;0
WireConnection;121;1;119;0
WireConnection;121;2;122;0
WireConnection;108;0;103;0
WireConnection;103;1;116;0
WireConnection;111;0;110;0
WireConnection;111;1;112;0
WireConnection;113;0;111;0
WireConnection;114;0;113;0
WireConnection;128;0;114;0
WireConnection;129;0;128;0
WireConnection;125;0;52;0
WireConnection;125;1;129;0
WireConnection;115;0;109;0
WireConnection;115;1;125;0
WireConnection;115;2;114;0
WireConnection;70;0;115;0
WireConnection;70;1;71;0
WireConnection;0;13;70;0
WireConnection;34;0;32;0
WireConnection;35;0;34;0
WireConnection;29;0;44;0
WireConnection;29;1;30;0
WireConnection;32;0;29;0
WireConnection;32;1;29;0
WireConnection;37;0;36;0
WireConnection;36;0;29;0
WireConnection;36;2;35;0
WireConnection;23;0;11;0
WireConnection;23;1;24;0
WireConnection;20;0;21;0
WireConnection;20;1;23;0
WireConnection;44;0;27;0
WireConnection;38;0;37;0
WireConnection;27;0;5;0
WireConnection;27;1;19;0
WireConnection;21;0;8;0
WireConnection;21;1;22;0
WireConnection;11;0;12;0
WireConnection;11;1;13;0
WireConnection;11;2;14;0
WireConnection;7;0;6;0
WireConnection;41;0;40;0
WireConnection;4;0;2;0
WireConnection;51;0;182;0
WireConnection;1;1;16;0
WireConnection;16;0;4;0
WireConnection;16;1;42;0
WireConnection;16;2;102;0
WireConnection;45;0;46;0
WireConnection;47;1;45;4
WireConnection;42;0;18;0
WireConnection;42;1;48;0
WireConnection;48;0;41;0
WireConnection;48;1;47;0
WireConnection;10;0;8;0
WireConnection;10;1;11;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;163;0;164;0
WireConnection;161;0;162;0
WireConnection;154;0;153;0
WireConnection;155;0;154;0
WireConnection;155;1;156;0
WireConnection;148;0;155;0
WireConnection;148;1;152;0
WireConnection;147;0;155;0
WireConnection;147;1;146;0
WireConnection;140;0;147;0
WireConnection;140;1;139;0
WireConnection;139;0;152;0
WireConnection;139;1;134;0
WireConnection;152;0;149;0
WireConnection;152;1;150;0
WireConnection;152;2;151;0
WireConnection;19;1;20;0
WireConnection;19;5;130;0
WireConnection;5;1;10;0
WireConnection;179;0;178;0
WireConnection;179;1;180;0
WireConnection;165;0;179;0
WireConnection;167;0;163;0
WireConnection;167;1;171;0
WireConnection;171;0;161;0
WireConnection;171;1;168;0
WireConnection;145;0;157;0
WireConnection;145;1;141;0
WireConnection;142;0;145;0
WireConnection;135;0;142;0
WireConnection;135;1;143;0
WireConnection;136;0;135;0
WireConnection;136;1;135;0
WireConnection;132;0;136;0
WireConnection;133;0;132;0
WireConnection;138;0;135;0
WireConnection;138;2;133;0
WireConnection;137;0;138;0
WireConnection;144;0;137;0
WireConnection;157;1;148;0
WireConnection;141;1;140;0
WireConnection;177;0;166;0
WireConnection;177;1;176;0
WireConnection;178;0;177;0
WireConnection;182;0;1;0
WireConnection;182;1;183;0
WireConnection;166;1;167;0
ASEEND*/
//CHKSM=F2B3393F36F05D80AEF9B599A4BFC6C5AA40F2F8