function brew
  command brew $argv

  if test "$argv" = "upgrade" || test "$argv" = "update" || test "$argv" = "outdated"
    sketchybar --trigger brew_update
  end
end
