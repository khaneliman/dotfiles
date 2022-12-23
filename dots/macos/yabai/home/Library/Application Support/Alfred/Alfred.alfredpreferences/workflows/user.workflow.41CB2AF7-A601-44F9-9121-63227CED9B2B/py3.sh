#!/bin/bash
#Set to 0 to use the first Python3 version found
PREFER_LATEST=1

#Array of python3 paths
PYPATHS=(/usr/bin /usr/local/bin)

#Input arguments
SCR="${1}"
QUERY="${2}"
WF_DATA_DIR=$alfred_workflow_data

#Create wf data dir if not available
[ ! -d "$WF_DATA_DIR" ] && mkdir "$WF_DATA_DIR"

SCRPATH="$0"
SCRIPT_DIR="$(dirname $SCRPATH)"

#Cache file for python binary - Allowes for faster execution
PYALIAS="$WF_DATA_DIR/py3"

CONFIG_PREFIX="Config"
DEBUG=0

pyrun() {
  $py3 "${SCR}" "${QUERY}"
  RES=$?
  [[ $RES -eq 127 ]] && handle_py_notfound
  return $RES
}

handle_py_notfound() {
  #we need this in case of some OS reconfiguration , python3 uninstalled ,etc..
  log_debug "python3 configuration changed, attemping to reconfigure"
  setup_python_alias
}

verify_not_stub() {
  PYBIN="${1}"
  $PYBIN -V > /dev/null 2>&1
  return $?
}

getver() {
  PYBIN="${1}"
  #Extract py3 version info and convert to comparable decimal
  VER=$($PYBIN -V |  cut -f2 -d" " | sed -E 's/\.([0-9]+)$/\1/')
  echo $VER
  log_debug "Version: $VER"
}

make_alias() {
  PYBIN="${1}"
  PYVER="$2"
  #last sanitization
  [ -z "${PYBIN}"  ] && log_msg "Error: invalid python3 path" && exit 255
  [ -z "${PYVER}" ] && PYVER="$(getver "$PYBIN")"
  echo "export py3='$PYBIN'" > "$PYALIAS"
  log_msg "Python3 was found at $PYBIN." "Version: $PYVER, Proceed typing query or re-run worfklow"
}

log_msg() {
  log_json "$CONFIG_PREFIX: $1" "$2"
  log_debug "$1"
}

log_json() {
#need to use json for notifications since we're in script filter
title="$1"
sub="$2"
[ -z "$sub" ] && sub="$title"
cat <<EOF
{
    "items": [
        {
            "title": "$title",
            "subtitle": "$sub",
        }
    ]
}
EOF
}

log_debug() {
  [[ $DEBUG -eq 1 ]] && echo "DEBUG: $*" >&2
}

setup_python_alias() {
  current_py=""
  current_ver=0.00
  for p in "${PYPATHS[@]}"
  do
    if [ -f $p/python3 ]
    then
      #check path does not contain a stub
      # set -x
      ! verify_not_stub "$p/python3"  && continue
      #check for latest py3 version
      if [ $PREFER_LATEST -eq 1 ]
      then
        thisver=$(getver $p/python3)
        if  [[ $(echo "$thisver > $current_ver" | bc -l) -eq 1 ]]
        then
          current_ver=$thisver
          current_py=$p/python3
        fi
      else
        #Just take the first valid python3 found
        make_alias "$p/python3"
        return 0
      fi
    fi
  done
  if [ $current_ver = 0.00 ]
  then
    log_msg "Error: no valid python3 version found" "Please locate python version and add to PYPATHS variable"
    exit 255
  fi
  make_alias "$current_py" "$current_ver"
  . "$PYALIAS"
}

#Main
if [ -f "$PYALIAS" ]
then
  . "$PYALIAS"
  pyrun
  exit
else
  setup_python_alias
fi