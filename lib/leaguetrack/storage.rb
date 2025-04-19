module Leaguetrack
  class Storage

    def initialize(file_path = File.expand_path('../../data/leaguetrack_data.json', __dir__))
      @file_path = file_path
      @data = load
    end

    def load
      if File.exist?(@file_path) && (not File.zero?(@file_path))
        JSON.parse(File.read(@file_path), symbolize_names: true)
      else
        json_format = <<~JSON
          {
            "users": [

            ]
          }
        JSON

        JSON.parse(json_format, symbolize_names: true)
      end
    end

    def update_timestamp(user, timestamp)
      @data.fetch(:users, []).find {|u| u == user}[:timestamp] = timestamp
    end

    def get_timestamp(user)
      @data.fetch(:users, []).find {|u| u == user}[:timestamp] || 0
    end

    def get_user_by_puuid(puuid)
      @data.fetch(:users, []).find { |user| user.fetch(:puuid, nil) == puuid } || false
    end

    def get_user_by_summoner(name)
      @data.fetch(:users, []).find { |user| user.fetch(:summoner_name, nil) == name} || false
    end

    def get_puuid_by_user(user)
      user.fetch(:puuid, nil)
    end

    def get_matchups(user)
      user.fetch(:matchups, nil)
    end

    def add_matchup(user, matchup)
      @data.fetch(:users, []).find {|u| u == user}[:matchups] << matchup
    end

    def add_user(summoner_name, puuid, matchups=[])
      user = {:summoner_name => summoner_name, :puuid => puuid, :matchups => matchups}
      @data[:users] << user
      user
    end

    # ALL DATA TO BE USED IN PROGRAM IS IN @DATA , WRITE TO FILE ON EXIT
    def write_data
      File.write(@file_path, JSON.pretty_generate(@data))
    end
  end
end