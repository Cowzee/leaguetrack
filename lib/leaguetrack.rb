# frozen_string_literal: true

require_relative "leaguetrack/version"
require_relative "lapi"
require_relative "leaguetrack/cli"
require "json"

module Leaguetrack
  class App
    def initialize(summoner)
      @summoner = summoner
    end

    def run
      res = Lapi::Summoner::FindByName.new(@summoner).call
      puts res
    end
  end
end
 