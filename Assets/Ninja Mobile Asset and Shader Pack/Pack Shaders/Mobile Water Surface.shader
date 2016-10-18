Shader "HAB/Surface/Transparent/Scrolling Bumpmap"
{
	Properties 
	{
		[Header(More expensive surface shader)]
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Main (RGB)", 2D) = "white" {}
		_DispTex ("Displacement (RG)", 2D) = "white" {}
		_Scroll ("Main Scroll (X, Y) Bump Scroll (Z, W)", VECTOR) = (0, 0, 0, 0)
		_DispAmount ("Bump Amount", Range(0, 1)) = 0
	}
	
	SubShader 
	{
		Tags 
		{ 
			"RenderType"="Opaque" 
			"Queue"="Transparent"
		}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert addshadow alpha

		sampler2D _MainTex;
		sampler2D _DispTex;
		
		float4 _Scroll;
		
		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_DispTex;
			float4 scrollAmount;
		};
		
		void vert (inout appdata_full v, out Input o) 
		{
			v.texcoord.xy += _Time.x * _Scroll.xy;
         	UNITY_INITIALIZE_OUTPUT(Input, o);
			o.scrollAmount = _Time.x * _Scroll;
      	}
		  
		float _DispAmount;
		
		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed2 disp = tex2D(_DispTex, IN.uv_DispTex + IN.scrollAmount.zw).rg * _DispAmount;
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex - IN.scrollAmount.xy + disp);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "HAB/Scrolling Bumpmap Transparent"
}
