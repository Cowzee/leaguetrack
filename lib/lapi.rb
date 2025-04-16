#add requires
require 'faraday'

module Lapi
  def api_key
    "test" #TODO - env
  end

  def host
    "league-api-host" #TODO - add real host
  end

end