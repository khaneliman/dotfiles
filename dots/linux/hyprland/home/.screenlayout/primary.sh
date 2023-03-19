#!/bin/sh

xrandr \
	--output XWAYLAND0 --mode 1920x1080 --pos 1420x0 --rotate normal \
	--output XWAYLAND1 --mode 5120x1440 --pos 0x1080 --rotate normal --primary
