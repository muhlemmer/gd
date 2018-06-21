#!/bin/sh
# Setup mdev

echo /sbin/mdev > /proc/sys/kernel/hotplug || exit 1
mdev -s || exit 1