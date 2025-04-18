# frozen_string_literal: true

require_relative "leaguetrack/version"
require_relative "lapi"
require_relative "leaguetrack/cli"
require_relative "leaguetrack/storage"
require "json"

module Leaguetrack
  class App
    def initialize(account_name, tag)
      @summoner = clean_sum_name(account_name, tag)

      @storage_handler = Leaguetrack::Storage.new()
      @user = nil
      @timestamp = 0
    end


    def clean_sum_name(name, tag)
      "#{name.gsub!(' ','%20')}/#{tag}"
    end

    def run
      
      get_user
      store_matches(get_matches)

      #TODO: CONSOLE INPUT

    end

    def most_recent_match
      @storage_handler.get_timestamp(@user)
    end
    
    def get_user
      print "FETCHING USER... "
      if @user = @storage_handler.get_user_by_summoner(@summoner)
        puts "STORED USER FOUND"
        @puuid = @storage_handler.get_puuid_by_user(@user)
      else
        puts "STORED USER NOT FOUND - FETCHING FROM RIOT API"
        sum_data = Lapi::Summoner::FindByName.new(@summoner).call
        @puuid = JSON.parse(sum_data)["puuid"] 
        @user = @storage_handler.add_user(@summoner, @puuid)
      end
    end

    def user_match_data(match)

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
      puts "FETCHING RECENT RANKED MATCHES..."

      matches_data = Lapi::Match::RecentIDs.new(@puuid, most_recent_match).call
      @ids = JSON.parse(matches_data)

      match_client = Lapi::Match::ByID.new(@ids)
      puts "PARSING #{@ids.count} MATCHES"
      matches = []
      match_client.batch_call do |body, id|
        parsed = JSON.parse(body)

        if [420,400].include? parsed['info']['queueId']
          matches << user_match_data(parsed)
        end
    
        if id == @ids[0]
          @timestamp = parsed['info']['gameEndTimestamp']
        end
        
      end

      matches
    end

    def store_matches(matches) 
      matches.each do |match|
        @storage_handler.add_matchup(@user, match)
      end
      @storage_handler.update_timestamp(@user, @timestamp)

      @storage_handler.write_data
    end

  end
end
 