require_relative "../lapi"
module Lapi
  module Match
    class RecentIDs < Lapi::Client

      def initialize(puuid, timestamp)
        @puuid = puuid
        @path = "/lol/match/v5/matches/by-puuid/#{puuid}/ids" 
        super()
        @conn.params['startTime'] = timestamp
        @conn.params['count'] = 100
      end

      def call
        res = super(@path) # res = Lapi::Client.new.call with local host and path

        res.body
      end
    end
    class ByID < Lapi::Client
      attr_accessor :id
      def initialize(id)
        @id = id
        super()
      end
      def path
        "/lol/match/v5/matches/#{@id}"
      end
      def call
        res = super(path())
        JSON.parse(res.body)
      end
    end
  end
end
