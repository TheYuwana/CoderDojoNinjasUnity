Shader "HAB/VertexLit/Sphere Reflection" 
{
	Properties 
	{
		_MainTex ("Main (RGB)", 2D) = "black" {}
		_SpecTex ("Spec (RGB)", 2D) = "black" {}
		_ReflColor   ("Reflection Color", COLOR) = (1, 1, 1, 1)
	}

	SubShader 
	{
		Tags
		{ 
			"Queue" = "Geometry"
			"RenderType" = "Opaque"  
		}

		LOD 400
		
		// Pass 
		// {
		// 	Tags
		// 	{ 
		// 		"LightMode" = "ForwardBase"
		// 	}
			
		// 	CGPROGRAM
		// 	#pragma vertex vert
		// 	#pragma fragment frag
		// 	#pragma multi_compile_fwdbase
		// 	#pragma fragmentoption ARB_precision_hint_fastest 

		// 	#include "UnityCG.cginc"
		// 	#include "AutoLight.cginc"			
			
		// 	sampler2D _MainTex;
		// 	sampler2D _SpecTex;
		// 	fixed4 _ReflColor;
		// 	fixed4 _LightColor0;

		// 	struct v2f 
		// 	{
		// 		float4 pos : SV_POSITION;
		// 		half2 texcoord : TEXCOORD0;
		// 		half2 texcoord2 : TEXCOORD1;
		// 		fixed3 lighting : TEXCOORD2;
				
		// 		LIGHTING_COORDS(3, 4)

		// 		#ifndef LIGHTMAP_OFF
        // 		float2 lmap : TEXCOORD5;
        // 		#endif				
		// 	};
			
		// 	v2f vert (appdata_full v)
		// 	{
		// 		v2f o;
								
		// 		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		// 		o.texcoord = v.texcoord;
				
		// 		// Sphere mapping
		// 		half3 u = normalize(mul(UNITY_MATRIX_MV, v.vertex).xyz);
		// 		half3 n = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
		// 		half3 r = reflect(u, n);
		// 		half m = 2.0 * sqrt(r.x * r.x + r.y * r.y + (r.z + 1.0) * (r.z + 1.0));				
		// 		o.texcoord2.x = r.x/m + 0.5;
		// 		o.texcoord2.y = r.y/m + 0.5;
				
		// 		o.lighting = _LightColor0.rgb * max(0, dot(v.normal, ObjSpaceLightDir(v.vertex)));

		// 		TRANSFER_VERTEX_TO_FRAGMENT(o);
				
		// 		#ifndef LIGHTMAP_OFF
		// 		o.lmap = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
		// 		#endif
						
		// 		return o;
		// 	}

		// 	fixed4 frag (v2f i) : COLOR
		// 	{
		// 		fixed4 color = tex2D(_MainTex, i.texcoord);

		// 		#ifndef LIGHTMAP_OFF
        //     	fixed3 lm = DecodeLightmap (UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lmap));
        //     	color.rgb *= lm;
		// 		#else
		// 		fixed atten = LIGHT_ATTENUATION(i);
		// 		color.rgb *= i.lighting;
		// 		color.rgb *= atten;
        //     	#endif

		// 		fixed3 emissive = tex2D(_SpecTex, i.texcoord2).rgb * _ReflColor.rgb;
		// 		color.rgb += emissive;
				
		// 		return color;
		// 	}
		// 	ENDCG			
		// }		
		
		Pass 
		{
			Tags
			{ 
				"LightMode" = "Vertex"
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest 

			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _SpecTex;
			fixed4 _ReflColor;

			struct v2f 
			{
				float4 pos : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				half2 texcoord2 : TEXCOORD1;
				fixed3 lighting : TEXCOORD2;
				UNITY_FOG_COORDS(3)			
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
								
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				
				// Sphere mapping
				half3 u = normalize(mul(UNITY_MATRIX_MV, v.vertex).xyz);
				half3 n = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
				half3 r = reflect(u, n);
				half m = 2.0 * sqrt(r.x * r.x + r.y * r.y + (r.z + 1.0) * (r.z + 1.0));				
				o.texcoord2.x = r.x/m + 0.5;
				o.texcoord2.y = r.y/m + 0.5;
				
				o.lighting = ShadeVertexLightsFull(v.vertex, v.normal, 4, true);

				UNITY_TRANSFER_FOG(o, o.pos);				

				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 color = tex2D(_MainTex, i.texcoord);
				fixed3 emissive = tex2D(_SpecTex, i.texcoord2).rgb * _ReflColor.rgb;
				
				color.rgb *= i.lighting;
				color.rgb += emissive;

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
				"LightMode" = "VertexLMRGBM"
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest 

			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _SpecTex;
			fixed4 _ReflColor;

			struct v2f 
			{
				float4 pos : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				half2 texcoord2 : TEXCOORD1;
				half2 lightmap : TEXCOORD2;
				UNITY_FOG_COORDS(3)
			};
			
			v2f vert (appdata_full v)
			{
				v2f o;
								
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				
				// Sphere mapping
				half3 u = normalize(mul(UNITY_MATRIX_MV, v.vertex).xyz);
				half3 n = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
				half3 r = reflect(u, n);
				half m = 2.0 * sqrt(r.x * r.x + r.y * r.y + (r.z + 1.0) * (r.z + 1.0));				
				o.texcoord2.x = r.x/m + 0.5;
				o.texcoord2.y = r.y/m + 0.5;
				
				o.lightmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 color = tex2D(_MainTex, i.texcoord);
				fixed3 emissive = tex2D(_SpecTex, i.texcoord2).rgb * _ReflColor.rgb;
				
				fixed3 lmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmap));
				color.rgb *= lmap;
				color.rgb += emissive;

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
				"LightMode" = "VertexLM"
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest 

			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _SpecTex;
			fixed4 _ReflColor;

			struct v2f 
			{
				float4 pos : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				half2 texcoord2 : TEXCOORD1;
				half2 lightmap : TEXCOORD2;
				UNITY_FOG_COORDS(3)
			};
			
			v2f vert (appdata_full v)
			{
				v2f o;
								
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				
				// Sphere mapping
				half3 u = normalize(mul(UNITY_MATRIX_MV, v.vertex).xyz);
				half3 n = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
				half3 r = reflect(u, n);
				half m = 2.0 * sqrt(r.x * r.x + r.y * r.y + (r.z + 1.0) * (r.z + 1.0));				
				o.texcoord2.x = r.x/m + 0.5;
				o.texcoord2.y = r.y/m + 0.5;
				
				o.lightmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 color = tex2D(_MainTex, i.texcoord);
				fixed3 emissive = tex2D(_SpecTex, i.texcoord2).rgb * _ReflColor.rgb;
				
				fixed3 lmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmap));
				color.rgb *= lmap;
				color.rgb += emissive;

				UNITY_APPLY_FOG(i.fogCoord, color);
				UNITY_OPAQUE_ALPHA(color.a);
				
				return color;
			}
			ENDCG			
		}
	} 
	Fallback "VertexLit"
}
