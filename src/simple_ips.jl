using Images
using ImageView
using ImageMagick
using TestImages
using FileIO
using ParallelAccelerator

using DocOpt
using Images













@acc function blur(img, iterations)
    buf = copy(img)
    runStencil(buf, img, iterations, :oob_src_zero) do b, a
       b[0,0] =
      (a[-2,-2] * 0.003  + a[-1,-2] * 0.0133 + a[0,-2] * 0.0219 + a[1,-2] * 0.0133 + a[2,-2] * 0.0030 +
       a[-2,-1] * 0.0133 + a[-1,-1] * 0.0596 + a[0,-1] * 0.0983 + a[1,-1] * 0.0596 + a[2,-1] * 0.0133 +
       a[-2, 0] * 0.0219 + a[-1, 0] * 0.0983 + a[0, 0] * 0.1621 + a[1, 0] * 0.0983 + a[2, 0] * 0.0219 +
       a[-2, 1] * 0.0133 + a[-1, 1] * 0.0596 + a[0, 1] * 0.0983 + a[1, 1] * 0.0596 + a[2, 1] * 0.0133 +
       a[-2, 2] * 0.003  + a[-1, 2] * 0.0133 + a[0, 2] * 0.0219 + a[1, 2] * 0.0133 + a[2, 2] * 0.0030)
    return a, b
    end
    return img
end
    





    img =  load("portinari.png")

    img2 = blur(img,10)
    save("portinari-blur.png",img2)
    




