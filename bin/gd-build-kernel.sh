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
KDIR="/usr/src/linux"
CLEAN=true
MENUCONFIG=false
JOBS=1
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
if [ -z "$DEST" ]; then
	DEST="$TEMP"
fi
if [ -z "$TARGET" ]; then
	TARGET="$TEMP/isofs"
fi

if [ ! -f $KDIR/scripts/kconfig/merge_config.sh ]; then
	echo "$KDIR is not pointing to a set of kernel sources! Aborting..."
	exit 1
fi

restore_cfg() {
	if [ -f gd-kconfig.patch ]; then
		rm -v gd-kconfig.patch
	fi
	if [ -f kconfig.bak ]; then
		echo "Restoring kernel config backup"
		if ! cp -v kconfig.bak .config; then
			echo "Restoring backup failed!"
			exit 3
		fi
	fi
	if $CLEAN; then
		echo "Running \"make clean\""
		make clean || restore_cfg 2
	fi
	exit $1
}

if [ ! -x $TARGET/init ]; then
	echo "$TARGET doesn't contain a valid iso filesystem. It needs at least an executable /init!"
	echo "Did you run gd-mkisofs.sh, before this script?"
	exit 1
fi

echo "cd $KDIR"
cd $KDIR
# Backup any existing config
if [ -f .config ]; then
	echo "$KDIR/.config exists, creating backup."
	cp -v .config kconfig.bak || exit 3
fi
# If $KCONFIG is set, use that file
if [ -n "$KCONFIG" ]; then
	if [ ! -f "$KCONFIG" ]; then
		echo "$KCONFIG not found! Aborting..."
		exit 1
	fi
	echo "Copying $KCONFIG to $KDIR/.config"
	cp -v $KCONFIG .config || exit 3
	echo "Running \"make silentoldconfig\""
	make silentoldconfig || restore_cfg 3
else
	make defconfig
fi

cat <<EOF > gd-kconfig.patch
CONFIG_BLK_DEV_INITRD=y
# Target as used by gd-mkisofs.sh
CONFIG_INITRAMFS_SOURCE="$TARGET"
EOF

scripts/kconfig/merge_config.sh .config gd-kconfig.patch || restore_cfg 4

if $CLEAN; then
	echo "Running \"make clean\""
	make clean || restore_cfg 2
fi
if $MENUCONFIG; then
	echo "Running \"make menuconfig\""
	make menuconfig || restore_cfg 4
fi

echo "Running \"make -j$JOBS isoimage\""
if ! make -j$JOBS isoimage; then
	echo "!!! Build of kernel image failed..."
	restore_cfg 4
fi
cp -av arch/x86/boot/image.iso $DEST || restore_cfg 3

restore_cfg 0