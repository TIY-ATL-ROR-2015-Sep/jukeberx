module Jukeberx
  class Song
    attr_reader :id, :filename, :artist, :album, :title

    def initialize(id, file, tag)
      @id = id
      @filename = file
      @artist = tag.artist
      @album = tag.album
      @title = tag.title
    end

    def play
      spawn("afplay \"#{@filename}\"")
    end

    def to_json
      {
        id:      self.id,
        artist:  self.artist,
        album:   self.album,
        title:   self.title
      }.to_json
    end
  end
end
