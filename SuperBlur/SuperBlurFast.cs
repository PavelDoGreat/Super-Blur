using UnityEngine;

namespace SuperBlur
{

	[RequireComponent(typeof(Camera))]
	[AddComponentMenu("Effects/Super Blur Fast", -1)]
	public class SuperBlurFast : SuperBlurBase 
	{

		Camera m_Camera = null;
		RenderTexture rt = null;

		void OnEnable ()
		{
			m_Camera = GetComponent<Camera>();
		}

		void OnPreCull ()
		{
			if (blurMaterial == null || UIMaterial == null) return;

			int tw = Screen.width >> downsample;
			int th = Screen.height >> downsample;

			rt = RenderTexture.GetTemporary(tw, th, 24, RenderTextureFormat.Default);

			m_Camera.targetTexture = rt;
		}

		void OnPostRender ()
		{
			if (blurMaterial == null || UIMaterial == null) return;

			m_Camera.targetTexture = null;

			if (renderMode == RenderMode.Screen)
			{
				Blur(rt, null);
			}
			else if (renderMode == RenderMode.UI)
			{
				Blur(rt, rt);
				UIMaterial.SetTexture(Uniforms._BackgroundTexture, rt);
				Graphics.Blit(rt, null, blurMaterial, 0);
			}
			else if (renderMode == RenderMode.OnlyUI)
			{
				Blur(rt, rt);
				UIMaterial.SetTexture(Uniforms._BackgroundTexture, rt);
			}

			RenderTexture.ReleaseTemporary(rt);
		}

	}

}