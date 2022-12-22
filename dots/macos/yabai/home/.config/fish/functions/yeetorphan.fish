function yeetorphan --wraps='pacman -Qtdq | pacman -Rns -' --wraps='pacman -Qtdq | sudo pacman -Rns -' --description 'alias yeetorphan=pacman -Qtdq | sudo pacman -Rns -'
  pacman -Qtdq | sudo pacman -Rns - $argv; 
end
