module Leaguetrack
  class NotesContext < Leaguetrack::BaseContext
    def setup_commands
      super
      local_commands = {
        # "add" => method(:add_topic),
        # "show" => method(:show)
      }
      @commands = @commands.merge(local_commands)
    end

    def prompt
      "LT NOTES"
    end

  end
end