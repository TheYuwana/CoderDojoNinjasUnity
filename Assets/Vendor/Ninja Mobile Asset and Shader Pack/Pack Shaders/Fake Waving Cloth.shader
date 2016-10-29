Shader "HAB/VertexLit/Fake Waving Cloth"
{
	Properties
	{
		[Header(Moves local xz axis)]
		[Header(Shader will ignore batching)]
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Amplitude ("Amplitude (x, y)", VECTOR) = (1, 1, 0, 0)
		_Tiling ("Wave Size (x, y)", VECTOR) = (1, 1, 0, 0)
		_Speed ("Wave Speed (x, y)", VECTOR) = (1, 1, 0, 0)
		_ShadowStrength ("Shadow Strength", Range(0, 1)) = 0.5
	}

	SubShader
	{
		Tags
		{
			"Queue"="Geometry"
			"RenderType"="Opaque"
			"DisableBatching"="True"
		}

		LOD 200

		// Pass
		// {
		// 	Tags
		// 	{
		// 		"LightMode"="ForwardBase"
		// 	}

		// 	CGPROGRAM
		// 	#pragma vertex vert
		// 	#pragma fragment frag
		// 	#pragma multi_compile_fwdbase
		// 	#pragma fragmentoption ARB_precision_hint_fastest
		// 	#include "UnityCG.cginc"
		// 	#include "AutoLight.cginc"

		// 	struct v2f
		// 	{
		// 		float4 pos : POSITION;
		// 		float2 texcoord : TEXCOORD0;
		// 		fixed3 lighting : TEXCOORD1;

		// 		LIGHTING_COORDS(2,3)

		// 		#ifndef LIGHTMAP_OFF
        // 		float2 lmap : TEXCOORD4;
        // 		#endif
		// 	};

		// 	sampler2D _MainTex;
		// 	float4 _MainTex_ST;

		// 	fixed4 _Amplitude;
		// 	fixed4 _Speed;
		// 	fixed4 _Tiling;

		// 	fixed4 _LightColor0;

		// 	v2f vert (appdata_full v)
		// 	{
		// 		v2f o;

		// 		float3 wavePos = float3(0, 0, 0);

		// 		wavePos.x = sin(_Speed.x * _Time.z + v.vertex.z / _Tiling.x) * _Amplitude.x;
		// 		wavePos.y = cos(_Speed.y * _Time.z + v.vertex.x / _Tiling.y) * _Amplitude.y;

		// 		v.vertex.xy += wavePos;

		// 		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

		// 		o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);

		// 		o.lighting = _LightColor0.rgb * max(0, dot(v.normal, ObjSpaceLightDir(v.vertex)));
		// 		o.lighting -= wavePos.y * wavePos.x * 2;

		// 		TRANSFER_VERTEX_TO_FRAGMENT(o);

		// 		#ifndef LIGHTMAP_OFF
		// 		o.lmap = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
		// 		#endif
		// 		return o;
		// 	}

		// 	fixed4 frag (v2f i) : COLOR
		// 	{
		// 		fixed4 color = tex2D(_MainTex, i.texcoord);
		// 		fixed atten = LIGHT_ATTENUATION(i);

		// 		#ifndef LIGHTMAP_OFF
        //     	fixed3 lm = DecodeLightmap (UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lmap));
        //     	color.rgb *= lm;
		// 		#else
		// 		color.rgb *= i.lighting;
        //     	#endif

		// 		return color * atten;
		// 	}
		// 	ENDCG
		// }
		// Pass
		// {
		// 	Name "ShadowCaster"
		// 	Tags
		// 	{
		// 		"LightMode"="ShadowCaster"
		// 	}
        // 	Fog
		// 	{
		// 		Mode Off
		// 	}
		// 	Cull Off ZTest LEqual Offset 1, 1
		// 	CGPROGRAM
		// 	#pragma vertex vert
		// 	#pragma fragment frag
		// 	#pragma multi_compile_shadowcaster
		// 	#include "UnityCG.cginc"

		// 	struct v2f
		// 	{
		// 		V2F_SHADOW_CASTER;
		// 	};

		// 	fixed4 _Amplitude;
		// 	fixed4 _Speed;
		// 	fixed4 _Tiling;

		// 	v2f vert (appdata_base v)
		// 	{
		// 		float3 wavePos = float3(0, 0, 0);
		// 		wavePos.x = sin(_Speed.x * _Time.z + v.vertex.z / _Tiling.x) * _Amplitude.x;
		// 		wavePos.y = cos(_Speed.y * _Time.z + v.vertex.x / _Tiling.y) * _Amplitude.y;
		// 		v.vertex.xy += wavePos;

		// 		v2f o;
		// 		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		// 		TRANSFER_SHADOW_CASTER(o)
		// 		return o;
		// 	}

		// 	fixed4 frag (v2f i) : COLOR
		// 	{
		// 		SHADOW_CASTER_FRAGMENT(i)
		// 	}
		// 	ENDCG
		// }
		// Pass
		// {
		// 	Name "ShadowCollector"
		// 	Tags
		// 	{
		// 		"LightMode"="ShadowCollector"
		// 	}
        // 	Fog
		// 	{
		// 		Mode Off
		// 	}


		// 	CGPROGRAM
		// 	#pragma vertex vert
		// 	#pragma fragment frag
		// 	#pragma multi_compile_shadowcollector

		// 	#define SHADOW_COLLECTOR_PASS
		// 	#include "UnityCG.cginc"

		// 	struct v2f
		// 	{
		// 		V2F_SHADOW_COLLECTOR;
		// 	};

		// 	fixed4 _Amplitude;
		// 	fixed4 _Speed;
		// 	fixed4 _Tiling;

		// 	v2f vert (appdata_base v)
		// 	{
		// 		v2f o;

		// 		float3 wavePos = float3(0, 0, 0);
		// 		wavePos.x = sin(_Speed.x * _Time.z + v.vertex.z / _Tiling.x) * _Amplitude.x;
		// 		wavePos.y = cos(_Speed.y * _Time.z + v.vertex.x / _Tiling.y) * _Amplitude.y;

		// 		v.vertex.xy += wavePos;
		// 		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

 		// 		TRANSFER_SHADOW_COLLECTOR(o)
		// 		return o;
		// 	}

		// 	fixed4 frag (v2f i) : COLOR
		// 	{
    	// 		SHADOW_COLLECTOR_FRAGMENT(i)
		// 	}
		// 	ENDCG
		// }

		Pass
		{
			Tags
			{
				"LightMode"="Vertex"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				fixed3 lighting : TEXCOORD1;
				UNITY_FOG_COORDS(2)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			fixed4 _Amplitude;
			fixed4 _Speed;
			fixed4 _Tiling;

			fixed _ShadowStrength;

			v2f vert (appdata_base v)
			{
				v2f o;

				float3 wavePos = float3(0, 0, 0);

				wavePos.x = sin(_Speed.x * _Time.z + v.vertex.z / _Tiling.x) * _Amplitude.x;
				wavePos.y = cos(_Speed.y * _Time.z + v.vertex.x / _Tiling.y) * _Amplitude.y;

				v.vertex.xy += wavePos;

				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);

				o.lighting = ShadeVertexLightsFull(v.vertex, v.normal, 4, true);
				o.lighting -= wavePos.y * wavePos.x * _ShadowStrength;

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 color = tex2D(_MainTex, i.texcoord);
				color.rgb *= i.lighting;

				UNITY_APPLY_FOG(i.fogCoord, color);
				UNITY_OPAQUE_ALPHA(color.a);

				return color;
			}
			ENDCG
		}
		Pass
		{
			Tags
			{
				"LightMode"="VertexLMRGBM"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				half2 lightmap : TEXCOORD1;
				UNITY_FOG_COORDS(2)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			fixed4 _Amplitude;
			fixed4 _Speed;
			fixed4 _Tiling;

			v2f vert (appdata_full v)
			{
				v2f o;

				float3 wavePos = float3(0, 0, 0);

				wavePos.x = sin(_Speed.x * _Time.z + v.vertex.z / _Tiling.x) * _Amplitude.x;
				wavePos.y = cos(_Speed.y * _Time.z + v.vertex.x / _Tiling.y) * _Amplitude.y;

				v.vertex.xy += wavePos;

				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);

				o.lightmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 color = tex2D(_MainTex, i.texcoord);

				fixed3 lmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmap));
				color.rgb *= lmap;

				UNITY_APPLY_FOG(i.fogCoord, color);
				UNITY_OPAQUE_ALPHA(color.a);

				return color;
			}
			ENDCG
		}
		Pass
		{
			Tags
			{
				"LightMode"="VertexLM"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				half2 lightmap : TEXCOORD1;
				UNITY_FOG_COORDS(2)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			fixed4 _Amplitude;
			fixed4 _Speed;
			fixed4 _Tiling;

			v2f vert (appdata_full v)
			{
				v2f o;

				float3 wavePos = float3(0, 0, 0);

				wavePos.x = sin(_Speed.x * _Time.z + v.vertex.z / _Tiling.x) * _Amplitude.x;
				wavePos.y = cos(_Speed.y * _Time.z + v.vertex.x / _Tiling.y) * _Amplitude.y;

				v.vertex.xy += wavePos;

				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);

				o.lightmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 color = tex2D(_MainTex, i.texcoord);

				fixed3 lmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmap));
				color.rgb *= lmap;

				UNITY_APPLY_FOG(i.fogCoord, color);
				UNITY_OPAQUE_ALPHA(color.a);

				return color;
			}
			ENDCG
		}
	}
	Fallback Off
}
