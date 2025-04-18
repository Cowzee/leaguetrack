# frozen_string_literal: true

require_relative "leaguetrack/version"
require_relative "lapi"
require_relative "leaguetrack/cli"
require_relative "leaguetrack/storage"
require "json"

module Leaguetrack
  class App
    def initialize(account_name, tag)
      @summoner = account_name.to_s + "/" + tag
      @storage_handler = Leaguetrack::Storage.new()
      @user = nil
    end

    def run

      if @user = @storage_handler.get_user_by_summoner(@summoner)
        @puuid = @storage_handler.get_puuid_by_user(@user)
      else
        sum_data = Lapi::Summoner::FindByName.new(@summoner).call
        @puuid = JSON.parse(sum_data)["puuid"] 
        @user = @storage_handler.add_user(@summoner, @puuid)
      end

      store_matches(get_matches)

    end

    def most_recent_match
      @storage_handler.get_timestamp
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

    def get_matches
      matches_data = Lapi::Match::RecentIDs.new(@puuid, most_recent_match).call
      @ids = JSON.parse(matches_data)

      match_client = Lapi::Match::ByID.new(@ids)
      matches = []
      match_client.batch_call do |body|
        matches << user_match_data(body)
      end

      matches
    end

    def store_matches(matches) 
      matches.each do |match|
        @storage_handler.add_matchup(@user, match)
      end

      @storage_handler.write_data
    end

  end
end
 