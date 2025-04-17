#add requires
require 'faraday'
require 'json'
require_relative './lapi/client'
require_relative './lapi/summoner'
require_relative './lapi/match'


module Lapi
  def api_key
    "test" #TODO - env
  end

  def host
    "league-api-host" #TODO - add real host
  end

end