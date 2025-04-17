# frozen_string_literal: true

require_relative "leaguetrack/version"
require_relative "lapi"
require_relative "leaguetrack/cli"
require "json"

module Leaguetrack
  class App
    def initialize(account_name, tag)
      @summoner = account_name.to_s + "/" + tag
    end

    def run
      # TODO: CHECK IF SUMMONER STORED IN SOME STORAGE FILE? (RA, DB)
      # if not stored:
      sum_data = Lapi::Summoner::FindByName.new(@summoner).call
      @puuid = JSON.parse(sum_data)["puuid"] #or stored

      timestamp = 0 # Retreive from storage - most recent entry or 0

      matches_data = Lapi::Match::RecentIDs.new(@puuid, timestamp).call #TODO: Fix 
      @ids = JSON.parse(matches_data)

      match = JSON.pretty_generate(Lapi::Match::ByID.new(@ids[0]).call)
      File.open("match.json", 'w') {|file| file.write(match)}
      # What are important values here? we need to check participantDTOs for user pos
      # and find enemy laner in team pos, won or lost, game time?

      # TODO: STORE PUUID, RETRIEVE MATCHES FROM PUUID
      # TODO: STORE MATCHES
      # TODO: CREATE COMMANDLINE UI
    end
  end
end
 