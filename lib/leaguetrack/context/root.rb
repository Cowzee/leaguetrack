module Leaguetrack
  class RootContext < Leaguetrack::BaseContext

    def setup_commands
      super
      local_commands = {
        "help" => method(:show_help),
        "matchup" => method(:to_matchup),
        "notes" => method(:to_notes),
      }
      @commands = @commands.merge(local_commands)
    end
    
    def prompt
      "LT"
    end

    def show_help
      puts "HELP" #TODO
    end

    def to_matchup
      switch_to(Leaguetrack::MatchupContext.new(@console, @app, self))
    end

    def to_notes
      switch_to(Leaguetrack::NotesContext.new(@console, @app, self))
    end
  end
end