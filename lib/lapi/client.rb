require_relative "../lapi"

module Lapi
  class Client

    def initialize
      @conn = Faraday.new(url: host)
      @conn.params['api_key'] = api_key
      @conn.use Faraday::Response::RaiseError
    end

    def call(path)

      begin
        @conn.get(path) 
      rescue Faraday::Error => err
        if err.status.to_i == 429
          raise err
        else
          error_body = JSON.parse(err.response[:body])
          puts error_body["status"]["message"]
          exit 
        end

      end
      


    end 
  
    def api_key
      ENV.fetch("API_KEY")
    end

    def host
      "https://americas.api.riotgames.com"
    end



  end
end