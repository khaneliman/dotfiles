#!/bin/bash
#arrayStarted=true
#noParity=true
#version=v1.1.0 - 2020/01/03

snapshot_extension="snap"

# set this to force the for loop to split on new lines and not spaces.
IFS=$'\n'

# get a list of the vm names installed on the system.
vms=$(virsh list --all --name)

# loop through the vms in the list and try and back up their associated configs and vdisk(s).
for vm in $vms

do

  # see if a config file exists for the vm already and remove it.
  if [ -f "$vm.xml" ]; then
    rm -fv "$vm.xml"
  fi

  # dump the vm config locally.
  virsh dumpxml "$vm" > "$vm.xml"

  # replace xmlns value with absolute URI to avoid namespace warning.
  # sed isn't an ideal way to edit xml files, but few options are available on unraid.
  # this only edits a temporary file that is removed at the end of the script.
  sed -i 's|vmtemplate xmlns="unraid"|vmtemplate xmlns="http://unraid.net/xmlns"|g' "$vm.xml"


  # get the state of the vm for it is on before performing snapshot repair.
  vm_state=$(virsh domstate "$vm")

  # check whether to backup the vm or not.
  if [[ "$vm_state" == "running" ]]; then
    
    # get number of vdisks assoicated with the vm.
    vdisk_count=$(xmllint --xpath "count(/domain/devices/disk/source/@file)" "$vm.xml")

    # unset array for vdisks.
    unset vdisks
    # initialize vdisks as empty array
    vdisks=()

    # unset dictionary for vdisk_types.
    unset vdisk_specs
    # initailize vdisk_types as dictionary.
    declare -A vdisk_specs

    # get vdisk paths from config file.
    for (( i=1; i<=vdisk_count; i++ ))
    do
      vdisk_path="$(xmllint --xpath "string(/domain/devices/disk[$i]/source/@file)" "$vm.xml")"
      vdisk_spec="$(xmllint --xpath "string(/domain/devices/disk[$i]/target/@dev)" "$vm.xml")"

      vdisks+=("$vdisk_path")
      vdisk_specs["$vdisk_path"]="$vdisk_spec"
    done

    # check for the header in vdisks to see if there are any disks
    if [ ${#vdisks[@]} -eq 0 ]; then
      echo "information: there are no vdisk(s) associated with $vm."
    fi

    # get vdisk names to check on current backups
    for disk in "${vdisks[@]}"
    do
      if [[ -n "$disk" ]]; then

        # assume disk will be skipped.
        skip_disk="1"

        # get the extension of the disk.
        disk_extension="${disk##*.}"

        # disable case matching.
        shopt -s nocasematch

        # make sure disk has a snapshot extension
        if [ "$disk_extension" == "$snapshot_extension" ]; then
          skip_disk="0"
          echo "information: $disk on $vm is a snapshot."
        else
          skip_disk="1"
          echo "information: $disk on $vm is not a snapshot. skipping disk."
        fi

        # re-enable case matching.
        shopt -u nocasematch

        # get the filename of the disk without the path.
        new_disk=$(basename "$disk")

        # get directory of current disk.
        disk_directory=$(dirname "$disk")

        # remove trailing slash.
        disk_directory=${disk_directory%/}

        # get name of current disk without extension and add snapshot extension.
        snap_name="${new_disk%.*}.$snapshot_extension"


        # skip the vdisk if skip_disk is set to 1
        if [ "$skip_disk" -ne 1 ]; then


          # commit changes from snapshot.
          virsh blockcommit "$vm" "${vdisk_specs[$disk]}" --active --wait --verbose --pivot

          # wait 5 seconds.
          sleep 5
          echo "information: commited changes from snapshot for $disk on $vm."
          /usr/local/emhttp/plugins/dynamix/scripts/notify -s "VM Backup snapshot fix" -d "snapshot pivoted" -i "information" -m "$(date '+%Y-%m-%d %H:%M') information: commited changes from snapshot for $disk on $vm."

          # see if snapshot still exists.
          if [[ -f "$disk_directory/$snap_name" ]]; then

            # if it does, forcibly remove it.
            rm -fv "$disk_directory/$snap_name"
            echo "information: forcibly removed snapshot $disk_directory/$snap_name for $vm."
            /usr/local/emhttp/plugins/dynamix/scripts/notify -s "VM Backup snapshot fix" -d "snapshot removed" -i "information" -m "$(date '+%Y-%m-%d %H:%M') information: forcibly removed snapshot $disk_directory/$snap_name for $vm."
          fi
        fi
      fi
    done

  else

    # could not fix snapshot the vm was already running.
    echo "warning: could not remove snapshot because $vm is $vm_state."
    /usr/local/emhttp/plugins/dynamix/scripts/notify -s "VM Backup snapshot fix" -d "failed to fix $vm" -i "warning" -m "$(date '+%Y-%m-%d %H:%M') warining: could not remove snapshot because $vm is $vm_state. it is possible that no snapshot was associated with this vm."

  fi

  # delete the working copy of the config.
  rm -fv "$vm.xml"
  
done