#!/usr/bin/env bash
#github-action genshdoc
#
# ░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█░░░█▀▀░█░█░█▀▀░█▀▀░█░█░█▀▀
# ░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█░░░█░░░█▀█░█▀▀░█░░░█▀▄░▀▀█
# ░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀░░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀
#
# @file System Checks
# @brief Contains the functions used to perform various checks to safely run program
# @stdout Output routed to install.log
# @stderror Output routed to install.log

# @description Check if script is being ran in an arch linux distro
# @noargs
arch_check() {
    if [[ ! -e /etc/arch-release ]]; then
        echo -ne "ERROR! This script must be run in Arch Linux!\n"
        exit 0
    fi
}

# @description Check if script is run with root
# @noargs
root_check() {
    if [[ "$(id -u)" != "0" ]]; then
        echo -ne "ERROR! This script must be run under the 'root' user!\n"
        exit 0
    fi
}

# @description Checks if script run inside docker container
# @noargs
docker_check() {
    if awk -F/ '$2 == "docker"' /proc/self/cgroup | read -r; then
        echo -ne "ERROR! Docker container is not supported (at the moment)\n"
        exit 0
    elif [[ -f /.dockerenv ]]; then
        echo -ne "ERROR! Docker container is not supported (at the moment)\n"
        exit 0
    fi
}

# @description Checks if pacman lock exists
# @noargs
pacman_check() {
    if [[ -f /var/lib/pacman/db.lck ]]; then
        echo "ERROR! Pacman is blocked."
        echo -ne "If not running remove /var/lib/pacman/db.lck.\n"
        exit 0
    fi
}

# @description Checks if drive is mounted
# @noargs
mount_check() {
    if ! grep -qs '/mnt' /proc/mounts; then
        echo "Drive is not mounted can not continue"
        echo "Rebooting in 3 Seconds ..." && sleep 1
        echo "Rebooting in 2 Seconds ..." && sleep 1
        echo "Rebooting in 1 Second ..." && sleep 1
        reboot now
    fi
}

# @description Run all checks necessary before running script
# @noargs
background_checks() {
    root_check
    arch_check
    pacman_check
    docker_check
}

package_manager_check() {
    declare -A osInfo;

    osInfo[/etc/debian_version]="apt-get install -y"
    osInfo[/etc/alpine-release]="apk --update add"
    osInfo[/etc/centos-release]="yum install -y"
    osInfo[/etc/fedora-release]="dnf install -y"
    osInfo[/etc/arch-release]="pacman -Sy"

    for f in "${!osInfo[@]}"
    do
        if [[ -f $f ]];then
            package_manager=${osInfo[$f]}
        fi
    done 

    set_option "$package_manager_command"
}
