#!/bin/sh
# Create /sys if it does not exsits
mkdir -pv /sys || exit 1

# Mount the sys filesystem
mount -t sysfs none /sys