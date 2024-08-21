#!/bin/sh

rclone sync --fast-list --stats-log-level NOTICE --stats 10000h --delete-before gdrive:/ /mnt/media/gdrive --exclude="borg_backups" --exclude="symlink_backups/**"
