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

ETC="/etc/gd"
if [ -d $ETC/conf.d ]; then
	for file in $ETC/conf.d/*.sh; do
		source $file
	done
else
	echo "conf.d not found, skipping." 1>&2
fi

if [ -z "$TARGET" ]; then
	TARGET="x86_64-nomultilib-linux-uclibc"
fi

# Any command line args that start with "-" are passed to emerge.
# Plain arguments (without "-") are invalid
while test $# -gt 0; do
	case "$1" in
		-*) EMERGE_OPTS="$EMERGE_OPTS $1"
			;;
		*) echo "argument $1 incorrect" 1>&2; exit 1
			;;
	esac
	shift
done

cd=true
if [ -d $TARGET ]; then
	while true; do
		read -p "/usr/$TARGET already exists. Re-run 'crossdev'? [y/n] " answ
		case $answ in
			y|Y)	break ;;
			n|N)	cd=false; break;;
			*)		echo -e "\nInput not understood: $answ." ;;
		esac
	done
fi
	
# Setup crossdev target
if $cd; then
	crossdev --stable -t $TARGET || exit 3
fi
# Copy over our own make.conf
cp -av /etc/gd/portage $TARGET/etc || exit 3

echo "Building packages" 1>&2
$TARGET-emerge $EMERGE_OPTS $PACKAGES
exit $?
