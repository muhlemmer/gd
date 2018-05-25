# gd; Short for gentoo-deploy. Create an iso image that deploys gentoo.
# Copyright (C) 2018  Tim Möhlmann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This file is an example config. Default settings are mentioned and commented out.
# The settings given here are used by all gd-*.sh scripts.

# Where the scripts will store work info. The default resides in /var/tmp and most
# probably gets erased upon reboot. If you want to keep the info (like modified package set)
# move it to somewhere else!
# TEMP=/var/tmp/gd

# Portage profile to use for build. Has to be an absolute path!
# Default will determine the current system profile and copy it
PROFILE="/usr/portage/profiles/default/linux/amd64/17.0/no-multilib"

# Where to copy the resulting .iso image
export DEST="/tmp"

# Commands to be included in initramfs
COMMANDS="busybox mkfs.ext4 mkfs.btrfs btrfs sfdisk mkfs.reiser4"

# List of packages which provide the required commands.
# This is only to help the execution of the script.
# As it will try to rebuild packages based on the requested COMMANDS.
# However, the script will fail if it cannot find a binary
# This setting will pull in the packages required before searching.
# The packages will be subject to an `emerge --update --onshot` on
# the machine's own /etc/portage.
PACKAGES="sys-apps/busybox sys-fs/btrfs-progs sys-fs/e2fsprogs sys-apps/util-linux sys-fs/reiser4progs"