# Wayland Variables for NVIDIA to work correctly
# ! RUNNING THIS FILE DOESN'T DO ANYTHING
# ! PLEASE SOURCE THIS FILE BEFORE STARTING ANY WLROOTS-BASED COMPOSITOR

# Hardware cursors not yet working on wlroots
export WLR_NO_HARDWARE_CURSORS=1

# Set WLRoots renderer to Vulkan to avoid flickering
export WLR_RENDERER=vulkan

# General wayland environment variables
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM="wayland;xcb"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# Firefox wayland environment variable
export MOZ_ENABLE_WAYLAND=1
#export MOZ_USE_XINPUT2=1

# OpenGL Variables
export __GL_GSYNC_ALLOWED=0
export __GL_VRR_ALLOWED=0

# Toolkit backend variables
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONEREPARENTING=1
# export GDK_BACKEND="wayland,x11"

# Theme variables
export QT_QPA_PLATFORMTHEME='qt5ct'
export GTK_THEME='Catppuccin-Macchiato'
export XCURSOR_SIZE=12
export XCURSOR_THEME=Catppuccin-Mocha-Dark-Cursors
export GTK_USE_PORTAL=1
