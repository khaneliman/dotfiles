function clear --description 'alias clear=clear && fastfetch'
  # OS Dependent config
  switch (uname)
    case Linux
        if [ -f "/etc/arch-release" ];
          command clear && fastfetch | lolcat
        else
          command clear && fastfetch
        end
    case Darwin
      command clear && fastfetch
  end
end
