using UnityEngine;

namespace SuperBlur
{

	[ExecuteInEditMode]
	public class SuperBlurBase : MonoBehaviour
	{
		protected static class Uniforms
		{
			public static readonly int _Radius = Shader.PropertyToID("_Radius");
			public static readonly int _BackgroundTexture = Shader.PropertyToID("_SuperBlurTexture");
		}

		public RenderMode renderMode = RenderMode.Screen;

		public BlurKernelSize kernelSize = BlurKernelSize.Small;

		[Range(0f, 1f)]
		public float interpolation = 1f;

		[Range(0, 4)]
		public int downsample = 1;

		[Range(1, 8)]
		public int iterations = 1;

		public bool gammaCorrection = true;

		public Material blurMaterial;

		public Material UIMaterial;


		protected void Blur (RenderTexture source, RenderTexture destination)
		{
			if (gammaCorrection)
			{
				Shader.EnableKeyword("GAMMA_CORRECTION");
			}
			else
			{
				Shader.DisableKeyword("GAMMA_CORRECTION");
			}

			int kernel = 0;

			switch (kernelSize)
			{
			case BlurKernelSize.Small:
				kernel = 0;
				break;
			case BlurKernelSize.Medium:
				kernel = 2;
				break;
			case BlurKernelSize.Big:
				kernel = 4;
				break;
			}

			var rt2 = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);

			for (int i = 0; i < iterations; i++)
			{
				// helps to achieve a larger blur
				float radius = (float)i * interpolation + interpolation;
				blurMaterial.SetFloat(Uniforms._Radius, radius);

				Graphics.Blit(source, rt2, blurMaterial, 1 + kernel);
				source.DiscardContents();

				// is it a last iteration? If so, then blit to destination
				if (i == iterations - 1)
				{
					Graphics.Blit(rt2, destination, blurMaterial, 2 + kernel);
				}
				else
				{
					Graphics.Blit(rt2, source, blurMaterial, 2 + kernel);
					rt2.DiscardContents();
				}
			}

			RenderTexture.ReleaseTemporary(rt2);
		}
			
	}
	
	public enum BlurKernelSize
	{
		Small,
		Medium,
		Big
	}

	public enum RenderMode
	{
		Screen,
		UI,
		OnlyUI
	}

}
