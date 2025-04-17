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

      matches_data = Lapi::Match::RecentIDs.new(@puuid, most_recent_match).call #TODO: Fix 
      @ids = JSON.parse(matches_data)


      match_client = Lapi::Match::ByID.new(@ids)
      matches = []
      match_client.batch_call do |body|
        matches << user_match_data(body)
      end

      print matches



      # File.open("match.json", 'w') {|file| file.write(match)}
      # What are important values here? we need to check participantDTOs for user pos
      # and find enemy laner in team pos, won or lost, game time?

      # TODO: STORE PUUID, RETRIEVE MATCHES FROM PUUID
      # TODO: STORE MATCHES
      # TODO: CREATE COMMANDLINE UI
    end

    def most_recent_match
      0
    end

    def user_match_data(string_match)
        match = JSON.parse(string_match)
        user_player ||= match['info']['participants'].find {|p| p['puuid'] == @puuid}
        user_player_lane = user_player['teamPosition']
        team_idx = user_player['teamId'] == 100 ? 5 : 0
        opponent_player ||= match['info']['participants'][team_idx, 5].find do |p|
          p['teamPosition'] == user_player_lane
        end
        user_won = user_player['win']

        user_data = {
          :role => user_player_lane,
          :champ => user_player['championName'],
          :matchup => opponent_player['championName'],
          :win => user_won
        }
        user_data
    end


  end
end
 