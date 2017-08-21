// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SuperBlurPostEffect"
{
	Properties
	{
		_MainTex ("", 2D) = "white" {}
	}

	CGINCLUDE

	#include "UnityCG.cginc"

	struct vertexInput
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct vertexOutput
	{
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
	};

	struct output_5tap
	{
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
		float4 blurTexcoord : TEXCOORD1;
	};

	struct output_9tap
	{
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
		float4 blurTexcoord[2] : TEXCOORD1;
	};

	struct output_13tap
	{
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
		float4 blurTexcoord[3] : TEXCOORD1;
	};

	uniform sampler2D _MainTex;
	uniform float4 _MainTex_ST;
	uniform float2 _MainTex_TexelSize;

	uniform float _Radius;


	vertexOutput vert (vertexInput IN)
	{
		vertexOutput OUT;

		OUT.vertex = UnityObjectToClipPos(IN.vertex);
		OUT.texcoord = IN.uv;

		return OUT;
	}

	fixed4 frag (vertexOutput IN) : SV_Target
	{
		fixed3 color = tex2D(_MainTex, IN.texcoord);
		return fixed4(color, 1.0);
	}

	//
	//	Small Kernel
	//
	output_5tap vert5Horizontal (vertexInput IN)
	{
		output_5tap OUT;

		OUT.vertex = UnityObjectToClipPos(IN.vertex);

		float2 offset = float2(_MainTex_TexelSize.x * _Radius * 1.33333333, 0.0); 

	#if UNITY_VERSION >= 540
		float2 uv = UnityStereoScreenSpaceUVAdjust(IN.uv, _MainTex_ST);
	#else
		float2 uv = IN.uv;
	#endif

		OUT.texcoord = uv;
		OUT.blurTexcoord.xy = uv + offset;
		OUT.blurTexcoord.zw = uv - offset;

		return OUT;
	}

	output_5tap vert5Vertical (vertexInput IN)
	{
		output_5tap OUT;

		OUT.vertex = UnityObjectToClipPos(IN.vertex);

		float2 offset = float2(0.0, _MainTex_TexelSize.y * _Radius * 1.33333333); 

	#if UNITY_VERSION >= 540
		float2 uv = UnityStereoScreenSpaceUVAdjust(IN.uv, _MainTex_ST);
	#else
		float2 uv = IN.uv;
	#endif

		OUT.texcoord = uv;
		OUT.blurTexcoord.xy = uv + offset;
		OUT.blurTexcoord.zw = uv - offset;

		return OUT;
	}

	fixed4 frag5Blur (output_5tap IN) : SV_Target
	{
	#if GAMMA_CORRECTION
		fixed3 sum = GammaToLinearSpace(tex2D(_MainTex, IN.texcoord).xyz) * 0.29411764;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord.xy).xyz) * 0.35294117;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord.zw).xyz) * 0.35294117;
		return fixed4(LinearToGammaSpace(sum), 1.0);
	#else
		fixed3 sum = tex2D(_MainTex, IN.texcoord).xyz * 0.29411764;
		sum += tex2D(_MainTex, IN.blurTexcoord.xy).xyz * 0.35294117;
		sum += tex2D(_MainTex, IN.blurTexcoord.zw).xyz * 0.35294117;
		return fixed4(sum, 1.0);
	#endif
	}

	//
	//	Medium Kernel
	//
	output_9tap vert9Horizontal (vertexInput IN)
	{
		output_9tap OUT;

		OUT.vertex = UnityObjectToClipPos(IN.vertex);

		float2 offset1 = float2(_MainTex_TexelSize.x * _Radius * 1.38461538, 0.0); 
		float2 offset2 = float2(_MainTex_TexelSize.x * _Radius * 3.23076923, 0.0);

	#if UNITY_VERSION >= 540
		float2 uv = UnityStereoScreenSpaceUVAdjust(IN.uv, _MainTex_ST);
	#else
		float2 uv = IN.uv;
	#endif

		OUT.texcoord = uv;
		OUT.blurTexcoord[0].xy = uv + offset1;
		OUT.blurTexcoord[0].zw = uv - offset1;
		OUT.blurTexcoord[1].xy = uv + offset2;
		OUT.blurTexcoord[1].zw = uv - offset2;

		return OUT;
	}

	output_9tap vert9Vertical (vertexInput IN)
	{
		output_9tap OUT;

		OUT.vertex = UnityObjectToClipPos(IN.vertex);

		float2 offset1 = float2(0.0, _MainTex_TexelSize.y * _Radius * 1.38461538); 
		float2 offset2 = float2(0.0, _MainTex_TexelSize.y * _Radius * 3.23076923);

	#if UNITY_VERSION >= 540
		float2 uv = UnityStereoScreenSpaceUVAdjust(IN.uv, _MainTex_ST);
	#else
		float2 uv = IN.uv;
	#endif

		OUT.texcoord = uv;
		OUT.blurTexcoord[0].xy = uv + offset1;
		OUT.blurTexcoord[0].zw = uv - offset1;
		OUT.blurTexcoord[1].xy = uv + offset2;
		OUT.blurTexcoord[1].zw = uv - offset2;

		return OUT;
	}

	fixed4 frag9Blur (output_9tap IN) : SV_Target
	{
	#if GAMMA_CORRECTION
		fixed3 sum = GammaToLinearSpace(tex2D(_MainTex, IN.texcoord).xyz) * 0.22702702;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[0].xy).xyz) * 0.31621621;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[0].zw).xyz) * 0.31621621;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[1].xy).xyz) * 0.07027027;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[1].zw).xyz) * 0.07027027;
		return fixed4(LinearToGammaSpace(sum), 1.0);
	#else
		fixed3 sum = tex2D(_MainTex, IN.texcoord).xyz * 0.22702702;
		sum += tex2D(_MainTex, IN.blurTexcoord[0].xy).xyz * 0.31621621;
		sum += tex2D(_MainTex, IN.blurTexcoord[0].zw).xyz * 0.31621621;
		sum += tex2D(_MainTex, IN.blurTexcoord[1].xy).xyz * 0.07027027;
		sum += tex2D(_MainTex, IN.blurTexcoord[1].zw).xyz * 0.07027027;
		return fixed4(sum, 1.0);
	#endif
	}

	//
	//	Big Kernel
	//
	output_13tap vert13Horizontal (vertexInput IN)
	{
		output_13tap OUT;

		OUT.vertex = UnityObjectToClipPos(IN.vertex);

		float2 offset1 = float2(_MainTex_TexelSize.x * _Radius * 1.41176470, 0.0); 
		float2 offset2 = float2(_MainTex_TexelSize.x * _Radius * 3.29411764, 0.0);
		float2 offset3 = float2(_MainTex_TexelSize.x * _Radius * 5.17647058, 0.0);

	#if UNITY_VERSION >= 540
		float2 uv = UnityStereoScreenSpaceUVAdjust(IN.uv, _MainTex_ST);
	#else
		float2 uv = IN.uv;
	#endif

		OUT.texcoord = uv;
		OUT.blurTexcoord[0].xy = uv + offset1;
		OUT.blurTexcoord[0].zw = uv - offset1;
		OUT.blurTexcoord[1].xy = uv + offset2;
		OUT.blurTexcoord[1].zw = uv - offset2;
		OUT.blurTexcoord[2].xy = uv + offset3;
		OUT.blurTexcoord[2].zw = uv - offset3;

		return OUT;
	}

	output_13tap vert13Vertical (vertexInput IN)
	{
		output_13tap OUT;

		OUT.vertex = UnityObjectToClipPos(IN.vertex);

		float2 offset1 = float2(0.0, _MainTex_TexelSize.y * _Radius * 1.41176470); 
		float2 offset2 = float2(0.0, _MainTex_TexelSize.y * _Radius * 3.29411764);
		float2 offset3 = float2(0.0, _MainTex_TexelSize.y * _Radius * 5.17647058);

	#if UNITY_VERSION >= 540
		float2 uv = UnityStereoScreenSpaceUVAdjust(IN.uv, _MainTex_ST);
	#else
		float2 uv = IN.uv;
	#endif

		OUT.texcoord = uv;
		OUT.blurTexcoord[0].xy = uv + offset1;
		OUT.blurTexcoord[0].zw = uv - offset1;
		OUT.blurTexcoord[1].xy = uv + offset2;
		OUT.blurTexcoord[1].zw = uv - offset2;
		OUT.blurTexcoord[2].xy = uv + offset3;
		OUT.blurTexcoord[2].zw = uv - offset3;

		return OUT;
	}

	fixed4 frag13Blur (output_13tap IN) : SV_Target
	{
	#if GAMMA_CORRECTION
		fixed3 sum = GammaToLinearSpace(tex2D(_MainTex, IN.texcoord).xyz) * 0.19648255;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[0].xy).xyz) * 0.29690696;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[0].zw).xyz) * 0.29690696;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[1].xy).xyz) * 0.09447039;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[1].zw).xyz) * 0.09447039;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[2].xy).xyz) * 0.01038136;
		sum += GammaToLinearSpace(tex2D(_MainTex, IN.blurTexcoord[2].zw).xyz) * 0.01038136;
		return fixed4(LinearToGammaSpace(sum), 1.0);
	#else
		fixed3 sum = tex2D(_MainTex, IN.texcoord).xyz * 0.19648255;
		sum += tex2D(_MainTex, IN.blurTexcoord[0].xy).xyz * 0.29690696;
		sum += tex2D(_MainTex, IN.blurTexcoord[0].zw).xyz * 0.29690696;
		sum += tex2D(_MainTex, IN.blurTexcoord[1].xy).xyz * 0.09447039;
		sum += tex2D(_MainTex, IN.blurTexcoord[1].zw).xyz * 0.09447039;
		sum += tex2D(_MainTex, IN.blurTexcoord[2].xy).xyz * 0.01038136;
		sum += tex2D(_MainTex, IN.blurTexcoord[2].zw).xyz * 0.01038136;
		return fixed4(sum, 1.0);
	#endif
	}

	ENDCG

	SubShader
	{
		ZTest Always Cull Off ZWrite Off

		//
		//	dummy pass
		//
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}

		//
		//	5 tap gaussian blur
		//
		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert5Horizontal
			#pragma fragment frag5Blur
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert5Vertical
			#pragma fragment frag5Blur
			ENDCG
		}

		//
		//	9 tap gaussian blur
		//
		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert9Horizontal
			#pragma fragment frag9Blur
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert9Vertical
			#pragma fragment frag9Blur
			ENDCG
		}

		//
		//	13 tap gaussian blur
		//
		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert13Horizontal
			#pragma fragment frag13Blur
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert13Vertical
			#pragma fragment frag13Blur
			ENDCG
		}

	}
}
