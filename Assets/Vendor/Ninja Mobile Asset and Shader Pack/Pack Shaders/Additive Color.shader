Shader "HAB/Unlit/Transparent/Additive Color Texture"
{
	Properties
	{
		_Color ("Color", COLOR) = (1, 1, 1, 1)
		_MainTex ("Main Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags
		{
			 "RenderType"="Transparent"
			 "Queue"="Transparent"
		}
		Cull off
		ZWrite off
		Lighting Off
		Blend One One
		Pass
		{
			SetTexture[_MainTex]
			{
				combine texture * texture alpha double
			}
            SetTexture [_MainTex] 
            {
            	constantColor [_Color]
                combine previous * constant
            }			
		}
	}
}
