#!/usr/bin/env ruby 
require 'streamio-ffmpeg'

movie = FFMPEG::Movie.new("/Users/danielfiru/Movies/Despicable Me.mkv")

movie.bitrate # 481 (bitrate in kb/s)
puts movie.duration # 7.5 (duration of the movie in seconds)
puts movie.size # 455546 (filesize in bytes)

puts movie.video_stream # "h264, yuv420p, 640x480 [PAR 1:1 DAR 4:3], 371 kb/s, 16.75 fps, 15 tbr, 600 tbn, 1200 tbc" (raw video stream info)
puts movie.video_codec # "h264"
puts movie.colorspace # "yuv420p"
puts movie.resolution # "640x480"
puts movie.width # 640 (width of the movie in pixels)
puts movie.height # 480 (height of the movie in pixels)
puts movie.frame_rate # 16.72 (frames per second)

puts movie.audio_stream # "aac, 44100 Hz, stereo, s16, 75 kb/s" (raw audio stream info)
puts movie.audio_codec # "aac"
puts movie.audio_sample_rate # 44100
puts movie.audio_channels # 2

puts movie.valid? # true (would be false if ffmpeg fails to read the movie)
