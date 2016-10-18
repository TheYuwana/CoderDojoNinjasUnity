Shader "HAB/Unlit/Transparent/Full Screen Quad Background" 
{
	Properties 
	{
		[Header(Renders a full screen quad)]
		[Header(The original mesh must be in the camera frustum)]
		_MainTex ("Main (RGBA)", 2D) = "white" {}
		_ScrollSpeed ("Scroll Speed (X, Y)", VECTOR) = (0, 0, 0, 0)
		_Fade ("Transparency", RANGE(0, 1)) = 0
	}

	SubShader 
	{
		Tags 
		{
			"RenderType"="Transparent" 
			"Queue"="Background"
		}
		ZWrite off
		Cull off
		Blend SrcAlpha OneMinusSrcAlpha
		UsePass "HAB/Unlit/Transparent/Full Screen Quad Overlay/NORMAL"
	}
	Fallback Off
}
