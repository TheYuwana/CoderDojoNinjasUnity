Shader "HAB/Unlit/Vertex Hemispherical Shaded"
{
	Properties
	{
		[Header(Lighting parameters)]
		_Color ("Color", COLOR) = (1, 1, 1, 1)
		_ColorSky ("Color Sky", COLOR) = (1, 1, 1, 1)
		_ColorGround ("Color Ground", COLOR) = (1, 1, 1, 1)
		_ColorRim ("Color Rim", COLOR) = (1, 1, 1, 1)

		_SkyNormal ("Sky Direction", VECTOR) = (0, 1, 0, 0)

		_MainTex ("Main (RGB)", 2D) = "white" {}

		_RimPower ("Rim Power", FLOAT) = 1
		_RimSpread ("Rim Spread", FLOAT) = 1
	}

	SubShader
	{
		Tags
		{
			"Queue"="Geometry"
			"RenderType"="Opaque"
		}

		LOD 200

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			fixed4 _MainTex_ST;
			fixed4 _SkyNormal;
			fixed4 _ColorRim;
			fixed4 _ColorSky;
			fixed4 _ColorGround;

			fixed4 _Color;

			sampler2D _MainTex;

			half _RimPower;
			half _RimSpread;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				fixed3 hemiFactor : TEXCOORD1;
				fixed3 rimColor : TEXCOORD2;
				UNITY_FOG_COORDS(3)
			};

			v2f vert (appdata_tan v)
			{
				v2f o;

				o.pos = mul (UNITY_MATRIX_MVP, v.vertex) ;
				o.texcoord = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;

				fixed ground = dot(UnityObjectToWorldNormal(v.normal), normalize(_SkyNormal.xyz));
				o.hemiFactor = lerp(_ColorGround, _ColorSky, (ground + 1) / 2).rgb;

				fixed rim = dot(normalize(ObjSpaceViewDir(v.vertex)), v.normal);
				rim = _RimPower * pow(rim, _RimSpread);
				rim = saturate(rim);

				o.rimColor = (1 - rim) * _ColorRim.rgb;

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed3 tex = tex2D(_MainTex, i.texcoord).rgb;

				fixed4 color = fixed4(tex * i.hemiFactor + i.rimColor, 1);

				UNITY_APPLY_FOG(i.fogCoord, color);
				UNITY_OPAQUE_ALPHA(color.a);

				return color;
			}
			ENDCG
		}
	}
	Fallback "VertexLit"
}
