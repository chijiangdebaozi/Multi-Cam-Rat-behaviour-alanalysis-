from  moviepy.editor import *

clip = VideoFileClip(r"D:\deepsort-3.0\1.mp4")
clipblackwhite = clip.fx(vfx.blackwhite)
clipblackwhite.write_videofile(r"D:\deepsort-3.0\1（灰色）.mp4")


