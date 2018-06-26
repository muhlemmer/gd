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
if [ -e $ETC/gd.conf ]; then
	source $ETC/gd.conf
else
	echo "Configuration file not found, skipping." 1>&2
fi

if [ -z "$TARGET" ]; then
	TARGET="x86_64-nomultilib-linux-uclibc"
fi

if [ -z "$ISOFS" ]; then
	ISOFS="/usr/src/isofs"
fi

if [ "$ISOFS" == "/" ]; then
	echo "ISOFS set to filesystem root (\"/\")! Are you mad!? Aborting..."
	exit 1
fi

if [ ! -d /usr/$TARGET ]; then
	echo "/usr/$TARGET does not exist! Please run gd-build-packages.sh first"
	exit 1
fi

if [ -d $ISOFS ]; then
	echo "$ISOFS already exists!"
	while true; do
		read -p "This script will delete and overwrite ALL files in $ISOFS! Do you want to continue? (yes)" answ
		case $answ in  
			yes|Yes|YES) break ;; 
			no|No|NO) echo "Aborting..."; exit 3 ;; 
			*) echo -e "\nInput not understood: $answ." ;; 
		esac
	done
	rm -rfv $ISOFS || exit 2
fi

if ! mkdir -pv $ISOFS/{bin,dev,sbin,etc,proc,sys/kernel/debug,usr/{bin,sbin},lib,lib64,mnt/root,root}; then
	echo "Creating directory structure failed!"
	exit 1
fi

if ! cp -av /dev/{null,console,tty} $ISOFS/dev; then
	echo "Copying /dev nodes failed!"
	exit 1
fi

lf=$(which gd-list-files.sh || exit $?)
cp -av $lf /usr/$TARGET || exit 3

files="$(chroot /usr/$TARGET /gd-list-files.sh $COMMANDS)" || exit $?

# Copies all the files to ISOFS
# Creates directories if required
echo "Copying files..."
cd /usr/$TARGET
for file in $files; do
	cp -av --parents ${file:1} $ISOFS
done

# Copy include folder
if [ -d $ETC/include ] && [ -n "$(ls -A $ETC/include)" ]; then
	if ! cp -av $ETC/include/* $ISOFS; then
		echo "Copying include dir contents failed"
		exit 1
	fi
fi

if [ -f $ISOFS/init ]; then
	if ! chmod -v +x $ISOFS/init; then
		echo "Failed to set +x on $ISOFS/init"
		exit 3
	fi
else
	if ! ln -sv bin/busybox $ISOFS/init; then
		echo "Failed to create init symlink in $ISOFS"
		exit 3
	fi
fi
