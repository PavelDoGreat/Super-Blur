using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperBlur;

public class AutoSuperBlurController : MonoBehaviour
{
    private SuperBlurBase blur;
    [Range(0f, 128f)]
    public float blurSize = 0f;
    [Range(1, 8)]
    public int maxIterations = 4;

    void Start()
    {
        blur = GetComponent<SuperBlurBase>();
    }

    void Update()
    {
        UpdateBlur();
    }

    private void OnValidate()
    {
        //Get reference in OnValidate to change values in editor.
        blur = GetComponent<SuperBlurBase>();
        UpdateBlur();
    }

    private void UpdateBlur()
    {
        //Disable if no blur
        if (blurSize == 0f)
        {
            blur.enabled = false;
            return;
        }

        blur.enabled = true;

        //Weight blur size value to iteration count, so blur amount is the same regardless of maxIterations setting.
        var blurSizeWeighted = blurSize / maxIterations;

        //Increase iteration count if below max blur size for the set max iteration count
        if (blurSizeWeighted < 1f)
        {
            blur.iterations = 1 + Mathf.FloorToInt(blurSizeWeighted * (maxIterations));
            blur.downsample = 0;
            blur.interpolation = blurSizeWeighted * (maxIterations) / blur.iterations;
        }
        //Downsample if above max blur size for the set max iteration count
        else
        {
            blur.iterations = maxIterations;
            blur.downsample = Mathf.Max(0, Mathf.CeilToInt(Mathf.Log10(blurSizeWeighted) / Mathf.Log10(2)));
            blur.interpolation = blurSizeWeighted / Mathf.Pow(2, blur.downsample);
        }

    }
}
