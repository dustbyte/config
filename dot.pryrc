require 'awesome_print'

if defined?(PryByeBug)
  Pry.commands.alias_commad 'c', 'continue'
  Pry.config.commands.alias_command "l", "whereami"
  Pry.config.commands.alias_command "n", "next"
  Pry.config.commands.alias_command "s", "step"
  Pry.config.commands.alias_command "c", "continue"
end

Pry::Commands.command /^$/, "repeat last command" do
  _pry_.run_command Pry.history.to_a.last
end
