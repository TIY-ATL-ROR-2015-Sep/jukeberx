require "mp3info"

module SillyExample
  def cookies
    puts "NOM NOM NOM NOM NOM!"
  end
end

module Jukeberx
  class Searcher
    # include Enumerable
    include SillyExample

    def initialize(dir)
      @songs = []
      self.get_mp3s(dir)
    end

    # def each
    #   @songs.each { |x| yield(x) }
    # end

    def get_song(id)
      @songs.find { |song| song.id == id }
    end

    def match_artists(name)
      @songs.select { |song| song.artist =~ /#{name}/i  }
    end

    def match_albums(name)
      @songs.select { |song| song.album =~ /#{name}/i  }
    end

    def match_titles(name)
      @songs.select { |song| song.title =~ /#{name}/i  }
    end

    def list_artists
      @songs.map { |song| song.artist }.uniq
    end

    def list_albums
      @songs.map { |song| song.album }.uniq
    end

    def list_titles
      @songs.map { |song| song.title }.uniq
    end

    # def list_property(name)
    #   @songs.map { |song| song.send(name) }.uniq
    # end

    protected
    def get_mp3s(dir)
      files = Dir.glob(File.join(dir, '*/*.mp3'))
      files.each_with_index do |mp3_file, id|
        begin
          tag = Mp3Info.open(mp3_file) { |mp3| mp3.tag }
          @songs << Song.new(id, mp3_file, tag)
        rescue Mp3InfoError => e
          puts "#{mp3_file} failed with: #{e.message}"
        end
      end
    end
  end
end
