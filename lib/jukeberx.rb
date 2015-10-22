require "jukeberx/version"
require "jukeberx/song"
require "jukeberx/searcher"

require "sinatra/base"
require "json"
require "pry"

MUSIC_DIR = "/Users/brit/Music/downloads"

module Jukeberx
  # Your code goes here...
  class App < Sinatra::Base
    set :logging, true
    set :library, Searcher.new(MUSIC_DIR)
    set :song, nil
    set :pid,  nil

    get "/api/search" do
      if params["artist"]
        results = settings.library.match_artists(params["artist"])
      elsif params["album"]
        results = settings.library.match_albums(params["album"])
      elsif params["title"]
        results = settings.library.match_titles(params["title"])
      else
        results = { message: "You must supply an artist, album, or title." }
        status 204
      end
      content_type "application/json"
      results.to_json
    end

    post "/api/play/:id" do
      @pid = settings.pid
      if @pid
        Process.kill(:SIGINT, @pid) unless Process.waitpid(@pid, Process::WNOHANG)
      end

      content_type "application/json"
      @song = settings.library.get_song(params["id"].to_i)
      if @song
        settings.song = @song
        settings.pid  = @song.play
        status 201
        { message: "Now playing: #{@song.artist} - #{@song.title}" }.to_json
      else
        status 404
        { message: "No song found with id: #{params["id"]}" }.to_json
      end
    end

    delete "/api/stop" do
      spawn("killall afplay")
      status 204
    end

    get "/" do
      erb :index, layout: :base,
        locals: { songs: settings.library.songs }
    end

    get "/search" do
      case params["category"]
      when "artist"
        results = settings.library.match_artists(params["query"])
      when "album"
        results = settings.library.match_albums(params["query"])
      when "title"
        results = settings.library.match_titles(params["query"])
      end
      erb :search, layout: :base,
        locals: { songs: results, query: params["query"] }
    end

    run! if app_file == $0
  end
end
