function clear --description 'alias clear=clear && fastfetch'
  # OS Dependent config
  switch (uname)
    case Linux
      command clear && fastfetch | lolcat
    case Darwin
      command clear && fastfetch
  end
end
