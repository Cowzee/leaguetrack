require_relative "../lapi"

module Lapi
  class Client

    def connection
      @conn = Faraday.new(url: Lapi::host)
      conn.params['api_key'] = Lapi::api_key
    end

    def call(path)
      @conn.get(path)
    end 


  end
end