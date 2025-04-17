require 'optparse'

module Leaguetrack
  class CLI
    def self.start(args)
      self.new(args).run
    end

    def initialize(args)
      @args = args
      @options = {}
    end

    def run
      OptionParser.new do |parser|
        parser.banner = "USAGE: leaguetrack [options]"
        parser.on("-u USERNAME", "--user USERNAME", "Sets user for api") do |user|
          @options[:username] = user
        end
        parser.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end.parse!(@args)
      end

      if @options[:username]
        Leaguetrack::App.new(@options[:username]).run()
      end

    end


  end
end