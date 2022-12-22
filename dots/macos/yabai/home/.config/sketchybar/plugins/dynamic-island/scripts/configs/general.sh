#!/usr/bin/env/sh

# DYNAMIC ISLAND MODULES:
MUSIC_ENABLED=${P_DYNAMIC_ISLAND_MUSIC_ENABLED:=1}
APPSWITCH_ENABLED=${P_DYNAMIC_ISLAND_APPSWITCH_ENABLED:=1}
NOTIFICATION_ENABLED=${P_DYNAMIC_ISLAND_NOTIFICATION_ENABLED:=1}
VOLUME_ENABLED=${P_DYNAMIC_ISLAND_VOLUME_ENABLED:=1}

# FONT
FONT=${P_DYNAMIC_ISLAND_FONT:="SF Pro"}

# COLORS
WHITE=0xffffffff
PITCH_BLACK=0xff000000
TRANSPARENT=0x00000000
ICON_HIDDEN=$PITCH_BLACK
DEFAULT_LABEL=$WHITE
TRANSPARENT_LABEL=$TRANSPARENT

# NOTCH SIZE
MAX_HEIGHT=${P_DYNAMIC_ISLAND_MAX_HEIGHT:=90}
DEFAULT_HEIGHT=${P_DYNAMIC_ISLAND_DEFAULT_HEIGHT:=65}
DEFAULT_WIDTH=${P_DYNAMIC_ISLAND_DEFAULT_WIDTH:=205}
DEFAULT_CORNER_RADIUS=${P_DYNAMIC_ISLAND_DEFAULT_CORNER_RADIUS:=16}

# ANIMATION SETTINGS
SQUISH_AMOUNT=${P_DYNAMIC_ISLAND_SQUISH_AMOUNT:=7}

# MUSIC SOURCE
MUSIC_SOURCE=${P_DYNAMIC_ISLAND_MUSIC_SOURCE:="Music"}