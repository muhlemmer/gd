#!/bin/sh
# gd; Create an as small as possible iso image, 
# containing only the bare minimals to download and extract a stage-3.
#
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

# Commands to be included in initramfs
COMMANDS="busybox" #mkfs.ext2 mkfs.ext3 mkfs.ext4 mkfs.btrfs btrfs sfdisk"