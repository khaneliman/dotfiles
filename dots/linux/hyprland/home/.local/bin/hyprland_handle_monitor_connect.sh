#!/usr/bin/env bash

function handle {
  if [[ ${1:0:12} == "monitoradded" ]]; then
    hyprland_setup_dual_monitors.sh;
  fi
}

socat - UNIX-CONNECT:/tmp/hypr/.socket2.sock | while read -r line; do handle "$line"; done
