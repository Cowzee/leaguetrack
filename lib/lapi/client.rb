require_relative "../lapi"

module Lapi
  class Client

    def initialize
      @conn = Faraday.new(url: host)
      @conn.params['api_key'] = api_key
    end

    def call(path)
      @conn.get(path)
    end 
  
    def api_key
      ENV.fetch("API_KEY")
    end

    def host
      "https://americas.api.riotgames.com"
    end



  end
end