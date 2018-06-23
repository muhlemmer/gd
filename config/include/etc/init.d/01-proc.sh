#!/bin/sh
# Create /proc if it does not exsits
mkdir -pv /proc || exit 1

# Mount the proc filesystem
mount -t proc none /proc
