function fetch --description 'Perform logic based fetch'
  # OS Dependent config
  switch (uname)
    case Linux
        if [ -f "/etc/arch-release" ];
          command neofetch --source $HOME/.config/neofetch/arch
        else
          command fastfetch
        end
    case Darwin
      command fastfetch
  end
end
