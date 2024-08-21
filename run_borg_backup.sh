#!/bin/sh

# Root Paths
ROOT_BACKUP_PATH="/mnt/media/backups"
ROOT_SYNCTHING_PATH="/mnt/media/syncthing/Sync"
HOME_PATH="/home/aigoncharov"
STACKS_DEFINITIONS_ROOT="/opt/stacks"
STACKS_DATA_PATH="/var/opt/stacks"

run_borg () {
  borg create -s "$2::{now}" "$1"
  borg prune -s --keep-daily 3 --keep-weekly 4 "$2"
  borg compact "$2"
}

run_borg "${ROOT_SYNCTHING_PATH}/Bills" "${ROOT_BACKUP_PATH}/bills"
run_borg "${ROOT_SYNCTHING_PATH}/Books" "${ROOT_BACKUP_PATH}/books"
run_borg "${HOME_PATH}/.config" "${ROOT_BACKUP_PATH}/home_config"
run_borg "${STACKS_DEFINITIONS_ROOT}/config" "${ROOT_BACKUP_PATH}/stacks_config"
run_borg "${STACKS_DEFINITIONS_ROOT}/definitions" "${ROOT_BACKUP_PATH}/stacks_definitions"
run_borg "/mnt/media/mail_archives" "${ROOT_BACKUP_PATH}/mail_archives"
run_borg "${ROOT_SYNCTHING_PATH}/Obsidian" "${ROOT_BACKUP_PATH}/obsidian"
run_borg "${ROOT_SYNCTHING_PATH}/Personal" "${ROOT_BACKUP_PATH}/personal"
run_borg "${STACKS_DATA_PATH}/baikal" "${ROOT_BACKUP_PATH}/baikal"
run_borg "${STACKS_DATA_PATH}/offlineimap" "${ROOT_BACKUP_PATH}/mail_current"

# Custom runs
MINIFLUX_BACKUP_PATH="/mnt/media/backups/miniflux"
borg create --content-from-command "$MINIFLUX_BACKUP_PATH::{now}" -- docker exec -t miniflux_server /usr/bin/miniflux -export-user-feeds aigoncharov
borg prune -s --keep-daily 3 --keep-weekly=4 "$MINIFLUX_BACKUP_PATH"
borg compact "$MINIFLUX_BACKUP_PATH"

borg create -s "$IMMICH_BACKUP_PATH::{now}" "$IMMICH_SOURCE_PATH" --exclude "${IMMICH_SOURCE_PATH}/thumbs/" --exclude "${IMMICH_SOURCE_PATH}/encoded-video/"
borg prune -s --keep-daily 3 --keep-weekly=4 "$IMMICH_BACKUP_PATH"
borg compact "$IMMICH_BACKUP_PATH"

# Upload
rclone sync --fast-list -L --stats-log-level NOTICE --stats 10000h /mnt/media/gdrive/borg_backups gdrive:/borg_backups
