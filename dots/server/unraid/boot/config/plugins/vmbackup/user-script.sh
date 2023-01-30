#!/bin/bash
#backgroundOnly=true
#arrayStarted=true
#noParity=true
#version=v0.2.3 - 2022/12/25

# based on unraid-vmbackup script version:
# v1.3.1 - 2020/01/21

#### DISCLAIMER ####
# Use at your own risk. This is a work-in-progress and provided as is.
# I have tested this on my own server, as best as I am able, but YMMV.
# -jtok


# what is the scripts' official name.
official_script_name="user-script.sh"

# set the name of the script to a variable so it can be used.
me=$(basename "$0")


# this script copies unRAID vm's vdisks and their configurations to a specified location.


################################################## script variables start ######################################################

# default 0 but set the master switch to 1 if you want to enable the script otherwise it will not run.
enabled="0"

# backup location to put vdisks.
backup_location=""

# default is 0. backup all vms or use vms_to_backup.
# when set to 1, vms_to_backup will be used as an exclusion list.
backup_all_vms="0"

# list of vms that will be backed up separated by a new line.
# if backup_all_vms is set to 1, this will be used as a list of vms to exclude instead.
vms_to_backup=""

# list of specific vdisks to be skipped separated by a new line. use the full path.
# NOTE: must match path in vm config file. remember this if you change the virtual disk path to enable snapshots.
vdisks_to_skip=""

# list of specific vdisk extensions to be skipped separated by a new line. this replaces the old ignore_isos variable.
vdisk_extensions_to_skip="iso"

# default is 0. use snapshots to backup vms.
# NOTE: vms that are backed up using snapshots will not be shutdown. if a vm is already shutdown the default backup method will be used.
# NOTE: it is highly recommended that you install the qemu guest agent on your vms before using snapshots to ensure the integrity of your backups.
# WARNING: this will fail if the config path for the virtual disk is /mnt/user/. you must use /mnt/cache/ or /mnt/diskX/ for snapshots to work.
use_snapshots="0"

# default is 0. set this to 1 if you would like to kill a vm if it cant be shutdown cleanly.
kill_vm_if_cant_shutdown="0"

# default is 1. set this to 0 if you do not want a vm to be started if it was running before the backup started. Paused VMs will be left stopped.
set_vm_to_original_state="1"

# default is 0. set this to the number of days backups should be kept. 0 means indefinitely.
number_of_days_to_keep_backups="0"

# default is 0. set this to the number of backups that should be kept. 0 means infinitely.
# WARNING: If VM has multiple vdisks, then they must end in sequential numbers in order to be correctly backed up (i.e. vdisk1.img, vdisk2.img, etc.).
number_of_backups_to_keep="0"

# default is 0. set this to 1 if you would like to perform inline zstd compression.  This overrides the "gzip_compress" and "compare_files" options.
inline_zstd_compress="0"

# default is 0. set this to 1 if you would like to compress backups. This can add a significant amount of time to the backup process. uses tar.gz for sparse file compatibility.
# this is the legacy setting for compression. if include_extra_files is set to 1, this setting will be disabled.
# WARNING: do not turn on if you already have uncompressed backups. You will need to move or delete uncompressed backups before using. this will compress all config, nvram, and vdisk images in the backup directory into ONE tarball.
gzip_compress="0"

# default is 1. set this to 0 if you would like to have backups without a timestamp. Timestamps are dropped only when number_of_backups_to_keep is equal to 1.
timestamp_files="1"

# default is 0. set this to 1 if you want to backup any extra files and folders that are in the directory of each backed up vdisk.
# this still honors vdisk_extensions_to_skip setting and vdisks_to_skip. this setting will be ignored if backup_vdisks is set to 0.
# NOTE: This is not compatible with gzip_compress. enabling this will disable gzip compression.
include_extra_files="0"


#### logging and notifications ####

# default is 1. set to 0 to have log file deleted after the backup has completed.
# NOTE: error logs are separate. settings for error logs can be found in the advanced variables.
keep_log_file="1"

# default is 1. number of successful log files to keep. 0 means infinitely.
number_of_log_files_to_keep="1"

# default is "logs". set to "" to put in root of backups folder. set to "logs/<subfolder>" to keep logs separate if running multiple versions of this script.
log_file_subfolder="logs/"

# default is 0. create a vm specific log in each vm's subfolder using the same retention policy as the vm's backups.
enable_vm_log_file="0"

# default is 1. set to 0 to prevent notification system from being used. Script failures that occur before logging can start, and before this variable is validated will still be sent.
send_notifications="1"

# default is 0. set to 1 to receive more detailed notifications. will not work with send_notifications disabled or only_send_error_notifications enabled.
detailed_notifications="0"


#### advanced variables ####

# default is snap. extension used when creating snapshots.
# WARNING: do not choose an extension that is the same as one of your vdisks or the script will error out. cannot be blank.
snapshot_extension="snap"

# default is 0. fallback to standard backup if snapshot creation fails.
# NOTE: this will act as though use_snapshots was disabled for just the vm with the failed snapshot command.
snapshot_fallback="0"

# default is 0. pause vms instead of shutting them down during standard backups.
# WARNING: this could result in unusable backups, but I have not thoroughly tested.
pause_vms="0"

# list of vms that will be backed up WITHOUT first shutting down separated by a new line. these must also be listed in vms_to_backup.
# NOTE: vms backed up via snapshot will not be shutdown (see use_snapshots option).
# WARNING: using this setting can result in an unusable backup. not recommended.
vms_to_backup_running=""

# default is 0. set to 1 to have reconstruct write (a.k.a. turbo write) enabled during the backup and then disabled after the backup completes.
# NOTE: may break auto functionality when it is implemented. do not use if reconstruct write is already enabled. backups may run faster with this enabled.
enable_reconstruct_write="0"

# default is 3. higher values may produce smaller archives but are slower and use more CPU.
zstd_level="3"

# default is 2. set this to the desired number of compression worker threads. set to 0 to auto detect the number of physical cpu cores.
zstd_threads="2"

# default is 6. choose the compression level for gzip to use. set to 1 for the lowest compression level, but the highest speed, and 9 is the highest compression level, but the lowest speed.
# this is the legacy setting for compression.
gzip_level="6"

# default is 0. set this to 1 to compare files after copy and run rsync in the event of failure. could add significant amount of time depending on the size of vms.
compare_files="0"

# default is 1. set to 0 if you would like to skip backing up xml configuration files.
backup_xml="1"

# default is 1. set to 0 if you would like to skip backing up nvram files.
backup_nvram="1"

# default is 1. set to 0 if you would like to skip backing up vdisks. setting this to 0 will automatically disable compression and include_extra_files.
backup_vdisks="1"

# default is 0. set this to 1 if you would like to start a vm after it has successfully been backed up. will override set_vm_to_original_state when set to 1.
start_vm_after_backup="0"

# default is 0. set this to 1 if you would like to start a vm after it has failed to have been backed up. will override set_vm_to_original_state when set to 1.
start_vm_after_failure="0"

# default is 0. set this to 1 to disable rsync delta syncs.
disable_delta_sync="0"

# default is 0. set this to 1 to always use rsync instead of cp.
# NOTE: rsync was significantly slower in my tests.
rsync_only="0"

# default is 1. set this to 0 if you would like to perform a dry-run backup.
# NOTE: dry run will not work unless rsync_only is set to 1. if this is set to 1 rsync_only will be set to 1.
actually_copy_files="1"

# default is 20. set this to the number of times you would like to check if a clean shutdown of a vm has been successful.
clean_shutdown_checks="20"

# default is 30. set this to the number of seconds to wait in between checks to see if a clean shutdown has been successful.
seconds_to_wait="30"

# default is 1. set to 0 to have error log files deleted after the backup has completed.
keep_error_log_file="1"

# default is 10. number of error log files to keep. 0 means infinitely.
number_of_error_log_files_to_keep="10"

# default is 0. set to 1 to only send error notifications.
only_send_error_notifications="0"

################################################## script variables end #########################################################


###################################################### script start #############################################################


#### define functions start ####

  # copy files based on passed arguments.
  copy_file () {
    # assign arguments to local variables for readability.
    local source="$1"
    local destination="$2"
    local rsync_dry_run_option="$3"
    local sync_type="$4"
    local rsync_only="$5"
    if [[ ! "$rsync_only" =~ ^[0-9]+$ ]]; then
      local rsync_only="0"
    fi

    # determine the copy command that should be ran and capture the result.
    case "$sync_type" in
      "standard")
        # perform standard rsync.
        rsync -av"$rsync_dry_run_option" "$source" "$destination"
        local copy_result="$?"
        ;;

      "inline_zstd_compress")
        # perform inline zstd compression (with sparse file support).
        zstd -$zstd_level -T$zstd_threads --sparse "$source" -o "$destination"
        local copy_result="$?"
        ;;

      "sparse")
        # perform rsync or copy with support for sparse files.
        if [ "$rsync_only" -eq 1 ]; then
          rsync -av"$rsync_dry_run_option" --sparse "$source" "$destination"
          local copy_result="$?"

        else

          cp -av --sparse=always "$source" "$destination"
          local copy_result="$?"
        fi
        ;;

      "inplace")
        # perform inplace copy (i.e. delta sync).
        rsync -av"$rsync_dry_run_option" --inplace --no-whole-file "$source" "$destination"
        ;;

      "mkpath")
        # perform inplace copy (i.e. delta sync).
        rsync -av"$rsync_dry_run_option" --mkpath "$source" "$destination"
        ;;

      *)
        # no valid copy choice was able to be ran.
        log_message "failure: no valid copy choice was able to run for copy of $source to $destination failed." "copy failed" "alert"

        # exit the function
        return 1
        ;;
    esac

    # get rsync result and send notification
    if [[ "$copy_result" -eq 1 ]]; then
      log_message "failure: copy of $source to $destination failed." "copy failed" "alert"

    else

      # set actually_copy_files based rsync_dry_run_option
      if [ "$rsync_dry_run_option" == "n" ]; then
        local actually_copy_files="0"

      else

        local actually_copy_files="1"
      fi

      # send a message to the user based on whether there was an actual copy or a dry-run.
      if [ "$actually_copy_files" -eq 0 ]; then
        log_message "information: dry-run copy of $source to $destination complete."

      else

        log_message "information: copy of $source to $destination complete." "completed copy" "normal"

      fi
    fi
  }

  # pass log messages to log files and system notifications.
  log_message () {

    # assign arguments to local variables for readability.
    local message="$1"
    local description="$2"
    local importance="$3"

    case "$importance" in
      "information")
        local is_error="0"
        ;;
      "alert")
        local is_error="1"
        ;;
      "warning")
        local is_error="1"
        ;;
      *)
        local is_error="0"
        ;;
      esac

    if [ "$description" ] && [ "$importance" ]; then
      local enable_detailed_notifications="1"
    else
      local enable_detailed_notifications="0"
    fi
    local force_notification="$4"

    # add the message to the main log file.
    echo "$(date '+%Y-%m-%d %H:%M:%S') $message" | tee -a "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup.log"

    # add the message to the vm specific log file if enabled.
    if [[ -n "$vm_log_file" ]] && [ "$enable_vm_log_file" -eq 1 ]; then
      echo "$(date '+%Y-%m-%d %H:%M:%S') $message" >> "$vm_log_file"
    fi

    # check to see if the message is an error message.
    if [ "$is_error" -eq 1 ]; then

      # mark that the script encountered an error.
      errors="1"

      # send a notification if they are enabled.
      if [ "$send_notifications" -eq 1 ] || [ "$force_notification" == "force_notification" ]; then
        /usr/local/emhttp/plugins/dynamix/scripts/notify -s "unRAID VM Backup script" -d "$description" -i "$importance" -m "$(date '+%Y-%m-%d %H:%M:%S') $message"
      fi
    fi

    # send a detailed notification if it is enabled and if they should be used.
    if [ "$enable_detailed_notifications" -eq 1 ] && [ "$detailed_notifications" -eq 1 ]; then
      if [ "$send_notifications" -eq 1 ] && [ "$only_send_error_notifications" -eq 0 ]; then
        /usr/local/emhttp/plugins/dynamix/scripts/notify -s "unRAID VM Backup script" -d "$description" -i "$importance" -m "$(date '+%Y-%m-%d %H:%M:%S') $message"
      fi
    fi
  }

  # pass notification messages to system notifications.
  notification_message () {

    # assign arguments to local variables for readability.
    local message="$1"
    local description="$2"
    local importance="$3"

    # show the message in the log.
    echo "$(date '+%Y-%m-%d %H:%M:%S') $message"

    # send message notification.
    if [[ -n "$description" ]] && [[ -n "$importance" ]]; then
      /usr/local/emhttp/plugins/dynamix/scripts/notify -s "unRAID VM Backup script" -d "$description" -i "$importance" -m "$(date '+%Y-%m-%d %H:%M:%S') $message"
    fi
  }

  # compare two files.
  run_compare () {

    # assign arguments to local variables for readability.
    local source="$1"
    local destination="$2"
    local file_type="$3"

    # check to see if compare_files is enabled. if yes, check for config differences.
    if [ "$compare_files" -eq 1 ]; then
      if ! cmp -s "$source" "$destination"; then
        log_message "warning: $file_type file for $vm is different than source file. retrying backup." "$(basename "$source") compare failed" "warning"

        case "$file_type" in
          "config")
            copy_file "$source" "$destination" "$rsync_dry_run_option" "standard" "$rsync_only"
            ;;
          "nvram")
            copy_file "$source" "$destination" "$rsync_dry_run_option" "standard" "$rsync_only"
            ;;
          "vdisk")
            copy_file "$source" "$destination" "$rsync_dry_run_option" "sparse" "$rsync_only"
            ;;
          *)
            log_message "warning: unable to re-run copy command for $source. file_type is $file_type." "$(basename "$source") compare copy failed" "warning"
            ;;
        esac

        # make sure copy has current date/time for modified attribute so that removing old backups by date will work.
        touch -d "now" "$destination"

        if ! cmp -s "$source" "$destination"; then
          log_message "failure: $file_type file for $vm failed second comparison." "$(basename "$source") second compare failed" "alert"

        else

          log_message "information: $file_type file for $vm passed second comparison. moving on."
        fi

      else

        log_message "information: $file_type file for $vm matches source file. moving on."
      fi
    fi
  }

  # copy vdisks.
  copy_vdisks () {

    # assign arguments to local variables for readability.
    local mode="$1"

    # get number of vdisks assoicated with the vm.
    vdisk_count=$(xmllint --xpath "count(/domain/devices/disk/source/@file)" "$vm.xml")

    # unset array for vdisks.
    unset vdisks
    # initialize vdisks as empty array
    vdisks=()

    # unset dictionary for vdisk_types.
    unset vdisk_types
    # initailize vdisk_types as dictionary.
    declare -A vdisk_types

    # unset dictionary for vdisk_types.
    unset vdisk_specs
    # initailize vdisk_types as dictionary.
    declare -A vdisk_specs

    # get vdisk paths from config file.
    for (( i=1; i<=vdisk_count; i++ ))
    do
      vdisk_path="$(xmllint --xpath "string(/domain/devices/disk[$i]/source/@file)" "$vm.xml")"
      vdisk_type="$(xmllint --xpath "string(/domain/devices/disk[$i]/driver/@type)" "$vm.xml")"
      vdisk_spec="$(xmllint --xpath "string(/domain/devices/disk[$i]/target/@dev)" "$vm.xml")"

      vdisks+=("$vdisk_path")
      vdisk_types["$vdisk_path"]="$vdisk_type"
      vdisk_specs["$vdisk_path"]="$vdisk_spec"
    done

    # check for the header in vdisks to see if there are any disks
    if [ ${#vdisks[@]} -eq 0 ]; then
      log_message "warning: there are no vdisk(s) associated with $vm to backup." "no vdisk(s) for $vm" "warning"
    fi

    # unset array for vdisk_extensions.
    unset vdisk_extensions
    # initialize vdisk_extensions as empty array.
    vdisk_extensions=()

    # get vdisk names to check on current backups
    for disk in "${vdisks[@]}"
    do

      if [[ -n "$disk" ]]; then

        # assume disk will not be skipped.
        skip_disk="0"

        # check to see if vdisk should be explicitly skipped.
        for skipvdisk_name in $vdisks_to_skip
        do

          if [ "$skipvdisk_name" == "$disk" ]; then
            skip_disk="1"
            log_message "information: $disk on $vm was found in vdisks_to_skip. skipping disk."
          fi
        done

        # get the extension of the disk.
        disk_extension="${disk##*.}"

        # disable case matching.
        shopt -s nocasematch

        # check to see if vdisk extension is the same as the snapshot extension. if it is, error and skip the vm.
        if [[ "$disk_extension" == "$snapshot_extension" ]]; then
          log_message "failure: extension for $disk on $vm is the same as the snapshot extension $snapshot_extension. disk will always be skipped. this usually means that the disk path in the config was not changed from /mnt/user. if disk path is correct, then try changing snapshot_extension or vdisk extension." "cannot backup vdisk on $vm" "alert"
        fi

        # check to see if vdisk should be skipped by extension.
        for skipvdisk_extension in $vdisk_extensions_to_skip
        do

          if [[ "$skipvdisk_extension" == "$disk_extension" ]]; then
            skip_disk="1"
            log_message "information: extension for $disk on $vm was found in vdisks_extensions_to_skip. skipping disk."
          fi
        done

        # re-enable case matching.
        shopt -u nocasematch

        # get the filename of the disk without the path.
        new_disk=$(basename "$disk")

        if [ "$mode" == "existing_backup" ]; then

          # unset vairiable for disk_number
          unset -v disk_number

          # get the disk number and extension
          vdisknameregex="[0-9]+\\.$disk_extension"
          if [[ $disk =~ $vdisknameregex ]]; then
            disk_number=${BASH_REMATCH[0]}
          fi

          # skip the vdisk if skip_disk is set to 1
          if [ "$skip_disk" -ne 1 ]; then

            # unset variable for the most recent vdisk file.
            unset -v newest_vdisk_file

            # see if disk_number is empty. if not, set to wildcard.
            if [[ -z "$disk_number" ]]; then
              disk_number='.@'$disk_extension''
            fi

            # enable extended globbing
            shopt -s extglob

            # get the most recent vdisk file.
            for diskimage in "$backup_location/$vm/"*"$disk_number"
            do
              [[ $diskimage -nt $newest_vdisk_file ]] && newest_vdisk_file=$diskimage
            done

            # disable extended globbing
            shopt -u extglob

            # check to see if a backup already exists for this vdisk and make a copy of it before shutting down the guest.
            if [[ -f "$newest_vdisk_file" ]]; then
              log_message "information: copy of backup of $newest_vdisk_file vdisk to $backup_location/$vm/$timestamp$new_disk starting." "script starting copy $vm backup" "normal"

              # call function copy_files to copy existing backup
              copy_file "$newest_vdisk_file" "$backup_location/$vm/$timestamp$new_disk" "$rsync_dry_run_option" "sparse" "$rsync_only"

              # make sure copy has current date/time for modified attribute so that removing old backups by date will work.
              touch -d "now" "$backup_location/$vm/$timestamp$new_disk"
            fi

            # check to see if extra files should be backed up.
            if [ "$include_extra_files" -eq 1 ]; then
              # get the path of the disk without the filename.
              disk_path=$(dirname "$disk")

              # call function copy_extra_files to copy any files and folders that are in the disk path.
              copy_extra_files "$disk_path" "$vm" vdisks
            fi

          fi

        elif [ "$mode" == "source_image" ]; then

          # skip the vdisk if skip_disk is set to 1
          if [ "$skip_disk" -ne 1 ]; then

            # add the extension of the disk being backed up to an array of vdisk extensions if it doesn't already exist
            # set variable extension_exists to false.
            extension_exists=false

            # for each extension check to see if it is already in the array.
            for extension in "${vdisk_extensions[@]}"
            do

              # if the extension already exists in the array set extension_exists to true and break out of the current loop.
              if [ "$extension" == "$disk_extension" ]; then
                extension_exists=true
                break
              fi
            done

            # if the extension was not found in the array add it.
            if [ "$extension_exists" = false ]; then
              vdisk_extensions+=("$disk_extension")
            fi

            # check to see if snapshots should be used, and if the vm is running.
            if [ "$use_snapshots" -eq 1 ] && [ "$vm_state" == "running" ]; then
              snapshot_using_traditional_backup=false
              log_message "information: able to perform snapshot for disk $disk on $vm. use_snapshots is $use_snapshots. vm_state is $vm_state. vdisk_type is ${vdisk_types[$disk]}"

              # set variable for qemu agent is installed.
              qemu_agent_installed=$(virsh qemu-agent-command "$vm" '{"execute":"guest-info"}' | grep -c "version" | awk '{ print $0 }')

              # get directory of current disk.
              disk_directory=$(dirname "$disk")

              # remove trailing slash.
              disk_directory=${disk_directory%/}

              # get name of current disk without extension and add snapshot extension.
              snap_name="${new_disk%.*}.$snapshot_extension"

              # check to see if qemu agent is installed for snapshot creation command.
              if [[ "$qemu_agent_installed" -eq 1 ]]; then

                # set quiesce to enabled.
                quiesce="--quiesce"
                log_message "information: qemu agent found. enabling quiesce on snapshot."

              else

                # set quiesce to disabled.
                quiesce=""
                log_message "information: qemu agent not found. disabling quiesce on snapshot."
              fi

              # create snapshot command.
              # unset array for snapshot_cmd.
              unset snapshot_cmd
              # initialize snapshot_cmd as empty array.
              snapshot_cmd=()

              # find each vdisk_spec and use it to build a snapshot command.
              for vdisk_spec in "${vdisk_specs[@]}"
              do

                # check to see if snapshot command is empty.
                if [ ${#snapshot_cmd[@]} -eq 0 ]; then

                  # build intial snapshot command.
                  snapshot_cmd=(virsh)
                  snapshot_cmd+=(snapshot-create-as)
                  snapshot_cmd+=(--domain "$vm")
                  snapshot_cmd+=(--name "$vm-$snap_name")

                  # check to see if this is the vdisk we are currently working with.
                  if [ "$vdisk_spec" == "${vdisk_specs[$disk]}" ]; then

                    # if it is, set the command to make a snapshot.
                    snapshot_cmd+=(--diskspec "$vdisk_spec,file=$disk_directory/$snap_name,snapshot=external")

                  else

                    # if it is not, set the command to not make a snapshot.
                    snapshot_cmd+=(--diskspec "$vdisk_spec,snapshot=no")
                  fi

                else

                  # add additional extensions to snapshot command.
                  # check to see if this is the vdisk we are currently working with.
                  if [ "$vdisk_spec" == "${vdisk_specs[$disk]}" ]; then

                    # if it is, set the command to make a snapshot.
                    snapshot_cmd+=(--diskspec "$vdisk_spec,file=$disk_directory/$snap_name,snapshot=external")

                  else

                    # if it is not, set the command to not make a snapshot.
                    snapshot_cmd+=(--diskspec "$vdisk_spec,snapshot=no")
                  fi
                fi
              done

              # add additonal options to snapshot command.
              snapshot_cmd+=(--disk-only)
              snapshot_cmd+=(--no-metadata)
              snapshot_cmd+=(--atomic)

              # check to see if snapshot command should include --quiesce.
              if [[ -n "$quiesce" ]]; then
                snapshot_cmd+=("$quiesce")
              fi

              # create snapshot.
              if ! "${snapshot_cmd[@]}"; then
                snapshot_succeeded=false
                log_message "failure: snapshot command failed on $snap_name for $vm." "$vm snapshot failed" "alert"

                # attempt backup using fallback method.
                if [ "$snapshot_fallback" -eq 1 ]; then
                  log_message "warning: snapshot_fallback is $snapshot_fallback. attempting backup for $vm using fallback method." "$vm fallback backup" "warning"

                  # get the state of the vm for making sure it is off before backing up.
                  vm_state=$(virsh domstate "$vm")

                  # get the state of the vm for putting the VM in it's original state after backing up.
                  vm_original_state=$vm_state

                  # initialize skip_vm_shutdown variable as false.
                  skip_vm_shutdown=false

                  # determine if vm should be kept running.
                  # first check to see if vm exists in vms_to_backup_running variable.
                  for vm_to_keep_running in $vms_to_backup_running
                  do

                    if [[ "$vm_to_keep_running" == "$vm" ]]; then
                      skip_vm_shutdown=true
                    fi
                  done

                  # if vm is not found in vms_to_backup_running and use_snapshots is disabled, then skip shutdown proceedure.
                  if [ "$skip_vm_shutdown" = false ]; then
                    log_message "information: skip_vm_shutdown is false. beginning vm shutdown procedure."

                    # prepare vm for backup.
                    prepare_vm "$vm" "$vm_state"

                  elif [ "$skip_vm_shutdown" = true ]; then
                    can_backup_vm="y"
                    log_message "information: skip_vm_shutdown is $skip_vm_shutdown and use_snapshots is $use_snapshots. skipping vm shutdown procedure. $vm is $vm_state. can_backup_vm set to $can_backup_vm."

                  else

                    log_message "failure: skip_vm_shutdown is $skip_vm_shutdown and use_snapshots is $use_snapshots. skipping vm shutdown procedure. $vm is $vm_state. can_backup_vm set to $can_backup_vm." "$vm backup failed" "alert"
                  fi

                # break out of current vdisk loop to prevent potential data loss.
                else

                  log_message "failure: snapshot_fallback is $snapshot_fallback. skipping backup for $vm to prevent data loss. no cleanup will be performed for this vm." "$vm snapshot failed" "alert"
                  break
                fi

              else

                snapshot_succeeded=true
                log_message "information: snapshot command succeeded on $snap_name for $vm."
              fi

            elif [ "$use_snapshots" -eq 1 ] && [ ! "$vm_state" == "running" ]; then
              snapshot_using_traditional_backup=true
              log_message "information: unable to perform snapshot for disk $disk on $vm. falling back to traditional backup. use_snapshots is $use_snapshots. vm_state is $vm_state. vdisk_type is ${vdisk_types[$disk]}."
            fi

            local dest_disk="$backup_location/$vm/$new_disk"

            if [ "$timestamp_files" -eq 1 ] || [ "$number_of_backups_to_keep" -ne 1 ]; then
              # if timestamps are enabled or more than one backup is being kept, add a timestamp to the destination filename.
              dest_disk="$backup_location/$vm/$timestamp$new_disk"
            fi

            # copy or pretend to copy the vdisk to the backup location specified by the user.
            if [ "$inline_zstd_compress" -eq 1 ]; then
              # if inline_zstd_compress is enabled, add ".zst" to the destination filename, and don't run the comparison.
              dest_disk+=".zst"
              copy_file "$disk" "$dest_disk" "$rsync_dry_run_option" "inline_zstd_compress" "$rsync_only"
            else

              if [ -f "$dest_disk" ]; then
                # if there is an existing backup, use rsync to just copy the changes (i.e. delta_sync).
                copy_file "$disk" "$dest_disk" "$rsync_dry_run_option" "inplace" "$rsync_only"
              else
                # otherwise, copy the whole file (with sparse support)
                copy_file "$disk" "$dest_disk" "$rsync_dry_run_option" "sparse" "$rsync_only"
              fi

              # run compare function. compare will not run if compare_files is disabled.
              run_compare "$disk" "$dest_disk" "vdisk"
            fi

            # make sure the copy has the current date/time for the modified attribute so that removing old backups by date will work.
            touch -d "now" "$dest_disk"

            # send a message to the user based on whether there was an actual copy or a dry-run.
            if [ "$actually_copy_files" -eq 0 ]; then
              log_message "information: dry-run backup of $disk vdisk to $dest_disk complete."
            else
              log_message "information: backup of $disk vdisk to $dest_disk complete."
            fi

            # check to see if snapshot was created.
            if [[ "$snapshot_succeeded" = true ]] && [[ ! "$snapshot_using_traditional_backup" = true ]]; then

              # verify vm is still running before attempting to commit changes from snapshot.
              if [ "$vm_state" == "running" ]; then

                # commit changes from snapshot.
                virsh blockcommit "$vm" "${vdisk_specs[$disk]}" --active --wait --verbose --pivot

                # wait 5 seconds.
                sleep 5
                log_message "information: commited changes from snapshot for $disk on $vm."

                # see if snapshot still exists.
                if [[ -f "$disk_directory/$snap_name" ]]; then

                  # if it does, forcibly remove it.
                  rm -fv "$disk_directory/$snap_name"
                  log_message "information: forcibly removed snapshot $disk_directory/$snap_name for $vm."
                fi

              else

                log_message "warning: snapshot performed for $vm, but vm state is $vm_state. cannot commit changes from snapshot." "script skipping $vm" "warning"
              fi
            fi

            # check to see if extra files should be backed up.
            if [ "$include_extra_files" -eq 1 ]; then
              # get the path of the disk without the filename.
              disk_path=$(dirname "$disk")

              # call function copy_extra_files to copy any files and folders that are in the disk path.
              copy_extra_files "$disk_path" "$vm" vdisks
            fi
          fi
        fi
      fi
    done
  }

  # copy extra files.
  copy_extra_files () {

    # assign arguments to local variables for readability.
    local _copy_path="$1"
    local _vm="$2"
    local -n _vdisks="$3"

    log_message "information: beginning copy of extra files in path: $_copy_path for VM $_vm." "script starting copy of extra files for $_vm" "normal"

    # get a list of files in the directory of the disk.
    extra_files=$(find "$_copy_path" -type f)

    # loop through the list of files and copy them to the backup location.
    for extra_file in $extra_files
    do

      # assume file will not be skipped.
      skip_file="0"

      # get the extension of the file.
      file_extension="${extra_file##*.}"

      # disable case matching.
      shopt -s nocasematch

      # check to see if extra file is an existing vdisk
      for disk in "${_vdisks[@]}"
      do
        # check to see if extra file is a vdisk.
        if [[ "$extra_file" == "$disk" ]]; then
          skip_file="1"
          log_message "information: $extra_file on $_vm is a vdisk. skipping file."
        fi
      done

      # check to see if extra file extension is the same as the snapshot extension. if it is, skip the file.
      if [[ "$file_extension" == "$snapshot_extension" ]]; then
        skip_file="1"
        log_message "information: extension for $extra_file on $_vm is the same as the snapshot extension $snapshot_extension. This means this is probably the snapshot file and this message can be ignored." "cannot backup extra file on $_vm" "normal"
      fi

      # check to see if extra file should be skipped by extension.
      for skipvdisk_extension in $vdisk_extensions_to_skip
      do
        if [[ "$file_extension" == "$skipvdisk_extension" ]]; then
          skip_file="1"
          log_message "information: extension for $extra_file on $_vm was found in vdisks_extensions_to_skip. skipping file."
        fi
      done

      # re-enable case matching.
      shopt -u nocasematch

      # skip the extra file if skip_file is set to 1
      if [ "$skip_file" -ne 1 ]; then
        # get the basename of the file to be copied.
        extra_file_name=$(basename "$extra_file")

        # get the relative path of the file to be copied without the basename.
        extra_file_relative_path=$(realpath --relative-base "$_copy_path" "$extra_file")
        extra_file_relative_path=$(dirname "$extra_file_relative_path")
        # remove all periods from the relative path.
        extra_file_relative_path=${extra_file_relative_path//./}

        # copy the file to the backup location.
        log_message "information: copy of backup of $_copy_path/$extra_file_relative_path/$extra_file_name file to $backup_location/$_vm/$extra_file_relative_path/$timestamp$extra_file_name starting." "script starting copy $_vm file $extra_file" "normal"
        copy_file "$_copy_path/$extra_file_relative_path/$extra_file_name" "$backup_location/$_vm/$extra_file_relative_path/$timestamp$extra_file_name" "$rsync_dry_run_option" "mkpath"

        # make sure copy has current date/time for modified attribute so that removing old backups by date will work.
        touch -d "now" "$backup_location/$_vm/$extra_file_relative_path/$timestamp$extra_file_name"
      fi
    done
  }

  # build vdisk_extensions_find_cmd.
  build_vdisk_extensions_find_cmd () {

    # assign arguments to local variables for readability.
    local search_directory="$1"

    # unset array vdisk_extensions_find_cmd.
    unset vdisk_extensions_find_cmd
    # initialize vdisk_extensions_find_cmd as empty array.
    vdisk_extensions_find_cmd=()

    # find each vdisk extension and use it to build a find command.
    for extension in "${vdisk_extensions[@]}"
    do

      local _ext="$extension"
      if [ "$inline_zstd_compress" -eq 1 ]; then
        _ext+=".zst"
      fi

      # check to see if find command is empty.
      if [ ${#vdisk_extensions_find_cmd[@]} -eq 0 ]; then

        # build initial find command.
        vdisk_extensions_find_cmd=(find)
        vdisk_extensions_find_cmd+=("$search_directory")
        vdisk_extensions_find_cmd+=(-type f)
        vdisk_extensions_find_cmd+=(\()
        vdisk_extensions_find_cmd+=(-name '*.'"$_ext")

      else

        # add additional extensions to find command.
        vdisk_extensions_find_cmd+=(-or -name '*.'"$_ext")
      fi
    done

    # put closing parenthesis on find command.
    vdisk_extensions_find_cmd+=(\))
  }

  # build remove_old_files_cmd.
  build_remove_old_files_cmd () {

    # assign arguments to local variables for readability.
    local search_directory="$1"

    # remove config, nvram, and image files that were compressed.
    # unset array remove_old_files_cmd.
    unset remove_old_files_cmd
    # initialize remove_old_files_cmd as empty array.
    remove_old_files_cmd=()

    # find each vdisk extension and use it to build a remove command.
    for extension in "${vdisk_extensions[@]}"
    do

      # check to see if remove command is empty.
      if [ ${#remove_old_files_cmd[@]} -eq 0 ]; then

        # build intial remove command.
        remove_old_files_cmd=(find)
        remove_old_files_cmd+=("$search_directory")
        remove_old_files_cmd+=(-type f)
        remove_old_files_cmd+=(\()
        remove_old_files_cmd+=(-name '*.'"$extension")

      else

        # add additional extensions to remove command.
        remove_old_files_cmd+=(-or -name '*.'"$extension")
      fi
    done

    # add config files to remove command.
    remove_old_files_cmd+=(-or -name '*.xml')

    # add nvram files to remove command.
    remove_old_files_cmd+=(-or -name '*.'"$nvram_extension")

    # put closing parenthesis on remove command.
    remove_old_files_cmd+=(\))

    # add delete command to remove command.
    remove_old_files_cmd+=(-delete)
  }

  # remove old files
  remove_old_files () {

    # assign arguments to local variables for readability.
    local -n _find_cmd=$1
    local _type="$2"

    # create variable equal to number_of_days_to_keep_backups plus one to make sure that there are files younger than the cutoff date.
    local _days_plus_one=$((number_of_days_to_keep_backups + 1))
    local _days_to_mins=$((24*60))

    local _deleted_files
    if [[ -n $("${_find_cmd[@]}" -mmin -$((_days_plus_one*_days_to_mins))) ]]; then
      _deleted_files=$("${_find_cmd[@]}" -mmin +$((number_of_days_to_keep_backups*_days_to_mins)) -delete -print)
    fi
    if [[ -n "$_deleted_files" ]]; then
      for _deleted_file in $_deleted_files
      do
        log_message "information: $_deleted_file $_type file." "script removing $_type file" "normal"
      done
    else
      log_message "information: did not find any $_type files to remove." "script removing $_type file" "normal"
    fi
  }

  # remove over limit files
  remove_over_limit_files () {

    # assign arguments to local variables for readability.
    local -n _find_cmd=$1
    local _number_of_files_to_keep="$2"
    local _type="$3"

    local _deleted_files
    _deleted_files=$("${_find_cmd[@]}" -printf '%T@\t%p\n' | sort -t $'\t' -gr | tail -n +$((_number_of_files_to_keep + 1)) | cut -d $'\t' -f 2- | xargs -d '\n' -r rm -fv --)
    if [[ -n "$_deleted_files" ]]; then
      for _deleted_file in $_deleted_files
      do
        log_message "information: $_deleted_file $_type file." "script removing $_type file" "normal"
      done
    else
      log_message "information: did not find any $_type files to remove." "script removing $_type file" "normal"
    fi
  }

  # prepare vm for backup.
  prepare_vm () {

    # assign arguments to local variables for readability.
    local vm="$1"
    local vm_state="$2"

    if [ "$pause_vms" -eq 1 ]; then
      vm_desired_state="paused"
    else
      vm_desired_state="shut off"
    fi

    # check to see if the vm is in the desired state.
    if [ "$vm_state" == "$vm_desired_state" ]; then

      # set a flag to check later to indicate whether to backup this vm or not.
      can_backup_vm="y"
      log_message "information: $vm is $vm_state. vm desired state is $vm_desired_state. can_backup_vm set to $can_backup_vm."

    # check to see if vm is shut off.
    elif [ "$vm_state" == "shut off" ] && [ ! "$vm_desired_state" == "shut off" ]; then

      # set a flag to check later to indicate whether to backup this vm or not.
      can_backup_vm="y"
      log_message "information: $vm is $vm_state. vm desired state is $vm_desired_state. can_backup_vm set to $can_backup_vm."

    # if the vm is running, try to get it to the desired state.
    elif [ "$vm_state" == "running" ] || { [ "$vm_state" == "paused" ] && [ ! "$vm_desired_state" == "paused" ]; }; then
      log_message "information: $vm is $vm_state. vm desired state is $vm_desired_state."

      if [ "$vm_desired_state" == "paused" ]; then
        # attempt to pause the vm.
        virsh suspend "$vm"
        log_message "information: $vm is $vm_state. vm desired state is $vm_desired_state. performing $clean_shutdown_checks $seconds_to_wait second cycles waiting for $vm to pause. "

      elif [ "$vm_desired_state" == "shut off" ]; then

        # resume the vm if it is suspended, based on testing this should be instant but will trap later if it has not resumed.
        if [ "$vm_state" == "paused" ]; then
          log_message "action: $vm is $vm_state. vm desired state is $vm_desired_state. resuming."

          # resume the vm.
          virsh resume "$vm"
        fi

        # attempt to cleanly shutdown the vm.
        virsh shutdown "$vm"
        log_message "information: performing $clean_shutdown_checks $seconds_to_wait second cycles waiting for $vm to shutdown cleanly."
      fi

      # the shutdown of the vm may last a while so we are going to check periodically based on global input variables.
      for (( i=1; i<=clean_shutdown_checks; i++ ))
      do
        log_message "information: cycle $i of $clean_shutdown_checks: waiting $seconds_to_wait seconds before checking if the vm has entered the desired state."

        # wait x seconds based on how many seconds the user wants to wait between checks for a clean shutdown.
        sleep $seconds_to_wait

        # get the state of the vm.
        vm_state=$(virsh domstate "$vm")

        # if the vm is running decide what to do.
        if [ ! "$vm_state" == "$vm_desired_state" ]; then
          log_message "information: $vm is $vm_state. vm desired state is $vm_desired_state."

          # if we have already exhausted our wait time set by the script variables then its time to do something else.
          if [ "$i" = "$clean_shutdown_checks" ] ; then

            # check if the user wants to kill the vm on failure of unclean shutdown.
            if [ "$kill_vm_if_cant_shutdown" -eq 1 ]; then
              log_message "information: kill_vm_if_cant_shutdown is $kill_vm_if_cant_shutdown. killing vm."

              # destroy vm, based on testing this should be instant and without failure.
              virsh destroy "$vm"

              # get the state of the vm.
              vm_state=$(virsh domstate "$vm")

              # if the vm is shut off then proceed or give up.
              if [ "$vm_state" == "shut off" ]; then

                # set a flag to check later to indicate whether to backup this vm or not.
                can_backup_vm="y"
                log_message "information: $vm is $vm_state. vm desired state is $vm_desired_state. can_backup_vm set to $can_backup_vm."
                break

              else

                # set a flag to check later to indicate whether to backup this vm or not.
                can_backup_vm="n"
                log_message "failure: $vm is $vm_state. vm desired state is $vm_desired_state. can_backup_vm set to $can_backup_vm." "$vm backup failed" "alert"
              fi

            # if the user doesn't want to force a shutdown then there is nothing more to do so i cannot backup the vm.
            else

              # set a flag to check later to indicate whether to backup this vm or not.
              can_backup_vm="n"
              log_message "failure: $vm is $vm_state. vm desired state is $vm_desired_state. can_backup_vm set to $can_backup_vm." "$vm backup failed" "alert"
            fi
          fi

        # if the vm is shut off then go onto backing it up.
        elif [ "$vm_state" == "$vm_desired_state" ]; then

          # set a flag to check later to indicate whether to backup this vm or not.
          can_backup_vm="y"
          log_message "information: $vm is $vm_state. vm desired state is $vm_desired_state. can_backup_vm set to $can_backup_vm."
          break

        # if the vm is in a state that is not explicitly defined then do nothing as it is unknown how to handle it.
        else

          # set a flag to check later to indicate whether to backup this vm or not.
          can_backup_vm="n"
          log_message "failure: $vm is $vm_state. vm desired state is $vm_desired_state. can_backup_vm set to $can_backup_vm." "$vm backup failed" "alert"
        fi
      done

    # if the vm is suspended then something went wrong with the attempt to recover it earlier so do not attempt to backup.
    elif [ "$vm_state" == "suspended" ]; then

      # set a flag to check later to indicate whether to backup this vm or not.
      can_backup_vm="n"
      log_message "failure: $vm is $vm_state. vm desired state is $vm_desired_state. can_backup_vm set to $can_backup_vm." "$vm backup failed" "alert"

    # if the vm is in a state that has not been explicitly defined then do nothing as it is unknown how to handle it.
    else

      # set a flag to check later to indicate whether to backup this vm or not.
      can_backup_vm="n"
      log_message "failure: $vm is $vm_state. vm desired state is $vm_desired_state. can_backup_vm set to $can_backup_vm." "$vm backup failed" "alert"
    fi
  }

#### define functions end ####


#### validate user variables start ####

  # check the name of the script is as it should be. if yes, continue. if no, exit.
  if [ "$me" == "$official_script_name" ]; then

    notification_message "information: official_script_name is $official_script_name. script file's name is $me. script name is valid. continuing."

  elif [ ! "$me" == "$official_script_name" ]; then

    notification_message "failure: official_script_name is $official_script_name. script file's name is $me. script name is invalid. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if the script has been enabled or disabled by the user. if yes, continue if no, exit. if input invalid, exit.
  if [[ "$enabled" =~ ^(0|1)$ ]]; then

    if [ "$enabled" -eq 1 ]; then

      notification_message "information: enabled is $enabled. script is enabled. continuing."

    elif [ ! "$enabled" -eq 1 ]; then

      notification_message "failure: enabled is $enabled. script is disabled. exiting." "script failed" "alert"

      exit 1

    fi
  else

    notification_message "failure: enabled is $enabled. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi

  # remove the trailing slash from backup_location if it exists.
  backup_location=${backup_location%/}

  # check to see if the backup_location specified by the user exists. if yes, continue if no, exit. if exists check if writable, if yes continue, if not exit. if input invalid, exit.
  if [[ -d "$backup_location" ]]; then

    notification_message "information: backup_location is $backup_location. this location exists. continuing."

    # if backup_location does exist check to see if the backup_location is writable.
    if [[ -w "$backup_location" ]]; then

      notification_message "information: backup_location is $backup_location. this location is writable. continuing."

    else

      notification_message "failure: backup_location is $backup_location. this location is not writable. exiting." "script failed" "alert"

      exit 1

    fi

  else

    notification_message "failure: backup_location is $backup_location. this location does not exist. exiting." "script failed" "alert"

    exit 1

  fi


  # create timestamp variable for rolling backups.
  timestamp="$(date '+%Y%m%d_%H%M')""_"

  # check to see if backups should have timestamp. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$timestamp_files" =~ ^(0|1)$ ]]; then

    if [ "$timestamp_files" -eq 0 ]; then

      notification_message "information: timestamp_files is $timestamp_files. this variable is only used when number_of_backups_to_keep is set to 1. timestamp will not be added to backup files."

    elif  [ "$timestamp_files" -eq 1 ]; then

      notification_message "information: timestamp_files is $timestamp_files. timestamp will be added to backup files."

    fi

  else

    notification_message "failure: timestamp_files is $timestamp_files. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check log folder for trailing slash. add if missing.
  length=${#log_file_subfolder}
  last_char=${log_file_subfolder:$length-1:1}
  [[ ! $last_char == "/" ]] && log_file_subfolder="$log_file_subfolder/"; :


  # create the log file subfolder for storing log files.
  if [ ! -d "$backup_location/$log_file_subfolder" ] ; then

    notification_message "information: $backup_location/$log_file_subfolder does not exist. creating it."

    # make the directory as it doesn't exist. added -v option to give a confirmation message to command line.
    mkdir -vp "$backup_location/$log_file_subfolder"

  else

    notification_message "information: $backup_location/$log_file_subfolder exists. continuing."

  fi


  # check to see if the log_file_subfolder specified by the user exists. if yes, continue if no, exit. if exists check if writable, if yes continue, if not exit. if input invalid, exit.
  if [[ -d "$backup_location/$log_file_subfolder" ]]; then

    notification_message "information: log_file_subfolder is $backup_location/$log_file_subfolder. this location exists. continuing."

    # if log_file_subfolder does exist check to see if the log_file_subfolder is writable.
    if [[ -w "$backup_location/$log_file_subfolder" ]]; then

      notification_message "information: log_file_subfolder is $backup_location/$log_file_subfolder. this location is writable. continuing."

    else

      notification_message "failure: log_file_subfolder is $backup_location/$log_file_subfolder. this location is not writable. exiting." "script failed" "alert"

      exit 1

    fi

  else

    notification_message "failure: log_file_subfolder is $backup_location/$log_file_subfolder. this location does not exist. exiting." "script failed" "alert"

    exit 1

  fi


  # initialize error variable. assume no errors.
  errors="0"


  ### Logging Started ###
  log_message "Start logging to log file."


  #### logging and notifications ####

  # check to see if notifications should be sent. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$send_notifications" =~ ^(0|1)$ ]]; then

    if [ "$send_notifications" -eq 0 ]; then

      log_message "information: send_notifications is $send_notifications. notifications will not be sent."

    elif  [ "$send_notifications" -eq 1 ]; then

      log_message "information: send_notifications is $send_notifications. notifications will be sent."

    fi

  else

    log_message "failure: send_notifications is $send_notifications. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi

  # check to see if only error notifications should be sent. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$only_send_error_notifications" =~ ^(0|1)$ ]]; then

    if [ "$only_send_error_notifications" -eq 0 ]; then

      log_message "information: only_send_error_notifications is $only_send_error_notifications. normal notifications will be sent if send_notifications is enabled."

    elif  [ "$only_send_error_notifications" -eq 1 ]; then

      log_message "information: only_send_error_notifications is $only_send_error_notifications. only error notifications will be sent if send_notifications is enabled."

    fi

  else

    log_message "failure: only_send_error_notifications is $only_send_error_notifications. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi

  # notify user that script has started.
  if [ "$send_notifications" -eq 1 ] && [ "$only_send_error_notifications" -eq 0 ]; then

    notification_message "information: unRAID VM Backup script is starting. Look for finished message." "script starting" "normal"

  fi


  # check to see if log files should be kept. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$keep_log_file" =~ ^(0|1)$ ]]; then

    if [ "$keep_log_file" -eq 0 ]; then

      log_message "information: keep_log_file is $keep_log_file. log files will not be kept."

    elif  [ "$keep_log_file" -eq 1 ]; then

      log_message "information: keep_log_file is $keep_log_file. log files will be kept."

    fi

  else

    log_message "failure: keep_log_file is $keep_log_file. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see how many log files should be kept. if yes, continue if no, continue if input invalid, exit.
  if [[ "$number_of_log_files_to_keep" =~ ^[0-9]+$ ]]; then

    if [ "$number_of_log_files_to_keep" -eq 0 ]; then

      log_message "information: number_of_log_files_to_keep is $number_of_log_files_to_keep. an infinite number of log files will be kept. be sure to pay attention to how many log files there are."

    elif [ "$number_of_log_files_to_keep" -gt 40 ]; then

      log_message "information: number_of_log_files_to_keep is $number_of_log_files_to_keep. this is a lot of log files to keep."

    elif [ "$number_of_log_files_to_keep" -ge 1 ] && [ "$number_of_log_files_to_keep" -le 40 ]; then

      log_message "information: number_of_log_files_to_keep is $number_of_log_files_to_keep. this is probably a sufficient number of log files to keep."

    fi

  else

    log_message "failure: number_of_log_files_to_keep is $number_of_log_files_to_keep. this is not a valid format. expecting a number between [0 - 1000000]. exiting." "script failed" "alert"

    exit 1

  fi

  # check to see if vm specific log files are enabled. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$enable_vm_log_file" =~ ^(0|1)$ ]]; then

    if [ "$enable_vm_log_file" -eq 0 ]; then

      log_message "information: enable_vm_log_file is $enable_vm_log_file. vm specific logs will not be created."

    elif  [ "$enable_vm_log_file" -eq 1 ]; then

      log_message "information: enable_vm_log_file is $enable_vm_log_file. vm specific logs will be created."

    fi

  else

    log_message "failure: enable_vm_log_file is $enable_vm_log_file. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi

  # check to see if all vms should be backed up. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$backup_all_vms" =~ ^(0|1)$ ]]; then

    if [ "$backup_all_vms" -eq 0 ]; then

      log_message "information: backup_all_vms is $backup_all_vms. only vms listed in vms_to_backup will be backed up."

    elif [ "$backup_all_vms" -eq 1 ]; then

      log_message "information: backup_all_vms is $backup_all_vms. vms_to_backup will be ignored. all vms will be backed up."

    fi

  else

    log_message "failure: backup_all_vms is $backup_all_vms. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi

  # check to see if snapshots should be used. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$use_snapshots" =~ ^(0|1)$ ]]; then

    if [ "$use_snapshots" -eq 0 ]; then

      log_message "information: use_snapshots is $use_snapshots. vms will not be backed up using snapshots."

    elif [ "$use_snapshots" -eq 1 ]; then

      log_message "information: use_snapshots is $use_snapshots. vms will be backed up using snapshots if possible."

    fi

  else

    log_message "failure: use_snapshots is $use_snapshots. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi

  # check to see if vm should be killed if clean shutdown fails. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$kill_vm_if_cant_shutdown" =~ ^(0|1)$ ]]; then

    if [ "$kill_vm_if_cant_shutdown" -eq 0 ]; then

      log_message "information: kill_vm_if_cant_shutdown is $kill_vm_if_cant_shutdown. vms will not be forced to shutdown if a clean shutdown can not be detected."

    elif [ "$kill_vm_if_cant_shutdown" -eq 1 ]; then

      log_message "information: kill_vm_if_cant_shutdown is $kill_vm_if_cant_shutdown. vms will be forced to shutdown if a clean shutdown can not be detected."

    fi

  else

    log_message "failure: kill_vm_if_cant_shutdown is $kill_vm_if_cant_shutdown. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if vm should be set to original state after backup. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$set_vm_to_original_state" =~ ^(0|1)$ ]]; then

    if [ "$set_vm_to_original_state" -eq 0 ]; then

      log_message "information: set_vm_to_original_state is $set_vm_to_original_state. vms will not be set to their original state after backup."

    elif [ "$set_vm_to_original_state" -eq 1 ]; then

      log_message "information: set_vm_to_original_state is $set_vm_to_original_state. vms will be set to their original state after backup."

    fi

  else

    log_message "failure: set_vm_to_original_state is $set_vm_to_original_state. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to how many days backups should be kept. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$number_of_days_to_keep_backups" =~ ^[0-9]+$ ]]; then

    if [ "$number_of_days_to_keep_backups" -lt 7 ]; then

      if [ "$number_of_days_to_keep_backups" -eq 0 ]; then

        log_message "information: number_of_days_to_keep_backups is $number_of_days_to_keep_backups. backups will be kept indefinitely. be sure to set number_of_backups_to_keep to keep backups storage usage down."

      else

        log_message "warning: number_of_days_to_keep_backups is $number_of_days_to_keep_backups. this is potentially an insufficient number of days to keep your backups."

      fi

    elif [ "$number_of_days_to_keep_backups" -gt 180 ]; then

      log_message "warning: number_of_days_to_keep_backups is $number_of_days_to_keep_backups. this is a long time to keep your backups."

    elif [ "$number_of_days_to_keep_backups" -ge 7 ] && [ "$number_of_days_to_keep_backups" -le 180 ]; then

      log_message "information: number_of_days_to_keep_backups is $number_of_days_to_keep_backups. this is probably a sufficient number of days to keep your backups."

    fi

  else

    log_message "failure: number_of_days_to_keep_backups is $number_of_days_to_keep_backups. this is not a valid format. expecting a number between [0 - 1000000]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to how many backups should be kept. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$number_of_backups_to_keep" =~ ^[0-9]+$ ]]; then

    if [ "$number_of_backups_to_keep" -lt 2 ]; then

      if [ "$number_of_backups_to_keep" -eq 0 ]; then

        log_message "information: number_of_backups_to_keep is $number_of_backups_to_keep. an infinite number of backups will be kept. be sure to set number_of_days_to_keep_backups to keep backups storage usage down."

      else

        log_message "warning: number_of_backups_to_keep is $number_of_backups_to_keep. this is potentially an insufficient number of backups to keep."

      fi

    elif [ "$number_of_backups_to_keep" -gt 40 ]; then

      log_message "warning: number_of_backups_to_keep is $number_of_backups_to_keep. this is a lot of backups to keep."

    elif [ "$number_of_backups_to_keep" -ge 2 ] && [ "$number_of_backups_to_keep" -le 40 ]; then

      log_message "information: number_of_backups_to_keep is $number_of_backups_to_keep. this is probably a sufficient number of backups to keep."

    fi

  else

    log_message "failure: number_of_backups_to_keep is $number_of_backups_to_keep. this is not a valid format. expecting a number between [0 - 1000000]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if vdisks should be inline compressed.
  if [[ ! "$inline_zstd_compress" =~ ^(0|1)$ ]]; then

    log_message "failure: inline_zstd_compress is $inline_zstd_compress. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  elif [ "$inline_zstd_compress" -eq 0 ]; then

    log_message "information: inline_zstd_compress is $inline_zstd_compress. vdisk images will not be inline compressed."

  elif [ "$inline_zstd_compress" -eq 1 ]; then

    log_message "information: inline_zstd_compress is $inline_zstd_compress. vdisk images will be inline compressed but will not be compared afterwards or post compressed."

  fi

  # if inline_zstd_compress is enabled, check to see if zstd_level and zstd_threads are valid and in range.
  if [ "$inline_zstd_compress" -eq 1 ]; then

    # check to see if zstd_level is valid and in range.
    if [[ ! "$zstd_level" =~ ^[0-9]+$ ]]; then

      log_message "failure: zstd_level is $zstd_level. this is not a valid format. expecting a number between [1 - 19]. exiting." "script failed" "alert"

      exit 1

    elif [ "$zstd_level" -lt 1 ] || [ "$zstd_level" -gt 19 ] ; then

      log_message "failure: zstd_level is $zstd_level. expecting a number between [1 - 19]. exiting." "script failed" "alert"

      exit 1

    elif [ "$zstd_level" -gt 8 ] ; then

      log_message "warning: zstd_level is $zstd_level. this will be slower and may not produce meaningfully smaller backup images."

    else

      log_message "information: zstd_level is $zstd_level."

    fi

    # check to see if zstd_threads is valid and in range.
    if [[ ! "$zstd_threads" =~ ^[0-9]+$ ]]; then

      log_message "failure: zstd_threads is $zstd_threads. this is not a valid format. expecting a number between [0 - 200]. exiting." "script failed" "alert"

      exit 1

    elif [ "$zstd_threads" -lt 0 ] || [ "$zstd_threads" -gt 200 ] ; then

      log_message "failure: zstd_threads is $zstd_threads. expecting a number between [0 - 200]. exiting." "script failed" "alert"

      exit 1

    elif [ "$zstd_threads" -gt 4 ] ; then

      log_message "warning: zstd_threads is $zstd_threads. this is a lot of threads to use for compression."

    elif [ "$zstd_threads" -eq 0 ] ; then

      log_message "information: zstd_threads is $zstd_threads. the actual number of threads will be auto determined."

    else

      log_message "information: zstd_threads is $zstd_threads."

    fi

  fi

  # if inline_zstd_compress is disabled, check to see if backups should be post compressed.
  if [ "$inline_zstd_compress" -ne 1 ]; then

    if [[ ! "$gzip_compress" =~ ^(0|1)$ ]]; then

      log_message "failure: gzip_compress is $gzip_compress. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

      exit 1

    elif [ "$gzip_compress" -eq 0 ]; then

      log_message "information: gzip_compress is $gzip_compress. backups will not be post compressed."

    elif [ "$gzip_compress" -eq 1 ]; then

      log_message "information: gzip_compress is $gzip_compress. backups will be post compressed."

    fi

  fi


    # check to see if extra files and folders should be included in the backup. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$include_extra_files" =~ ^(0|1)$ ]]; then

    if [ "$include_extra_files" -eq 0 ]; then

      log_message "information: include_extra_files is $include_extra_files. extra files and folders will not be included in the backup."

    elif [ "$include_extra_files" -eq 1 ]; then

      log_message "information: include_extra_files is $include_extra_files. extra files and folders will be included in the backup. gzip legacy compression will be disabled."

      gzip_compress="0"

    fi

  else

    log_message "failure: include_extra_files is $include_extra_files. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi



  #### advanced variables ####

  # if snapshots are enabled, then check for a valid extension and add it to the extensions to skip.
  if [ "$use_snapshots" -eq 1 ]; then

    # check to see if snapshot extension is empty. if yes, continue. if no exit.
    if [[ -n "$snapshot_extension" ]]; then

      # remove any leading decimals from the extension.
      snapshot_extension="${snapshot_extension##.}"

      log_message "information: snapshot_extension is $snapshot_extension. continuing."

    else

      log_message "failure: snapshot_extension is not set. exiting." "script failed" "alert"

      exit 1

    fi

    # add snapshot extension to extensions_to_skip if it is not already present.
    # initialize vairable snap_exists as false
    snap_exists=false

    # for each extension check to see if it is already in the array.
    for extension in $vdisk_extensions_to_skip

    do

      # if the extension already exists in the array set snap_exists to true and break out of the current loop.
      if [ "$extension" == "$snapshot_extension" ]; then

        snap_exists=true

        break

      fi

    done

    # if snapshot extension was not found in the array, add it. else move on.
    if [ "$snap_exists" = false ]; then

      vdisk_extensions_to_skip="$vdisk_extensions_to_skip"$'\n'"$snapshot_extension"

      log_message "information: snaphot extension not found in vdisk_extensions_to_skip. extension was added."

    else

      log_message "information: snapshot extension was not found in vdisk_extensions_to_skip. moving on."

    fi

  else

    log_message "information: use_snapshots disabled, not adding snapshot_extension to vdisk_extensions_to_skip."

  fi

  # check to see if snapshots should fallback to standard backups. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$snapshot_fallback" =~ ^(0|1)$ ]]; then

    if [ "$snapshot_fallback" -eq 0 ]; then

      log_message "information: snapshot_fallback is $snapshot_fallback. snapshots will fallback to standard backups."

    elif [ "$snapshot_fallback" -eq 1 ]; then

      log_message "information: snapshot_fallback is $snapshot_fallback. snapshots will not fallback to standard backups."

    fi

  else

    log_message "failure: snapshot_fallback is $snapshot_fallback. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi

  # check to see if vms should be paused instead of shutdown. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$pause_vms" =~ ^(0|1)$ ]]; then

    if [ "$pause_vms" -eq 0 ]; then

      log_message "information: pause_vms is $pause_vms. vms will be shutdown for standard backups."

    elif [ "$pause_vms" -eq 1 ]; then

      log_message "information: pause_vms is $pause_vms. vms will be paused for standard backups."

    fi

  else

    log_message "failure: pause_vms is $pause_vms. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi

  # check to see if reconstruct write should be enabled during backup. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$enable_reconstruct_write" =~ ^(0|1)$ ]]; then

    if [ "$enable_reconstruct_write" -eq 0 ]; then

      log_message "information: enable_reconstruct_write is $enable_reconstruct_write. reconstruct write will not be enabled by this script."

    elif [ "$enable_reconstruct_write" -eq 1 ]; then

      log_message "information: enable_reconstruct_write is $enable_reconstruct_write. reconstruct write will be enabled during the backup."

    fi

  else

    log_message "failure: enable_reconstruct_write is $enable_reconstruct_write. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi

  # if inline_zstd_compress is disabled, check to see if files should be compared after backup.
  if [ "$inline_zstd_compress" -ne 1 ]; then

    if [[ ! "$compare_files" =~ ^(0|1)$ ]]; then

      log_message "failure: compare_files is $compare_files. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

      exit 1

    elif [ "$compare_files" -eq 0 ]; then

      log_message "information: compare_files is $compare_files. files will not be compared after backups."

    elif [ "$compare_files" -eq 1 ]; then

      log_message "information: compare_files is $compare_files. files will be compared after backups."

    fi

  fi

  # check to see if config should be backed up. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$backup_xml" =~ ^(0|1)$ ]]; then

    if [ "$backup_xml" -eq 0 ]; then

      log_message "warning: backup_xml is $backup_xml. vms will not have their xml configurations backed up."

    elif [ "$backup_xml" -eq 1 ]; then

      log_message "information: backup_xml is $backup_xml. vms will have their xml configurations backed up."

    fi

  else

    log_message "failure: backup_xml is $backup_xml. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if nvram should be backed up. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$backup_nvram" =~ ^(0|1)$ ]]; then

    if [ "$backup_nvram" -eq 0 ]; then

      log_message "warning: backup_nvram is $backup_nvram. vms will not have their nvram backed up."

    elif [ "$backup_nvram" -eq 1 ]; then

      log_message "information: backup_nvram is $backup_nvram. vms will have their nvram backed up."

    fi

  else

    log_message "failure: backup_nvram is $backup_nvram. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if vdisks should be backed up. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$backup_vdisks" =~ ^(0|1)$ ]]; then

    if [ "$backup_vdisks" -eq 0 ]; then

      log_message "warning: backup_vdisks is $backup_vdisks. vms will not have their vdisks backed up. compression will be set to off."

      gzip_compress="0"

    elif [ "$backup_vdisks" -eq 1 ]; then

      log_message "information: backup_vdisks is $backup_vdisks. vms will have their vdisks backed up."

    fi

  else

    log_message "failure: backup_vdisks is $backup_vdisks. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if vms should be started after a successful backup. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$start_vm_after_backup" =~ ^(0|1)$ ]]; then

    if [ "$start_vm_after_backup" -eq 0 ]; then

      log_message "information: start_vm_after_backup is $start_vm_after_backup. vms will not be started following successful backup."

    elif [ "$start_vm_after_backup" -eq 1 ]; then

      log_message "information: start_vm_after_backup is $start_vm_after_backup vms will be started following a successful backup."

    fi

  else

    log_message "failure: start_vm_after_backup is $start_vm_after_backup. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if vms should be started after an unsuccessful backup. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$start_vm_after_failure" =~ ^(0|1)$ ]]; then

    if [ "$start_vm_after_failure" -eq 0 ]; then

      log_message "information: start_vm_after_failure is $start_vm_after_failure. vms will not be started following an unsuccessful backup."

    elif [ "$start_vm_after_failure" -eq 1 ]; then

      log_message "information: start_vm_after_failure is $start_vm_after_failure. vms will be started following an unsuccessful backup."

    fi

  else

    log_message "failure: start_vm_after_failure is $start_vm_after_failure. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if delta sync should be disabled. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$disable_delta_sync" =~ ^(0|1)$ ]]; then

    if [ "$disable_delta_sync" -eq 0 ]; then

      log_message "information: disable_delta_sync is $disable_delta_sync. rsync will be used to perform delta sync backups."

    elif [ "$disable_delta_sync" -eq 1 ]; then

      log_message "information: disable_delta_sync is $disable_delta_sync. no delta syncs will be done."

    fi

  else

    log_message "failure: disable_delta_sync is $disable_delta_sync. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if only rsync should be used. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$rsync_only" =~ ^(0|1)$ ]]; then

    if [ "$rsync_only" -eq 0 ]; then

      log_message "information: rsync_only is $rsync_only. cp will be used when applicable."

    elif [ "$rsync_only" -eq 1 ]; then

      log_message "information: rsync_only is $rsync_only. only rsync will be used."

    fi

  else

    log_message "failure: rsync_only is $rsync_only. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # validate the actually_copy_files option. if yes set the rsync command line option for dry-run. if input invalid, exit.
  if [[ "$actually_copy_files" =~ ^(0|1)$ ]]; then

    if [ "$actually_copy_files" -eq 0 ]; then

      log_message "warning: actually_copy_files flag is $actually_copy_files. no files will be copied. setting rsync_only to 1."

      # create a variable which tells rsync to do a dry-run.
      rsync_dry_run_option="n"

      # set rsync_only variable to 1 so that dry run will work.
      rsync_only="1"

    elif [ "$actually_copy_files" -eq 1 ]; then

      log_message "information: actually_copy_files is $actually_copy_files. files will be copied."

    fi

  else

    log_message "failure: actually_copy_files is $actually_copy_files. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see how many times vm's state should be checked for shutdown. if yes, continue if no, continue if input invalid, exit.
  if [[ "$clean_shutdown_checks" =~ ^[0-9]+$ ]]; then

    if [ "$clean_shutdown_checks" -lt 5 ]; then

      log_message "warning: clean_shutdown_checks is $clean_shutdown_checks. this is potentially an insufficient number of shutdown checks."

    elif [ "$clean_shutdown_checks" -gt 50 ]; then

      log_message "warning: clean_shutdown_checks is $clean_shutdown_checks. this is a vast number of shutdown checks."

    elif [ "$clean_shutdown_checks" -ge 5 ] && [ "$clean_shutdown_checks" -le 50 ]; then

      log_message "information: clean_shutdown_checks is $clean_shutdown_checks. this is probably a sufficient number of shutdown checks."

    fi

  else

    log_message "failure: clean_shutdown_checks is $clean_shutdown_checks. this is not a valid format. expecting a number between [0 - 1000000]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see how many seconds to wait between vm shutdown checks. messages to user only. if input invalid, exit.
  if [[ "$seconds_to_wait" =~ ^[0-9]+$ ]]; then

    if [ "$seconds_to_wait" -lt 30 ]; then

      log_message "warning: seconds_to_wait is $seconds_to_wait. this is potentially an insufficient number of seconds to wait between shutdown checks."

    elif [ "$seconds_to_wait" -gt 600 ]; then

      log_message "warning: seconds_to_wait is $seconds_to_wait. this is a vast number of seconds to wait between shutdown checks."

    elif [ "$seconds_to_wait" -ge 30 ] && [ "$seconds_to_wait" -le 600 ]; then

      log_message "information: seconds_to_wait is $seconds_to_wait. this is probably a sufficient number of seconds to wait between shutdown checks."

    fi

  else

    log_message "failure: seconds_to_wait is $seconds_to_wait. this is not a valid format. expecting a number between [0 - 1000000]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see if error log files should be kept. if yes, continue. if no, continue. if input invalid, exit.
  if [[ "$keep_error_log_file" =~ ^(0|1)$ ]]; then

    if [ "$keep_error_log_file" -eq 0 ]; then

      log_message "information: keep_error_log_file is $keep_error_log_file. error log files will not be kept."

    elif  [ "$keep_error_log_file" -eq 1 ]; then

      log_message "information: keep_error_log_file is $keep_error_log_file. error log files will be kept."

    fi

  else

    log_message "failure: keep_error_log_file is $keep_error_log_file. this is not a valid format. expecting [0 = no] or [1 = yes]. exiting." "script failed" "alert"

    exit 1

  fi


  # check to see how many error log files should be kept. if yes, continue if no, continue if input invalid, exit.
  if [[ "$number_of_error_log_files_to_keep" =~ ^[0-9]+$ ]]; then

    if [ "$number_of_error_log_files_to_keep" -lt 2 ]; then

      if [ "$number_of_error_log_files_to_keep" -eq 0 ]; then

        log_message "information: number_of_error_log_files_to_keep is $number_of_error_log_files_to_keep. an infinite number of error log files will be kept. be sure to pay attention to how many error log files there are."

      else

        log_message "warning: number_of_error_log_files_to_keep is $number_of_error_log_files_to_keep. this is potentially an insufficient number of error log files to keep."

      fi

    elif [ "$number_of_error_log_files_to_keep" -gt 40 ]; then

      log_message "information: number_of_error_log_files_to_keep is $number_of_error_log_files_to_keep. this is a error lot of log files to keep."

    elif [ "$number_of_error_log_files_to_keep" -ge 2 ] && [ "$number_of_error_log_files_to_keep" -le 40 ]; then

      log_message "information: number_of_error_log_files_to_keep is $number_of_error_log_files_to_keep. this is probably a sufficient error number of log files to keep."

    fi

  else

    log_message "failure: number_of_error_log_files_to_keep is $number_of_error_log_files_to_keep. this is not a valid format. expecting a number between [0 - 1000000]. exiting." "script failed" "alert"

    exit 1

  fi

#### validate user variables end ####


#### code execution start ####

  # set this to force the for loop to split on new lines and not spaces.
  IFS=$'\n'

  # check to see if backup_all_vms is enabled.
  if [ "$backup_all_vms" -eq 1 ]; then
    # since we are using backup_all_vms, ignore any vms listed in vms_to_backup.
    vms_to_ignore="$vms_to_backup"

    # unset vms_to_backup
    unset -v vms_to_backup

    # get a list of the vm names installed on the system.
    vm_exists=$(virsh list --all --name)

    # check each vm on the system against the list of vms to ignore.
    for vmname in $vm_exists

    do

      # assume the vm will not be ignored until it is found in the list of vms to ignore.
      ignore_vm=false

      for vm in $vms_to_ignore

      do

        if [ "$vmname" == "$vm" ]; then

          # mark the vm as needing to be ignored.
          ignore_vm=true

          # skips current loop.
          continue

        fi

      done

      # if vm should not be ignored, add it to the list of vms to backup.
      if [[ "$ignore_vm" = false ]]; then

        if [[ -z "$vms_to_backup" ]]; then

          vms_to_backup="$vmname"

        else

          vms_to_backup="$vms_to_backup"$'\n'"$vmname"

        fi

      fi

    done

  fi

  # create comma separated list of vms to backup for log file.
  for vm_to_backup in $vms_to_backup

  do

    if [[ -z "$vms_to_backup_list" ]]; then

      vms_to_backup_list="$vm_to_backup"

    else

      vms_to_backup_list="$vms_to_backup_list, $vm_to_backup"

    fi

  done

  log_message "information: started attempt to backup $vms_to_backup_list to $backup_location"

  # check to see if reconstruct write should be enabled by this script. if so, enable and continue.
  if [ "$enable_reconstruct_write" -eq 1 ]; then

    /usr/local/sbin/mdcmd set md_write_method 1
    log_message "information: Reconstruct write enabled."

  fi

  # loop through the vms in the list and try and back up their associated configs and vdisk(s).
  for vm in $vms_to_backup

  do

    # get a list of the vm names installed on the system.
    vm_exists=$(virsh list --all --name)

    # assume the vm is not going to be backed up until it is found on the system
    skip_vm="y"

    # check to see if the vm exists on the system to backup.
    for vmname in $vm_exists

    do

      # if the vm doesn't match then set the skip flag to y.
      if [ "$vm" == "$vmname" ] ; then

        # set a flag i am going to check later to indicate if i should skip this vm or not.
        skip_vm="n"

        # skips current loop.
        continue

      fi

    done


    # if the skip flag was set in the previous section then we have to exit and move on to the next vm in the list.
    if [ "$skip_vm" == "y" ]; then

      log_message "warning: $vm can not be found on the system. skipping vm." "script skipping $vm" "warning"

      skip_vm="n"

      # skips current loop.
      continue

    else

      log_message "information: $vm can be found on the system. attempting backup."

    fi

    # see if a config file exists for the vm already and remove it.
    if [[ -f "$vm.xml" ]]; then
      log_message "information: removing old local $vm.xml."
      rm -fv "$vm.xml"
    fi

    # dump the vm config locally.
    log_message "information: creating local $vm.xml to work with during backup."
    virsh dumpxml "$vm" > "$vm.xml"

    # replace xmlns value with absolute URI to avoid namespace warning.
    # sed isn't an ideal way to edit xml files, but few options are available on unraid.
    # this only edits a temporary file that is removed at the end of the script.
    sed -i 's|vmtemplate xmlns="unraid"|vmtemplate xmlns="http://unraid.net/xmlns"|g' "$vm.xml"

    # create a directory named after the vm within backup_location to store the backup files.
    if [ ! -d "$backup_location/$vm" ] ; then

      log_message "information: $backup_location/$vm does not exist. creating it."

      # make the directory as it doesn't exist. added -v option to give a confirmation message to command line.
      mkdir -vp "$backup_location/$vm"

    else

      log_message "information: $backup_location/$vm exists. continuing."

    fi

    if [ "$enable_vm_log_file" -eq 1 ]; then
      vm_log_file="$backup_location/$vm/$timestamp""unraid-vmbackup.log"
    fi

    # see if vdisks should be backed up, if the number of backups is more than 1, if snapshots are being used, and if delta sync is enabled.
    if [ "$backup_vdisks" -eq 1 ] && [ "$number_of_backups_to_keep" -ne 1 ] && [ "$use_snapshots" -ne 1 ] && [ "$disable_delta_sync" -ne 1 ]; then

      # copy vdisks
      copy_vdisks "existing_backup"

    fi


    # get the state of the vm for making sure it is off before backing up.
    vm_state=$(virsh domstate "$vm")

    # get the state of the vm for putting the VM in it's original state after backing up.
    vm_original_state=$vm_state

    # initialize skip_vm_shutdown variable as false.
    skip_vm_shutdown=false

    # determine if vm should be kept running.
    # first check to see if vm exists in vms_to_backup_running variable.
    for vm_to_keep_running in $vms_to_backup_running
    do

      if [[ "$vm_to_keep_running" == "$vm" ]]; then
        skip_vm_shutdown=true
      fi

    done

    # if vm is not found in vms_to_backup_running and use_snapshots is disabled, then skip shutdown proceedure.
    if [ "$skip_vm_shutdown" = false ] && [ "$use_snapshots" -eq 0 ]; then

      log_message "information: skip_vm_shutdown is false. beginning vm shutdown procedure."

      # prepare vm for backup.
      prepare_vm "$vm" "$vm_state"

    elif [ "$skip_vm_shutdown" = true ] || [ "$use_snapshots" -eq 1 ]; then

      can_backup_vm="y"
      log_message "information: skip_vm_shutdown is $skip_vm_shutdown and use_snapshots is $use_snapshots. skipping vm shutdown procedure. $vm is $vm_state. can_backup_vm set to $can_backup_vm."

    else

      log_message "failure: skip_vm_shutdown is $skip_vm_shutdown and use_snapshots is $use_snapshots. skipping vm shutdown procedure. $vm is $vm_state. can_backup_vm set to $can_backup_vm." "$vm backup failed" "alert"

    fi


    # log if this is a dry run or not.
    log_message "information: actually_copy_files is $actually_copy_files."

    # check whether to backup the vm or not.
    if [[ "$can_backup_vm" == "y" ]]; then

      # start backing up vm configuration, nvram, and snapshots.
      log_message "information: can_backup_vm flag is $can_backup_vm. starting backup of $vm configuration, nvram, and vdisk(s)." "script starting $vm backup" "normal"

      # see if config should be backed up.
      if [ "$backup_xml" -eq 1 ]; then

        # check if only one non-timestamped backup is being kept. if so, perform rsync without a timestamp. if not, continue as normal.
        if [ "$timestamp_files" -eq 0 ]  && [ "$number_of_backups_to_keep" -eq 1 ]; then

          copy_file "$vm.xml" "$backup_location/$vm/$vm.xml" "$rsync_dry_run_option" "standard" "$rsync_only"

          # make sure copy has current date/time for modified attribute so that removing old backups by date will work.
          touch -d "now" "$backup_location/$vm/$vm.xml"

          # run compare function. compare will not run if compare_files is disabled.
          run_compare "$vm.xml" "$backup_location/$vm/$vm.xml" "config"

        else

          copy_file "$vm.xml" "$backup_location/$vm/$timestamp$vm.xml" "$rsync_dry_run_option" "standard" "$rsync_only"

          # make sure copy has current date/time for modified attribute so that removing old backups by date will work.
          touch -d "now" "$backup_location/$vm/$timestamp$vm.xml"

          # run compare function. compare will not run if compare_files is disabled.
          run_compare "$vm.xml" "$backup_location/$vm/$timestamp$vm.xml" "config"

        fi

      fi


      # see if nvram should be backed up.
      if [ "$backup_nvram" -eq 1 ]; then

        # extract nvram path from config file.
        nvram_path=$(xmllint --xpath "string(/domain/os/nvram)" "$vm.xml")

        # get nvram file name from path.
        nvram_filename=$(basename "$nvram_path")

        # get nvram file extension from filename.
        nvram_extension="${nvram_filename##*.}"

        # check to see if nvram_path is empty.
        if [[ -z "$nvram_path" ]]; then

          log_message "information: $vm does not appear to have an nvram file. skipping."

        else

          # check if only one non-timestamped backup is being kept. if so, perform rsync without a timestamp. if not, continue as normal.
          if [ "$timestamp_files" -eq 0 ]  && [ "$number_of_backups_to_keep" -eq 1 ]; then

            copy_file "$nvram_path" "$backup_location/$vm/$nvram_filename" "$rsync_dry_run_option" "standard" "$rsync_only"

            # make sure copy has current date/time for modified attribute so that removing old backups by date will work.
            touch -d "now" "$backup_location/$vm/$nvram_filename"

            # run compare function. compare will not run if compare_files is disabled.
            run_compare "$nvram_path" "$backup_location/$vm/$nvram_filename" "nvram"

          else

            copy_file "$nvram_path" "$backup_location/$vm/$timestamp$nvram_filename" "$rsync_dry_run_option" "standard" "$rsync_only"

            # make sure copy has current date/time for modified attribute so that removing old backups by date will work.
            touch -d "now" "$backup_location/$vm/$timestamp$nvram_filename"

            # run compare function. compare will not run if compare_files is disabled.
            run_compare "$nvram_path" "$backup_location/$vm/$timestamp$nvram_filename" "nvram"

          fi

        fi

      fi


      # see if vdisks should be backed up.
      if [ "$backup_vdisks" -eq 1 ]; then

        copy_vdisks "source_image"

        # check to see if the snapshot failed for the current vdisk and if snapshot fallback is disabled. if so, continue to the next vm to prevent data loss.
        if [ "$snapshot_succeeded" = false ] && [ "$snapshot_fallback" -eq 0 ]; then

          continue

        fi

      fi


      # list extensions of vdisks that were backed up.
      log_message "information: the extensions of the vdisks that were backed up are ${vdisk_extensions[*]}."

      # check to see if set_vm_to_original_state is 1 and then check the vm's original state.
      if [ "$set_vm_to_original_state" -eq 1 ]; then

        # get the current state of the vm for checking against its orginal state.
        vm_state=$(virsh domstate "$vm")

        # start the vm after backup based on previous state.
        if [ ! "$vm_state" == "$vm_original_state" ] && [ "$vm_original_state" == "running" ]; then

          log_message "information: vm_state is $vm_state. vm_original_state is $vm_original_state. starting $vm." "script starting $vm" "normal"

          if [ "$vm_state" == "paused" ]; then

            # resume vm
            virsh resume "$vm"

          elif [ "$vm_state" == "shut off" ]; then

            # start vm
            virsh start "$vm"

          else

            # there was an error
            log_message "warning: vm_state is $vm_state. vm_original_state is $vm_original_state. unable to start $vm." "script cannot start $vm" "warning"

          fi

        else

          log_message "information: vm_state is $vm_state. vm_original_state is $vm_original_state. not starting $vm." "script not starting $vm" "normal"

        fi

      fi


      # if start_vm_after_backup is set to 1 then start the vm but dont check that it has been successful.
      if [ "$start_vm_after_backup" -eq 1 ]; then

        log_message "information: vm_state is $vm_state. start_vm_after_backup is $start_vm_after_backup. starting $vm." "script starting $vm" "normal"

        if [ "$vm_state" == "paused" ]; then

            # resume vm
            virsh resume "$vm"

          elif [ "$vm_state" == "shut off" ]; then

            # start vm
            virsh start "$vm"

          else

            # there was an error
            log_message "warning: vm_state is $vm_state. vm_original_state is $vm_original_state. unable to start $vm." "script cannot start $vm" "warning"

          fi

      fi

      # check to see if backup files should be compressed.
      if [ "$gzip_compress" -eq 1 ] && [ "$inline_zstd_compress" -ne 1 ]; then

        # check if only one non-timestamped backup is being kept. if so, perform compression without a timestamp. if not, continue as normal.
        if [ "$timestamp_files" -eq 0 ]  && [ "$number_of_backups_to_keep" -eq 1 ]; then

          # build vdisk_extensions_find_cmd.
          build_vdisk_extensions_find_cmd "$backup_location/$vm/"

          # make sure new image files exist before removing existing tarball
          if [[ -n $("${vdisk_extensions_find_cmd[@]}") ]]; then

            new_image_files_exist=true

            log_message "information: found new image files."

          else

            new_image_files_exist=false

            log_message "warning: could not find new image files. backup may have failed." "no new image files for $vm" "warning"

          fi

          # make sure new config files exist before removing existing tarball
          if [[ "$backup_xml" -eq 1 ]] && [[ -n $(find "$backup_location/$vm" -type f \( -name '*.xml' \) ) ]]; then

            new_xml_files_exist=true

            log_message "information: found new xml files."

          elif [[ "$backup_xml" -eq 0 ]]; then

            new_xml_files_exist=true

            log_message "information: xml files not set to backup. skipping check."

          else

            new_xml_files_exist=false

            log_message "warning: could not find new xml files. backup may have failed." "no new xml files for $vm" "warning"

          fi

          # make sure new nvram files exist before removing existing tarball
          if [[ "$backup_nvram" -eq 1 ]] && [[ -n $(find "$backup_location/$vm" -type f \( -name '*.'"$nvram_extension" \) ) ]]; then

            new_nvram_files_exist=true

            log_message "information: found new nvram files."

          elif [[ "$backup_nvram" -eq 0 ]]; then

            new_nvram_files_exist=true

            log_message "information: nvram files not set to backup. skipping check."

          else

            new_nvram_files_exist=false

            log_message "warning: could not find new nvram files. backup may have failed." "no new nvram files for $vm" "warning"

          fi

          if [ "$new_image_files_exist" = true ] && [ "$new_xml_files_exist" = true ] && [ "$new_nvram_files_exist" = true ]; then

            log_message "information: found new backup files. removing existing tarball."

            # remove existing tarball
            rm -fv "$backup_location/$vm/"*.tar.gz | tee -a "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup.log"

            # create new compressed tarball with latest backup.
            log_message "information: started creating new tarball."

            # create list of files to be backed up.
            backup_file_list="$backup_location/$vm/backup_file_list.txt"

            # remove any existing list of files to be backup and create a blank backup file list.
            if [[ -f "$backup_file_list" ]]; then
                rm -fv "$backup_file_list"
            fi

            log_message "information: creating blank backup file list at $backup_file_list."
            touch "$backup_file_list"

            # for each extension, add it to the list of files to be backed up.
            for extension in "${vdisk_extensions[@]}"

            do

              find "$backup_location/$vm" -type f -name '*.'"$extension" -printf "%f\n" >> "$backup_file_list"

            done

            # see if config files should be backed up and then add any to to the list of files to be backed up.
            if [[ "$backup_xml" -eq 1 ]]; then

              find "$backup_location/$vm" -type f -name '*.xml' -printf "%f\n" >> "$backup_file_list"

            fi

            # see if nvram files should be backed up and then any to to the list of files to be backed up.
            if [[ "$backup_nvram" -eq 1 ]]; then

              find "$backup_location/$vm" -type f -name '*.'"$nvram_extension" -printf "%f\n" >> "$backup_file_list"

            fi

            # backup files based off of backup file list.
            # build tar command.
            tar_cmd=()
            tar_cmd=(tar cvSf)
            tar_cmd+=(-)
            tar_cmd+=(-C)
            tar_cmd+=("$backup_location/$vm/")
            tar_cmd+=(-T)
            tar_cmd+=("$backup_file_list")

            # build gzip command.
            gzip_cmd=()
            gzip_cmd=(gzip)
            gzip_cmd+=(-"$gzip_level")

            # execute commands together to compress files
            (cd "$backup_location/$vm/" && "${tar_cmd[@]}" | "${gzip_cmd[@]}" > "$backup_location/$vm/$vm.tar.gz")

            # remove backup file list.
            log_message "information: removing backup file list at $backup_file_list."
            rm -fv "$backup_file_list"

            log_message "information: finished creating new tarball."

            # remove config, nvram, and image files that were compressed.
            # build remove_old_files_cmd.
            build_remove_old_files_cmd "$backup_location/$vm/"

            # execute remove_old_files_cmd to delelte files that were compressed.
            "${remove_old_files_cmd[@]}"

            log_message "information: removed xml, nvram, and image files that were compressed."

          else

            log_message "warning: could not find new files to backup. backup may have failed. not removing existing tarball." "no new image files for $vm" "warning"

          fi

        else

          # create compressed tarball with ALL config, nvram, and image files.

          log_message "information: started creating new tarball."

          # create list of files to be backed up.
          backup_file_list="$backup_location/$vm/backup_file_list.txt"

          # remove any existing list of files to be backup and create a blank file.
          if [[ -f "$backup_file_list" ]]; then
            rm -fv "$backup_file_list"
          fi

          log_message "information: creating blank backup file list at $backup_file_list."
          touch "$backup_file_list"

          # for each extension, add it to the list of files to be backed up.
          for extension in "${vdisk_extensions[@]}"

          do

            find "$backup_location/$vm" -type f -name '*.'"$extension" -printf "%f\n" >> "$backup_file_list"

          done

          # see if config files should be backed up and then add any to to the list of files to be backed up.
          if [[ "$backup_xml" -eq 1 ]]; then

            find "$backup_location/$vm" -type f -name '*.xml' -printf "%f\n" >> "$backup_file_list"

          fi

          # see if nvram files should be backed up and then any to to the list of files to be backed up.
          if [[ "$backup_nvram" -eq 1 ]]; then

            find "$backup_location/$vm" -type f -name '*.'"$nvram_extension" -printf "%f\n" >> "$backup_file_list"

          fi

          # backup files based off of backup file list.
          # build tar command.
          tar_cmd=()
          tar_cmd=(tar cvSf)
          tar_cmd+=(-)
          tar_cmd+=(-C)
          tar_cmd+=("$backup_location/$vm/")
          tar_cmd+=(-T)
          tar_cmd+=("$backup_file_list")

          # build gzip command.
          gzip_cmd=()
          gzip_cmd=(gzip)
          gzip_cmd+=(-"$gzip_level")

          # execute commands together to compress files
          (cd "$backup_location/$vm/" && "${tar_cmd[@]}" | "${gzip_cmd[@]}" > "$backup_location/$vm/$timestamp$vm.tar.gz")

          # remove backup file list.
          log_message "information: removing backup file list at $backup_file_list."
          rm -fv "$backup_file_list"

          log_message "information: finished creating new tarball."

          # remove config, nvram, and image files that were compressed.
          # build remove_old_files_cmd.
          build_remove_old_files_cmd "$backup_location/$vm/"

          # execute remove_old_files_cmd to delelte files that were compressed.
          "${remove_old_files_cmd[@]}"

          log_message "information: removed xml, nvram, and image files that were compressed."

        fi

      fi

    else

      # start the vm based on previous state.
      if [ "$vm_original_state" == "running" ]; then

        log_message "information: vm_state is $vm_state. vm_original_state is $vm_original_state. starting $vm." "script starting $vm" "normal"

        if [ "$vm_state" == "paused" ]; then

            # resume vm
            virsh resume "$vm"

          elif [ "$vm_state" == "shut off" ]; then

            # start vm
            virsh start "$vm"

          else

            # there was an error
            log_message "warning: vm_state is $vm_state. vm_original_state is $vm_original_state. unable to start $vm." "script cannot start $vm" "warning"

          fi

      else

        log_message "information: vm_original_state is $vm_original_state. not starting $vm." "script not starting $vm" "normal"

      fi

      # for whatever reason the backup attempt failed.
      log_message "failure: backup of $vm to $backup_location/$vm failed." "backup of $vm failed" "alert"

      # if start_vm_after_failure is set to 1 then start the vm but dont check that it has been successful.
      if [ "$start_vm_after_failure" -eq 1 ]; then

        log_message "information: start_vm_after_failure is $start_vm_after_failure. vm_state is $vm_state. vm_original_state is $vm_original_state. starting $vm." "script starting $vm" "normal"

        if [ "$vm_state" == "paused" ]; then

          # resume vm
          virsh resume "$vm"

        elif [ "$vm_state" == "shut off" ]; then

          # start vm
          virsh start "$vm"

        else

          # there was an error
          log_message "warning: vm_state is $vm_state. vm_original_state is $vm_original_state. unable to start $vm." "script cannot start $vm" "warning"

        fi

      fi

    fi


    log_message "information: backup of $vm to $backup_location/$vm completed." "script completed $vm backup" "normal"

    # check to see how many days backups should be kept.
    if [ "$number_of_days_to_keep_backups" -eq 0 ]; then

      log_message "information: number of days to keep backups set to indefinitely."

    else

      log_message "information: cleaning out backups older than $number_of_days_to_keep_backups days in location ONLY if newer files exist in $backup_location/$vm/" "script removing old backups" "normal"


      # remove old config files if backup_xml is 1.
      if [ "$backup_xml" -eq 1 ]; then
        find_cmd=(find "$backup_location/$vm/" -type f -name '*.xml')
        remove_old_files find_cmd "config"
      fi

      # remove old nvram files if backup_nvram is 1.
      if [ "$backup_nvram" -eq 1 ]; then
        find_cmd=(find "$backup_location/$vm/" -type f -name '*.'"$nvram_extension")
        remove_old_files find_cmd "nvram"
      fi

      # remove old vdisk image files (including inline zstd compressed ones) if backup_vdisks is 1.
      if [ "$backup_vdisks" -eq 1 ]; then
        build_vdisk_extensions_find_cmd "$backup_location/$vm/"
        remove_old_files vdisk_extensions_find_cmd "vdisk image"
      fi

      # remove old tarballs if gzip_compress is 1.
      if [ "$gzip_compress" -eq 1 ]; then
        find_cmd=(find "$backup_location/$vm/" -type f -name '*.tar.gz')
        remove_old_files find_cmd "tarball"
      fi

      # remove old vm log files
      find_cmd=(find "$backup_location/$vm/" -type f -name '*unraid-vmbackup.log')
      remove_old_files find_cmd "vm log"

    fi

    # check to see how many backups should be kept.
    if [ "$number_of_backups_to_keep" -eq 0 ]; then

      log_message "information: number of backups to keep set to infinite."

    else

      log_message "information: cleaning out backups over $number_of_backups_to_keep in location $backup_location/$vm/" "script removing old backups" "normal"

      # remove config files that are over the limit if backup_xml is 1.
      if [ "$backup_xml" -eq 1 ]; then
        find_cmd=(find "$backup_location/$vm/" -type f -name '*.xml')
        remove_over_limit_files find_cmd "$number_of_backups_to_keep" "config"
      fi

      # remove nvram files that are over the limit if backup_nvram is 1.
      if [ "$backup_nvram" -eq 1 ]; then
        find_cmd=(find "$backup_location/$vm/" -type f -name '*.'"$nvram_extension")
        remove_over_limit_files find_cmd "$number_of_backups_to_keep" "nvram"
      fi

      # remove image files that are over the limit if backup_vdisks is 1.
      if [ "$backup_vdisks" -eq 1 ]; then

        # initialize variables to find number of vdisks
        numberofvdisks="1"

        # find each vdisk extension and use it to build a regular expression to get a vdisk's trailing number.
        for extension in "${vdisk_extensions[@]}"
        do

          # if empty, build initial regular expression, otherwise append to it
          if [[ -z "$vdisknumberextregex" ]]; then
            vdisknumberextregex='[0-9]+\.('
            vdisknumberextregex+="$extension"
          else
            vdisknumberextregex+="|$extension"
          fi

          if [ "$inline_zstd_compress" -eq 1 ]; then
            vdisknumberextregex+=".zst"
          fi
        done

        # put closing parenthesis on regular expression.
        vdisknumberextregex+=")"

        # get number of vdisks
        vdisknumberonlyregex="[0-9]+"
        for imagefilename in "$backup_location/$vm/"*
        do
          # get highest number from vdisk count
          if [[ $imagefilename =~ $vdisknumberextregex ]]; then
            imagefilenamenumberext=${BASH_REMATCH[0]}
            if [[ $imagefilenamenumberext =~ $vdisknumberonlyregex ]]; then
              vdisk_numberonly=${BASH_REMATCH[0]}
            fi
          fi
          if [[ "$numberofvdisks" =~ ^[0-9]+$ ]] && [[ "$vdisk_numberonly" =~ ^[0-9]+$ ]]; then
            if [ "$numberofvdisks" -lt "$vdisk_numberonly" ]; then
              numberofvdisks="$vdisk_numberonly"
            fi
          fi
        done

        # create variable equal to number_of_backups_to_keep, times the number of vdisks, to make sure that the correct number of files are kept.
        number_of_files_to_keep=$((number_of_backups_to_keep * numberofvdisks))

        build_vdisk_extensions_find_cmd "$backup_location/$vm/"
        remove_over_limit_files vdisk_extensions_find_cmd "$number_of_files_to_keep" "vdisk image"
      fi

      # remove tarball files that are over the limit if gzip_compress is 1.
      if [ "$gzip_compress" -eq 1 ]; then
        find_cmd=(find "$backup_location/$vm/" -type f -name '*.tar.gz')
        remove_over_limit_files find_cmd "$number_of_backups_to_keep" "tarball"
      fi

      # remove vm log files that are over the limit
      # shellcheck disable=SC2034
      find_cmd=(find "$backup_location/$vm/" -type f -name '*unraid-vmbackup.log')
      remove_over_limit_files find_cmd "$number_of_backups_to_keep" "vm log"

    fi

    unset vm_log_file

    # delete the working copy of the config.
    log_message "information: removing local $vm.xml."
    rm -fv "$vm.xml"

  done

  log_message "information: finished attempt to backup $vms_to_backup_list to $backup_location."


  # check to see if reconstruct write was enabled by this script. if so, disable and continue.
  if [ "$enable_reconstruct_write" -eq 1 ]; then

    /usr/local/sbin/mdcmd set md_write_method 0
    log_message "information: Reconstruct write disabled."

  fi


  # check to see if log file should be kept.
  if [ "$keep_log_file" -eq 1 ]; then

    if [ "$number_of_log_files_to_keep" -eq 0 ]; then

      log_message "information: number of logs to keep set to infinite."

    else

      log_message "information: cleaning out logs over $number_of_log_files_to_keep."

      # create variable equal to number_of_log_files_to_keep plus one to make sure that the correct number of files are kept.
      log_files_plus_1=$((number_of_log_files_to_keep + 1))

      # remove log files that are over the limit.
      if [ "$detailed_notifications" -eq 1 ] && [ "$send_notifications" -eq 1 ] && [ "$only_send_error_notifications" -eq 0 ]; then

        deleted_files=$(find "$backup_location/$log_file_subfolder"*unraid-vmbackup.log -type f -printf '%T@\t%p\n' | sort -t $'\t' -gr | tail -n +$log_files_plus_1 | cut -d $'\t' -f 2- | xargs -d '\n' -r rm -fv --)

        if [[ -n "$deleted_files" ]]; then

          for deleted_file in $deleted_files

          do

            log_message "information: $deleted_file." "script removing logs" "normal"

          done

        else

          log_message "information: did not find any log files to remove." "script removing logs" "normal"

        fi

      else

        deleted_files=$(find "$backup_location/$log_file_subfolder"*unraid-vmbackup.log -type f -printf '%T@\t%p\n' | sort -t $'\t' -gr | tail -n +$log_files_plus_1 | cut -d $'\t' -f 2- | xargs -d '\n' -r rm -fv --)

        if [[ -n "$deleted_files" ]]; then

          for deleted_file in $deleted_files

          do

            log_message "information: $deleted_file."

          done

        else

          log_message "information: did not find any log files to remove."

        fi

      fi

    fi

  fi

  # check to see if error log file should be kept.
  if [ "$keep_error_log_file" -eq 1 ]; then

    if [ "$number_of_error_log_files_to_keep" -eq 0 ]; then

      log_message "information: number of error logs to keep set to infinite."

    else

      log_message "information: cleaning out error logs over $number_of_error_log_files_to_keep."

      # create variable equal to number_of_error_log_files_to_keep plus one to make sure that the correct number of files are kept.
      error_log_files_plus_1=$((number_of_error_log_files_to_keep + 1))

      # remove error log files that are over the limit.
      if [ "$detailed_notifications" -eq 1 ] && [ "$send_notifications" -eq 1 ] && [ "$only_send_error_notifications" -eq 0 ]; then

        deleted_files=$(find "$backup_location/$log_file_subfolder"*unraid-vmbackup_error.log -type f -printf '%T@\t%p\n' | sort -t $'\t' -gr | tail -n +$error_log_files_plus_1 | cut -d $'\t' -f 2- | xargs -d '\n' -r rm -fv --)

        if [[ -n "$deleted_files" ]]; then

          for deleted_file in $deleted_files

          do

              log_message "information: $deleted_file." "script removing error logs" "normal"

          done

        else

          log_message "information: did not find any error log files to remove." "script removing error logs" "normal"

        fi

      else

        deleted_files=$(find "$backup_location/$log_file_subfolder"*unraid-vmbackup_error.log -type f -printf '%T@\t%p\n' | sort -t $'\t' -gr | tail -n +$error_log_files_plus_1 | cut -d $'\t' -f 2- | xargs -d '\n' -r rm -fv --)

        if [[ -n "$deleted_files" ]]; then

          for deleted_file in $deleted_files

          do

            log_message "information: $deleted_file."

          done

        else

          log_message "information: did not find any error log files to remove."

        fi

      fi

    fi

  fi

  # check to see if there were any errors.
  if [ "$errors" -eq 1 ]; then

    log_message "warning: errors found. creating error log file."

    rsync -av "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup.log" "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup_error.log"

    # get rsync result and send notification
    if [[ $? -eq 1 ]]; then

      log_message "failure: $backup_location/$log_file_subfolder$timestamp""unraid-vmbackup_error.log create failed." "error log create failed" "alert"

    fi

  fi

  # check to see if log file should be removed.
  if [ "$keep_log_file" -eq 0 ]; then

    if [ "$errors" -eq 1 ] && [ "$keep_error_log_file" -eq 1 ]; then

      echo "$(date '+%Y-%m-%d %H:%M:%S') warning: removing log file." | tee -a "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup_error.log"

      rm -fv "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup.log"

    else

      log_message "warning: removing log file."

      rm -fv "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup.log"

    fi

  fi

  # check to see if error log file should be removed.
  if [ "$keep_error_log_file" -eq 0 ]; then

    if [ "$keep_log_file" -eq 1 ]; then

      log_message "warning: removing error log file."

      rm -fv "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup_error.log"

    else

      notification_message "warning: removing error log file."

      rm -fv "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup_error.log"

    fi

  fi

  ### Logging Stopped ###
  if [ "$keep_log_file" -eq 1 ]; then

    log_message "Stop logging to log file."

  fi

  if [ "$errors" -eq 1 ] && [ "$keep_error_log_file" -eq 1 ]; then

    echo "$(date '+%Y-%m-%d %H:%M:%S') Stop logging to error log file."  | tee -a "$backup_location/$log_file_subfolder$timestamp""unraid-vmbackup_error.log"

  fi


  if [ "$send_notifications" -eq 1 ]; then

    if [ "$errors" -eq 1 ]; then

      /usr/local/emhttp/plugins/dynamix/scripts/notify -e "unraid-vmbackup_error" -s "unRAID VM Backup script" -d "script finished with errors" -i "alert" -m "$(date '+%Y-%m-%d %H:%M:%S') warning: unRAID VM Backup script finished with errors. See log files in $backup_location/$log_file_subfolder for details."

    elif [ "$only_send_error_notifications" -eq 0 ]; then

      /usr/local/emhttp/plugins/dynamix/scripts/notify -e "unraid-vmbackup_finished" -s "unRAID VM Backup script" -d "script finished" -i "normal" -m "$(date '+%Y-%m-%d %H:%M:%S') information: unRAID VM Backup script finished. See log files in $backup_location/$log_file_subfolder for details."

    fi

  fi

  exit 0

#### code execution end ####


######################################################### script end ###########################################################

# Originally from unraid-autovmbackup by Daniel Jackson (danioj)
# Includes additions for removing old backups added by Deeks
# Includes additions for creating snapshots added by Dikkekop (thies88)

# for original script go to:
# https://lime-technology.com/forum/index.php?topic=47986
# for Deeks script go to:
# https://lime-technology.com/forums/topic/46281-unraid-autovmbackup-automate-backup-of-virtual-machines-in-unraid-v04/?do=findComment&comment=589821
# for Dikkekop (thies88) script go to:
# https://github.com/thies88/unraid-vmbackup