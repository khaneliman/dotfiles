function brew
  command brew $argv

  if echo $argv | grep -qE 'upgrade|update|outdated'
    sketchybar --trigger brew_update
  end

  set dump_commands 'install' 'uninstall' # Include all commands that should do a brew dump
  set main_command $argv[1]

  for command in $dump_commands
    if test "$command" = "$main_command"
      brew bundle dump --file="$HOME/.Brewfile" --force
    end
  end
end

