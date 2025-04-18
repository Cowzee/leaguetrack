require_relative "../lapi"
module Lapi
  module Match
    class RecentIDs < Lapi::Client

      def initialize(puuid, timestamp)
        @puuid = puuid
        @path = "/lol/match/v5/matches/by-puuid/#{puuid}/ids" 
        super()
        @conn.params['startTime'] = timestamp
        @conn.params['count'] = 20
      end

      def call
        res = super(@path)

        res.body
      end
    end
    class ByID < Lapi::Client
      attr_accessor :ids
      attr_accessor :cur_id
      def initialize(ids)
        @ids = ids
        super()
      end
      def path(id)
        "/lol/match/v5/matches/#{id}"
      end

      def batch_call

        #TODO: Look into parallel 

        attempts = 0
        @ids[0..5].each do |id|
          begin
            res = call(id)
            if block_given?
              yield res, id
            end

          rescue Faraday::TooManyRequestsError
            puts "retrying"
            attempts += 1
            wait_time = e.response[:headers]["Retry-After"]&.to_i || 1
            sleep(wait_time)

            retry if attempts < 5
            raise "Too many retries for #{@cur_id}"  

          end
          
        end
      end
      def call(id)
        res = super(path(id))
        res.body
      end
    end
  end
end
