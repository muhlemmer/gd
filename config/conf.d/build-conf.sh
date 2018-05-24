# TEMP=/var/tmp/gd
# INFO=false
# RESTORE=false
# RESTOREONLY=false

# Portage profile to use for build. Has to be full path!
# PROFILE="/usr/portage/profiles/default/linux/amd64/17.0/no-multilib"

# Jobs for kernel building
MAKEOPTS="-j8"

# Where to copy the resulting .iso image
export DEST="/tmp"

# Commands to be included in initramfs
COMMANDS="busybox mkfs.ext4 mkfs.btrfs btrfs"

# List of packages which provide the required bins.
# This is only to help the execution of the script.
# As it will try to rebuild packages based on the requested COMMANDS.
# However, the script will fail if it cannot find a binary
# This setting will pull in the packages required before searching.
# The packages will be subject to an `emerge --update --onshot` on
# the machine's own /etc/portage.
PACKAGES="sys-fs/btrfs-progs"

# Exported variables will be available inside portage / emerge
# See `man portage` and `man emerge` for more info