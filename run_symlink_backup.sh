#!/bin/bash
rclone sync --fast-list -L --stats-log-level NOTICE --stats 10000h /mnt/media/gdrive/symlink_backups gdrive:/symlink_backups
