require_relative "../lapi"
module Lapi
  module Match
    class Recent < Lapi::Client

      def initialize(puuid)
        @puuid = puuid
      end

      def path
        "league-match-path-#{puuid}" #TODO add path for recent games
      end

      def call
        res = super # res = Lapi::Client.new.call with local host and path

        res[:data] #TODO - work with data
      end





    end
  end
end
