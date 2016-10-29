Shader "HAB/VertexLit/Transparent/Scrolling Bumpmap"
{
	Properties
	{
		[Header(Supports one directional light)]
		_MainTex ("Main (RGB)", 2D) = "white" {}
		_DispTex ("Displacement (RG)", 2D) = "white" {}
		_Scroll ("Main Scroll (X, Y) Bump Scroll (Z, W)", VECTOR) = (0, 0, 0, 0)
		_DispAmount ("Bump Amount", Range(0, 1)) = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
		}

		LOD 200
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
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
		// 		half2 texcoord : TEXCOORD0;
		// 		half2 texcoord2 : TEXCOORD1;
		// 		fixed3 lighting : TEXCOORD2;
		// 		LIGHTING_COORDS(3, 4)
		// 		#ifndef LIGHTMAP_OFF
        // 		float2 lmap : TEXCOORD5;
        // 		#endif				
		// 	};
			
		// 	sampler2D _MainTex;
		// 	float4 _MainTex_ST;
			
		// 	sampler2D _DispTex;
		// 	float4 _DispTex_ST;

		// 	float4 _Scroll;
			
		// 	fixed4 _LightColor0;

		// 	v2f vert (appdata_full v)
		// 	{
		// 		v2f o;
		// 		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

		// 		o.texcoord  = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
		// 		o.texcoord2 = v.texcoord * _DispTex_ST.xy + _DispTex_ST.zw;

		// 		o.texcoord.xy  += _Time.x * _Scroll.xy;
		// 		o.texcoord2.xy -= _Time.x * _Scroll.zw;
				
		// 		o.lighting = _LightColor0.rgb * max(0, dot(v.normal, ObjSpaceLightDir(v.vertex)));

		// 		TRANSFER_VERTEX_TO_FRAGMENT(o);

		// 		#ifndef LIGHTMAP_OFF
		// 		o.lmap = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
		// 		#endif

		// 		return o;
		// 	}

		// 	float _DispAmount;

		// 	fixed4 frag (v2f i) : COLOR
		// 	{
		// 		half2 disp = tex2D(_DispTex, i.texcoord2).rg * _DispAmount;
		// 		fixed4 color = tex2D(_MainTex, i.texcoord + disp);

		// 		#ifndef LIGHTMAP_OFF
        //     	fixed3 lm = DecodeLightmap (UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lmap));
        //     	color.rgb *= lm;
		// 		#else
		// 		fixed atten = LIGHT_ATTENUATION(i);
		// 		color.rgb *= i.lighting;
		// 		color.rgb *= atten;
        //     	#endif

		// 		return color;
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
				half2 texcoord : TEXCOORD0;
				half2 texcoord2 : TEXCOORD1;
				fixed3 lighting : TEXCOORD2;
				UNITY_FOG_COORDS(3)
			};
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			sampler2D _DispTex;
			float4 _DispTex_ST;

			float4 _Scroll;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

				o.texcoord  = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
				o.texcoord2 = v.texcoord * _DispTex_ST.xy + _DispTex_ST.zw;

				o.texcoord.xy  += _Time.x * _Scroll.xy;
				o.texcoord2.xy -= _Time.x * _Scroll.zw;
				
				o.lighting = ShadeVertexLightsFull(v.vertex, v.normal, 4, true);

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			float _DispAmount;

			fixed4 frag (v2f i) : COLOR
			{
				half2 disp = tex2D(_DispTex, i.texcoord2).rg * _DispAmount;
				fixed4 color = tex2D(_MainTex, i.texcoord + disp);
				color.rgb *= i.lighting;

				UNITY_APPLY_FOG(i.fogCoord, color);

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
			#include "AutoLight.cginc"			

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				half2 texcoord2 : TEXCOORD1;
				half2 lightmap : TEXCOORD2;
				UNITY_FOG_COORDS(3)
			};
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			sampler2D _DispTex;
			float4 _DispTex_ST;

			float4 _Scroll;

			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

				o.texcoord  = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
				o.texcoord2 = v.texcoord * _DispTex_ST.xy + _DispTex_ST.zw;

				o.texcoord.xy  += _Time.x * _Scroll.xy;
				o.texcoord2.xy -= _Time.x * _Scroll.zw;
				
				o.lightmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			float _DispAmount;

			fixed4 frag (v2f i) : COLOR
			{
				half2 disp = tex2D(_DispTex, i.texcoord2).rg * _DispAmount;
				fixed4 color = tex2D(_MainTex, i.texcoord + disp);
				
				fixed3 lmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmap));
				color.rgb *= lmap;

				UNITY_APPLY_FOG(i.fogCoord, color);
				
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
			#include "AutoLight.cginc"			

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				half2 texcoord2 : TEXCOORD1;
				half2 lightmap : TEXCOORD2;
				UNITY_FOG_COORDS(3)
			};
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			sampler2D _DispTex;
			float4 _DispTex_ST;

			float4 _Scroll;

			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

				o.texcoord  = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
				o.texcoord2 = v.texcoord * _DispTex_ST.xy + _DispTex_ST.zw;

				o.texcoord.xy  += _Time.x * _Scroll.xy;
				o.texcoord2.xy -= _Time.x * _Scroll.zw;
				
				o.lightmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			float _DispAmount;

			fixed4 frag (v2f i) : COLOR
			{
				half2 disp = tex2D(_DispTex, i.texcoord2).rg * _DispAmount;
				fixed4 color = tex2D(_MainTex, i.texcoord + disp);
				
				fixed3 lmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmap));
				color.rgb *= lmap;

				UNITY_APPLY_FOG(i.fogCoord, color);
				
				return color;
			}
			ENDCG
		}
	}
	
	
	Fallback "VertexLit"
}
