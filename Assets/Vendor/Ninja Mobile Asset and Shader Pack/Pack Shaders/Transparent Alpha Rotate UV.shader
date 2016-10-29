Shader "HAB/Unlit/Transparent/Colored Rotate UV"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "white" {}
		_Angle ("Rotation Speed", FLOAT) = 0
		_Offset ("Pivot", VECTOR) = (0.5, 0.5, 0, 0)
	}
	
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		LOD 200
		
		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			float _Angle;
			
			float2 _Offset;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				
				float rads = _Time.y * _Angle * 0.0174533;
				float sinX = sin (rads);
				float cosX = cos (rads);
				float sinY = sin (rads);
				float2x2 rotationMatrix = float2x2( cosX, -sinX, sinY, cosX);					
				
				float2 uv = v.texcoord.xy - _Offset;
				uv = mul(uv, rotationMatrix);
				uv += _Offset;
				
				o.texcoord = TRANSFORM_TEX(uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				return col;
			}
			ENDCG
		}
	}
	Fallback Off
}
