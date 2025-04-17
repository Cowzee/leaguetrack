require_relative "../lapi"
module Lapi
  module Summoner
    class FindByName < Lapi::Client

      def initialize(summoner_name)
        @summoner_name = summoner_name
        #TODO - figure out if summoner-name should be cleaned up
      end

      def path
        "temp-path#{summoner_name}"
      end

      def call
        # res = super 

        # res[:data] #TODO - work w/ data
        puts @summoner_name #stub
      end
    
    end
  end
end