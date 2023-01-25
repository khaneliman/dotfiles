<h3 align="center">
 <img src="https://avatars.githubusercontent.com/u/1778670?v=4" width="100" alt="Logo"/><br/>
 <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
 Dotfiles for <a href="https://github.com/khaneliman">Khaneliman</a>
 <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
</h3>

<p align="center">
 <a href="https://github.com/khaneliman/dotfiles/stargazers"><img src="https://img.shields.io/github/stars/khaneliman/dotfiles?colorA=363a4f&colorB=b7bdf8&style=for-the-badge"></a>
 <a href="https://github.com/khaneliman/dotfiles/commits"><img src="https://img.shields.io/github/last-commit/khaneliman/dotfiles?colorA=363a4f&colorB=f5a97f&style=for-the-badge"></a>
 <a href="https://github.com/khaneliman/dotfiles/contributors"><img src="https://img.shields.io/github/contributors/khaneliman/dotfiles?colorA=363a4f&colorB=a6da95&style=for-the-badge"></a>
</p>

Personal dotfiles for each of the platforms I own or have customized. Personal information either redacted or encrypted with [Git-Crypt](https://github.com/AGWA/git-crypt).

## Install

### Clone repo:

    git clone --recurse-submodules https://github.com/khaneliman/dotfiles.git ~/.config/.dotfiles

Manual installation, for now. Some will have installation scripts to automate process a little more in-line with what I've been doing with [ArchInstaller](https://github.com/khaneliman/ArchInstaller)

### Manual

Copy files to respective directories:

- dots
  - OS
    - DE/WM
      - Location

Each environment might require further steps that will be detailed in their respective section.

### Automatic

    ./install.sh

The script will detect what OS you are running script from and perform the installation for that OS. You will need to select what environment you would like to install the dots for, if there are multiple for that given OS.

## Linux

There are numerous linux configs. My primary desktop usage is done through Arch Linux so I will update these most often.

### Awesome

This configuration is a glass effect [AwesomeWM](https://github.com/awesomeWM/awesome) with [Picom](https://github.com/yshui/picom) configuration. No utilities used for deployment, just basic dots. One of my first ricing attempts utilizing the glorious dotfiles as a base.

_Dotfiles might be out of sync with where they were in an optimized state since I rearranged dotfiles and switched most of my setups to using a catppuccin theme._

![linux-awesomewm-tiling](assets/linux-awesomewm-tiling.png)

### Hyprland

[Catppuccin](https://github.com/catppuccin/catppuccin) themed [Hyprland](https://github.com/hyprwm/Hyprland) configuration with a lot more time spent on it since it's my current daily driver. There's basic dotfiles and then some [aconfmgr](https://github.com/CyberShadow/aconfmgr) config thrown in for deploying a system. (WIP and not tested thoroughly)

#### Unique Install Steps

See the install steps in Hyrpland config's [README](/dots/linux/hyprland/README.md)

##### Standard Monitor

![linux-hyprland-tiling](assets/linux-hyprland-tiling.png)
![linux-hyprland-tiling](assets/linux-hyprland-nvim.png)

##### Ultrawide Monitor

![linux-hyprland-tiling](assets/linux-hyprland-tiling-wide.png)
![linux-hyprland-tiling](assets/linux-hyprland-nvim-wide.png)

### Gnome

Dotfiles from my brief usage of Fedora with Gnome. Currently sparse and only contains the [dconf](https://github.com/GNOME/dconf) files that can be imported using dconf.

## MacOS

I currently use [yabai](https://github.com/koekeishiya/yabai) with my daily driver MacBook Pro so this will contain the configuration used on my laptop.

### Yabai

Current window manager used on my laptop. Uses [sketchybar](https://github.com/FelixKratz/SketchyBar) for UI and [skhd](https://github.com/koekeishiya/skhd) for keybinds.

![macos-yabai-tiling](assets/macos-yabai-tiling.png)
![macos-yabai-nvim](assets/macos-yabai-nvim.png)

## Windows

I only use Windows for work and the rare VM access when needed. I have done some customization and will update this whenever I get a chance.

## Shared

This contains all the platform agnostic and / or shared application configurations that will be the same between all platforms and desktop environments.

## Credits

Inspiration and code from numerous locations all over the internet. Here's some of the major contributors to my setups.

- Shared dotfiles
  - [Catppuccin](https://github.com/catppuccin/catppuccin)
  - [AstroNvim](https://astronvim.github.io/)
- Linux dotfiles
  - Awesome
    - [The Glorious Dotfiles](https://github.com/manilarome/the-glorious-dotfiles)
  - Hyprland
    - [sway-nvidia](https://github.com/crispyricepc/sway-nvidia)
    - [Hyprland](https://wiki.hyprland.org/)
- macOS dotfiles
  - Yabai
    - [FelixKratz dotfiles](https://github.com/FelixKratz/dotfiles)
    - [crissNb Dynamic Island Sketchybar](https://github.com/crissNb/Dynamic-Island-Sketchybar)
