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
      opts = OptionParser.new do |parser|
        parser.banner = "USAGE: leaguetrack [options]"
        parser.on("-u USERNAME", "--user USERNAME", "Sets user for api calls") do |user|
          @options[:username] = user
        end
        parser.on("-t TAG", "--tag TAG", "Sets tag for api calls") do |tag|
          @options[:tag] = tag
        end
        parser.on("-h", "--help", "Prints this help") do
          puts parser
          exit
        end
      end
      opts.parse!(@args)

      if @options[:username] and @options[:tag]
        Leaguetrack::App.new(@options[:username], @options[:tag]).init_run()
      else
        puts "Please enter a summoner name and tag.\n" + opts.to_s
      end


    end


  end
end