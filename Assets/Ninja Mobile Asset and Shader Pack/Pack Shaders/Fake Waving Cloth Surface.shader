Shader "HAB/Surface/Fake Waving Cloth" 
{
	Properties 
	{
		[Header(More expensive surface shader)]
		[Header(Moves local xz axis)]
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Amplitude ("Amplitude (x, y)", VECTOR) = (1, 1, 0, 0)
		_Tiling ("Wave Size (x, y)", VECTOR) = (1, 1, 0, 0)
		_Speed ("Wave Speed (x, y)", VECTOR) = (1, 1, 0, 0)
	}
	
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert addshadow

		sampler2D _MainTex;
		
		fixed4 _Amplitude;
		fixed4 _Speed;
		fixed4 _Tiling;

		struct Input 
		{
			float2 uv_MainTex;
			float tint;
		};
		
		void vert (inout appdata_full v, out Input o) 
		{
         	UNITY_INITIALIZE_OUTPUT(Input, o);
			 
          	float3 wavePos = float3(0, 0, 0);
				
			wavePos.x = sin(_Speed.x * _Time.z + v.vertex.z / _Tiling.x) * _Amplitude.x;
			wavePos.y = cos(_Speed.y * _Time.z + v.vertex.x / _Tiling.y) * _Amplitude.y;
			
			v.vertex.xy += wavePos;
			
			o.tint = (wavePos.y * wavePos.x);
      	}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb - IN.tint;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "HAB/Fake Waving Cloth"
}
