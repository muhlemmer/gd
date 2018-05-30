#!/bin/sh
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

ETC="/etc/gd"
if [ -d $ETC/conf.d ]; then
	for file in $ETC/conf.d/*.sh; do
		source $file
	done
else
	echo "conf.d not found, skipping." 1>&2
fi

if [ -z "$TEMP" ]; then
	TEMP="/var/tmp/gd"
fi

while test $# -gt 0; do
	case "$1" in
		-*) EMERGE_OPTS="$EMERGE_OPS $1"
			;;
		*) echo "argument $1 incorrect" 1>&2; exit 1
			;;
	esac
	shift
done

emerge --update --newuse --oneshot $EMERGE_OPTS $PACKAGES || exit 4