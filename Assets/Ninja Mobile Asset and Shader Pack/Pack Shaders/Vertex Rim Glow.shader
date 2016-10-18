Shader "HAB/Unlit/Transparent/Vertex Rim Glow"
{
	Properties
	{
		_Color   ("Glow Color", COLOR) = (1, 1, 1, 1)
		_RimSpread ("Rim Spread", FLOAT) = 1
		_RimPower ("Rim Power", FLOAT) = 1
		_Scale ("Glow Scale", FLOAT) = 1
	}

	SubShader
	{


		Tags
		{
			"RenderType"="Transparent"
			"Queue"="Transparent"
		}

		LOD 200

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			fixed4 _Color;
			float _RimPower;
			float _RimSpread;
			fixed _Scale;

			struct v2f
			{
				float4 pos : SV_POSITION;
				half rim : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			v2f vert (appdata_tan v)
			{
				v2f o;
				v.vertex.xyz *= _Scale;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

				half rim = dot(normalize(v.normal), normalize(ObjSpaceViewDir(v.vertex)));
				rim = _RimPower * max(0.5, pow(rim, _RimSpread));
				rim = 1 - saturate(rim);

				o.rim = rim;

				UNITY_TRANSFER_FOG(o, o.pos);

				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 color = fixed4(_Color.rgb, i.rim);

				UNITY_APPLY_FOG(i.fogCoord, color);

				return color;
			}
			ENDCG
		}

		ZWrite On
		Pass
		{
			ColorMask 0
		}

	}
	Fallback Off
}
