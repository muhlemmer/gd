#!/bin/sh

# Mount the devtmpfs filesystem
mount -t devtmpfs none /dev || exit 1
mkdir -pv /dev/shm || exit 1
mount -t tmpfs none /dev/shm || exit 1