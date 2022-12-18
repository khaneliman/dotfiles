# khaneliman dotfiles

<!--toc:start-->

- [khaneliman dotfiles](#khaneliman-dotfiles)
  - [Install](#install)
  - [Linux](#linux)
    - [Awesome](#awesome)
    - [Hyprland](#hyprland)
    - [Gnome](#gnome)
  - [MacOS](#macos)
    - [Yabai](#yabai)
  - [Windows](#windows)
  - [Shared](#shared)
  <!--toc:end-->

Personal dotfiles for each of the platforms I own or have customized. Personal information either redacted or encrypted with [Git-Crypt](https://github.com/AGWA/git-crypt).

## Install

Clone repo:

    git clone git@github.com:khaneliman/dotfiles.git ~/.config/.dotfiles

(Or, fork and keep your fork updated)

Copy files to respective directories:

- OS
  - DE/WM
    - Location

Manual installation, for now. Some will have installation scripts to automate process a little more in-line with what I've been doing with [ArchInstaller](https://github.com/khaneliman/ArchInstaller)

## Linux

There are numerous linux configs. My primary desktop usage is done through Arch Linux so I will update these most often.

### Awesome

This configuration is a glass effect [AwesomeWM](https://github.com/awesomeWM/awesome) with [Picom](https://github.com/yshui/picom) configuration. No utilities used for deployment, just basic dots. One of my first ricing attempts utilizing the glorious dotfiles as a base.

### Hyprland

[Catppuccin](https://github.com/catppuccin/catppuccin) themed [Hyprland](https://github.com/hyprwm/Hyprland) configuration with a lot more time spent on it since it's my current daily driver. There's basic dotfiles and then some [aconfmgr](https://github.com/CyberShadow/aconfmgr) config thrown in for deploying a system. (WIP and not tested thoroughly)

### Gnome

Dotfiles from my brief usage of Fedora with Gnome. Currently sparse and only contains the [dconf](https://github.com/GNOME/dconf) files that can be imported using dconf.

## MacOS

I currently use [yabai](https://github.com/koekeishiya/yabai) with my daily driver MacBook Pro so this will contain the configuration used on my laptop.

### Yabai

Current window manager used on my laptop. Uses [sketchybar](https://github.com/FelixKratz/SketchyBar) for UI and [skhd](https://github.com/koekeishiya/skhd) for keybinds.

## Windows

I only use Windows for work and the rare VM access when needed. I have done some customization and will update this whenever I get a chance.

## Shared

This contains all the platform agnostic and / or shared application configurations that will be the same between all platforms and desktop environments.
