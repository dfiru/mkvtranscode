#!/usr/bin/env ruby 

require 'streamio-ffmpeg'
require 'slop'

class Mkvtranscode

  def initialize(movie, destination)
    @destination = destination

    @movie_file = File.join(@destination,"#{File.basename(movie,'.*')}.mp4")
    puts movie
#    @movie = FFMPEG::Movie.new(movie)
    @movie = FFMPEG::Movie.new(movie)
    @movie.bitrate # 481 (bitrate in kb/s)
    puts @movie.duration # 7.5 (duration of the @movie in seconds)
    puts @movie.size # 455546 (filesize in bytes)

    puts @movie.video_stream # "h264, yuv420p, 640x480 [PAR 1:1 DAR 4:3], 371 kb/s, 16.75 fps, 15 tbr, 600 tbn, 1200 tbc" (raw video stream info)
    puts @movie.video_codec # "h264"
    puts @movie.colorspace # "yuv420p"
    puts @movie.resolution # "640x480"
    puts @movie.width # 640 (width of the @movie in pixels)
    puts @movie.height # 480 (height of the @movie in pixels)
    puts @movie.frame_rate # 16.72 (frames per second)

    puts @movie.audio_stream # "aac, 44100 Hz, stereo, s16, 75 kb/s" (raw audio stream info)
    puts @movie.audio_codec # "aac"
    puts @movie.audio_sample_rate # 44100
    puts @movie.audio_channels # 2

    puts @movie.valid? # true (would be false if ffmpeg fails to read the @movie)
  end
  
  def transcode
    options = {custom: "-strict -2 -profile:v high -level 4.1 -threads 0"}
    t = Time.now
    @movie.transcode(@movie_file, options) do |progress| 
      puts progress 
      time_elapsed = Time.now - t
      puts "#{time_elapsed/progress/60} minutes left"
      sleep 10
    end

  end
end

if __FILE__ == $0
  opts = Slop.parse do |o|
    o.string '-s', '--source_dir', 'source directory for movies', default: "."
    o.string '-d', '--destination_dir', 'destination directory for movies', default: "."
    o.string '-m', '--manifest_file', 'list of movies to transcode'
    #  o.integer '--port', 'custom port', default: 80
    #  o.bool '-v', '--verbose', 'enable verbose mode'
    #  o.bool '-q', '--quiet', 'suppress output (quiet mode)'
    #  o.on '--version', 'print the version' do
    #    puts Slop::VERSION

  end
  
  puts opts[:source_dir].inspect
  puts opts[:destination_dir].inspect
  puts opts[:manifest_file].inspect
  
  destination = File.expand_path(opts[:destination_dir])
  source = File.expand_path(opts[:source_dir])
  file = File.expand_path(opts[:manifest_file])

  if opts[:manifest_file].nil?
    puts "you should probably include a list of movies to transcode"
  else
    contents = File.readlines(file)
    #foreach file in the manifest    
    contents.each do |m|
      movie_file = File.join(source, m)
      puts movie_file.to_s
      movie_file = movie_file.to_s.chomp.gsub(/\s/, '\ ')
      puts movie_file
      mkv = Mkvtranscode.new(movie_file, destination)  
      mkv.transcode
    end
  end
end

