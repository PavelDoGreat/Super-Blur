Super Blur
==========

Blur effect that you can apply on Camera and UI. Gaussian weights was taken from [this project](https://github.com/Jam3/glsl-fast-gaussian-blur).

![view](http://i.imgur.com/4WO551O.png)

Usage
-----

Just add **SuperBlur.cs** or **SuperBlurFast.cs** script to Camera and attach *Blur Material* and *UI Material* to it.
If you want to use **AutoSuperBlurController**, just add **AutoSuperBlurController.cs** to the same Camera.

- **SuperBlur** - (recommended way) It's using OnRenderImage to grab screen texture.

- **SuperBlurFast** - Render scene directly to render texture. Much better perfomance on mobile devices, but doesn't work with other post effects.

- **AutoSuperBlurController** - Sets values of SuperBlur automatically and dynamically depending on Blur Size and Max Iterations.

Properties of SuperBlur.cs and SuperBlurFast.cs
----------

![editor](http://i.imgur.com/6ZiIcgq.png)

- **Render Mode** - Chooses to render as Post Effect or just apply blurred texture to UI material.

- **Kernel Size** - Bigger kernels produces bigger blur, but are more expensive.

- **Interpolation** - Use if you want to create smooth blurring transition.

- **Downsample** - Controls buffer resolution (0 = no downsampling, 1 = half resolution... etc.).

- **Iterations** - More iterations = bigger blur, but comes at perfomance cost.

- **Gamma Correction** - Enables gamma correction to produce correct blur in Gamma Colorspace. Disable this option if you use Linear Colorspace. 

Properties of AutoSuperBlurController.cs
----------

- **Blur Size** - The size of the blur. Set to 0 to disable SuperBlur.cs or SuperBlurFast.cs.

- **Max Iterations** - The maximum iteration value that will be used before instead using downsampling to increase the size of the blur. 

License
-------

If you'd try to sell it on Asset Store, then I'm gonna find you.

See [LICENSE](LICENSE) for details.
