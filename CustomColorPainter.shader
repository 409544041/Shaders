Shader "Custom/CustomColorPainter" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_ColorEmission("ColorEmission", Color)=(1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_EmissionMap ("EmissionMap",2D) = "gray" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
        sampler2D _EmissionMap;
		struct Input {
			float2 uv_MainTex;
			float2 uv_EmissionMap;
		};

		half _Glossiness;
		half _Metallic;
		fixed _AlphaChecker;
		fixed4 _Color;
		fixed4 _ColorEmission;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) {
			_AlphaChecker = 0.6;
			
            fixed3 endColor = fixed3(0.0,0.0,0.0);
            fixed4 ca = tex2D(_EmissionMap, IN.uv_EmissionMap);


		    // normalColor stuff
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);



			// emission stuff
			if (ca.a<=_AlphaChecker){
				o.Emission = half3(0.0,0.0,0.0);

			endColor = c.rgb;
			}
			else{
        	o.Emission = _ColorEmission;
			endColor = _ColorEmission;
			}

			if (c.a<_AlphaChecker)
            endColor = _Color;



			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Albedo = endColor.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
