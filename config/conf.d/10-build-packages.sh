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
# This file is sourced by all gd-*.sh scripts.
# However, variables given in this example only apply to gd-build-packages.sh

# In principle, all portage options can be set in /etc/gd/portage/make.conf.
# Exported variables will override those settings.
# See `man portage` and `man emerge` for more info.

# Example makeopts overide;
# export MAKEOPTS="-j8"

# List of required packages to emerge in crossdev target.
PACKAGES="sys-apps/busybox sys-fs/btrfs-progs sys-fs/e2fsprogs sys-apps/util-linux dev-util/strace"