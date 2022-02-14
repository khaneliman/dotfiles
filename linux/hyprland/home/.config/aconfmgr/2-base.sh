# Base packages
AddPackage base                 # Minimal package set to define a basic Arch Linux installation
AddPackage base-devel           # Minimal package set for arch development grou
AddPackage bluez                # Daemons for the bluetooth protocol stack
AddPackage bluez-utils          # Development and debugging utilities for the bluetooth protocol stack
AddPackage acpi                 # Client for battery, power, and thermal readings
AddPackage acpi_call-dkms       # A linux kernel module that enables calls to ACPI methods through /proc/acpi/call - module sources
AddPackage acpid                # A daemon for delivering ACPI power management events with netlink support
AddPackage arch-install-scripts # Scripts to aid in installing Arch Linux
AddPackage amd-ucode            # Microcode update image for AMD CPUs
AddPackage dhclient             # A standalone DHCP client from the dhcp package
AddPackage dhcpcd               # RFC2131 compliant DHCP client daemon
AddPackage bind                 # A complete, highly portable implementation of the DNS protocol
AddPackage binutils             # A set of programs to assemble and manipulate binary and object files
AddPackage bison                # The GNU general-purpose parser generator
AddPackage cups                 # The CUPS Printing System - daemon package
AddPackage gnome-keyring        # Stores passwords and encryption keys
AddPackage efibootmgr           # Linux user-space application to modify the EFI Boot Manager
AddPackage openssh              # SSH protocol implementation for remote login, command execution and file transfer
AddPackage linux                # The Linux kernel and modules
AddPackage linux-firmware       # Firmware files for Linux
AddPackage linux-headers        # Headers and scripts for building modules for the Linux kernel
AddPackage linux-zen            # The Linux ZEN kernel and modules
AddPackage linux-zen-headers    # Headers and scripts for building modules for the Linux ZEN kernel
AddPackage dnsmasq              # Lightweight, easy to configure DNS forwarder and DHCP server
AddPackage refind               # An EFI boot manager
AddPackage samba                # SMB Fileserver and AD Domain server
AddPackage nss-mdns             # glibc plugin providing host name resolution via mDNS
AddPackage pacman               # A library-based package manager with dependency support
AddPackage pacman-contrib       # Contributed scripts and tools for pacman systems
AddPackage sudo                 # Give certain users the ability to run some commands as root
AddPackage mkinitcpio-firmware  # Optional firmware for the default linux kernel to get rid of the annoying 'WARNING: Possibly missing firmware for module:' messages

# Fileystem
AddPackage ntfs-3g        # NTFS filesystem driver and utilities
AddPackage exfatprogs     # exFAT filesystem userspace utilities for the Linux Kernel exfat driver
AddPackage btrfs-progs    # Btrfs filesystem utilities
AddPackage nfs-utils      # Support programs for Network File Systems
AddPackage jfsutils       # JFS filesystem utilities
AddPackage findutils      # GNU utilities to locate files
AddPackage fuse2fs        # Ext2/3/4 filesystem driver for FUSE
AddPackage fuseiso        # FUSE module to mount ISO filesystem images
AddPackage udftools       # Linux tools for UDF filesystems and DVD/CD-R(W) drives
AddPackage squashfs-tools # Tools for squashfs, a highly compressed read-only filesystem for Linux
AddPackage ifuse          # A fuse filesystem to access the contents of an iPhone or iPod Touch

AddPackage gvfs         # Virtual filesystem implementation for GIO
AddPackage gvfs-afc     # Virtual filesystem implementation for GIO (AFC backend; Apple mobile devices)
AddPackage gvfs-goa     # Virtual filesystem implementation for GIO (Gnome Online Accounts backend; cloud storage)
AddPackage gvfs-google  # Virtual filesystem implementation for GIO (Google Drive backend)
AddPackage gvfs-gphoto2 # Virtual filesystem implementation for GIO (gphoto2 backend; PTP camera, MTP media player)
AddPackage gvfs-mtp     # Virtual filesystem implementation for GIO (MTP backend; Android, media player)
AddPackage gvfs-nfs     # Virtual filesystem implementation for GIO (NFS backend)
AddPackage gvfs-smb     # Virtual filesystem implementation for GIO (SMB/CIFS backend; Windows client)
AddPackage kio-fuse     # FUSE interface for KIO
AddPackage kio-gdrive   # KIO Slave to access Google Drive

# Compression
AddPackage gzip        # GNU compression utility
AddPackage dmg2img     # A CLI tool to uncompress Apple's compressed DMG files to the HFS+ IMG format
AddPackage unrar       # The RAR uncompression program
AddPackage file-roller # Create and modify archives
AddPackage p7zip       # Command-line file archiver with high compression ratio
AddPackage zip         # Compressor/archiver for creating and modifying zipfiles

# Graphics
AddPackage mesa              # An open-source implementation of the OpenGL specification
AddPackage mesa-utils        # Essential Mesa utilities
AddPackage cuda              # NVIDIA's GPU programming toolkit
AddPackage cuda-tools        # NVIDIA's GPU programming toolkit (extra tools: nvvp, nsight)
AddPackage cudnn             # NVIDIA CUDA Deep Neural Network library
AddPackage nvidia-cg-toolkit # NVIDIA Cg libraries
AddPackage nvidia-dkms       # NVIDIA drivers - module sources
AddPackage nvidia-prime      # NVIDIA Prime Render Offload configuration and utilities
AddPackage nvidia-settings   # Tool for configuring the NVIDIA graphics driver
AddPackage nvidia-utils-beta # NVIDIA drivers utilities (beta version)
AddPackage opencl-nvidia     # OpenCL implemention for NVIDIA
AddPackage egl-wayland       # EGLStream-based Wayland external platform
AddPackage ffnvcodec-headers # FFmpeg version of headers required to interface with Nvidias codec APIs

AddPackage --foreign nvidia-vaapi-driver-git # A VA-API implemention using NVIDIA's NVDEC
