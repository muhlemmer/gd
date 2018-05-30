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

if [ -z "$TEMP" ]; then
	TEMP="/var/tmp/gd"
fi
if [ -z "$TARGET" ]; then
	TARGET="$TEMP/isofs"
fi

if [ "$TARGET" == "/" ]; then
	echo "Target set to filesystem root (\"/\")! Are you mad!? Aborting..."
	exit 1
fi

if [ -d $TARGET ]; then
	echo "$TARGET already exists!"
	while true; do
		read -p "This script will delete and overwrite ALL files in $TARGET! Do you want to continue? (yes)" answ
		case $answ in  
			yes|Yes|YES) break ;; 
			no|No|NO) echo "Aborting..."; exit 3 ;; 
			*) echo -e "\nInput not understood: $answ." ;; 
		esac
	done
	rm -rfv $TARGET || exit 2
fi

if ! mkdir -pv $TARGET/{bin,dev,sbin,etc,proc,sys/kernel/debug,usr/{bin,sbin},lib,lib64,mnt/root,root}; then
	echo "Creating directory structure failed!"
	exit 1
fi

if ! cp -av /dev/{null,console,tty} $TARGET/dev; then
	echo "Copying /dev nodes failed!"
	exit 1
fi

files="$(gd-list-files.sh $COMMANDS)" || exit $?

# Copies all the files to TARGET
# Creates directories if required
echo "Copying files..."
cp --parents -av $files "$TARGET"

# Copy include folder
if ! cp -av $ETC/include/* $TARGET; then
	echo "Copying include dir contents failed"
	exit 1
fi

if ! chmod -v +x $TARGET/init; then
	echo "Failed to set +x on $TARGET/init"
	exit 1
fi
