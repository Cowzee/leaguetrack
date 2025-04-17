require_relative "../lapi"
module Lapi
  module Summoner
    class FindByName < Lapi::Client

      def initialize(summoner_name)
        @summoner_name = summoner_name
        @path = "/riot/account/v1/accounts/by-riot-id/#{summoner_name}"
        super()
      end

      def call
        res = super(@path)

        puts res.body
      end
    
    end
  end
end