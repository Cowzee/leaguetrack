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
      res = Lapi::Summoner::FindByName.new(@summoner).call
      puts res
    end
  end
end
 