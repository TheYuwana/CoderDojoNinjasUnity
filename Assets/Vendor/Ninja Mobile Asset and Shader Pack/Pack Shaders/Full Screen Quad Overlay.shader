Shader "HAB/Unlit/Transparent/Full Screen Quad Overlay" 
{
	Properties 
	{
		[Header(Renders a full screen quad)]
		_MainTex ("Main (RGBA)", 2D) = "white" {}
		_ScrollSpeed ("Scroll Speed (X, Y)", VECTOR) = (0, 0, 0, 0)
		_Fade ("Transparency", RANGE(0, 1)) = 0
	}

	SubShader 
	{
		Tags 
		{
			"RenderType"="Transparent" 
			"Queue"="Overlay"
		}
		ZWrite off
		Cull off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass 
		{
			Name "NORMAL"
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			struct v2f 
			{
				float4 pos : POSITION;
				half2 texcoord : TEXCOORD0; 
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Fade;
			float4 _ScrollSpeed;

			v2f vert (appdata_base v)
			{
				v2f o;

				float screenRatio = _ScreenParams.y / _ScreenParams.x;

				float2 pos = (v.texcoord.xy - 0.5) * 2;
				pos.y /= screenRatio;
				
				o.pos = float4(pos, 0, 1);

				o.texcoord = v.texcoord * 2 - 0.5;

				o.texcoord.xy *= _MainTex_ST.xy;
				o.texcoord += _MainTex_ST.zw;
				
				o.texcoord = o.texcoord + _Time.x * _ScrollSpeed.xy;

				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 col = tex2D(_MainTex, i.texcoord.xy);
				col.a *= _Fade;
				
				return col;
			}
			ENDCG
		}
	}
	Fallback Off
}
