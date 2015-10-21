require "httparty"
require "pry"

module Jukeberx
  class RemoteControl
    include HTTParty
    base_uri "http://localhost:4567"

    def search(options={})
      RemoteControl.get("/api/search", query: options)
    end

    def play(id)
      RemoteControl.post("/api/play/#{id}")
    end

    def stop
      RemoteControl.delete("/api/stop")
    end
  end
end

binding.pry
