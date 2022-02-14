# Wayland Variables for NVIDIA to work correctly
# ! RUNNING THIS FILE DOESN'T DO ANYTHING
# ! PLEASE SOURCE THIS FILE BEFORE STARTING ANY WLROOTS-BASED COMPOSITOR

# GBM backend
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia

# Hardware acceleration
export LIBVA_DRIVER_NAME=nvidia

