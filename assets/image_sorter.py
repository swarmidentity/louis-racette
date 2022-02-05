import Image
im = Image.open("test.bmp")
im.size  # (364, 471)
im.getbbox()  # (64, 89, 278, 267)
im2 = im.crop(im.getbbox())
im2.size  # (214, 178)
im2.save("test2.bmp")