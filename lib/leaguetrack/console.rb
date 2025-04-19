module Leaguetrack
  class Console

    def initialize(app)
      @font = Artii::Base.new font: 'slant'
      @context = Leaguetrack::RootContext.new(self, app)
    end

    def start
      print_header
      loop do
        print @context.prompt.colorize(:light_blue)
        print "> "
        input = gets.chomp.strip
        break if input.downcase == "exit"
        @context.handle_input(input)
      end
    end

    def print_header
      puts @font.asciify("LeagueTrack").colorize(:green)
    end

    def switch_context(context)
      @context = context
    end


  end
end