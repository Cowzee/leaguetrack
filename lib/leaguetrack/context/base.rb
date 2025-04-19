module Leaguetrack
  class BaseContext
    def initialize(console, app, parent=nil)
      @console = console
      @app = app
      @parent = parent
      setup_commands
    end

    def setup_commands
      @commands = {
        "back" => method(:back),
        "exit" => method(:quit)
      }
    end

    def prompt
      "" #overwrite
    end

    def switch_to(context)
      @console.switch_context(context)
    end

    def handle_input(input)
      cmd, arg = tokenize(input)
      if @commands.key? cmd
        method_ref = @commands[cmd]
        if method_ref.arity == 0
          method_ref.call
        else
          method_ref.call(arg)
        end
      else
        puts "Unknown command #{cmd}".colorize(:red)
      end
    end
    
    def back
      @parent ? switch_to(@parent) : puts("Cannot go back")
    end

    def quit
      puts "Shutting down..."
      Kernel.exit
    end

    def tokenize(string)
      string.split(/\s+/, 2)
    end

  end
end