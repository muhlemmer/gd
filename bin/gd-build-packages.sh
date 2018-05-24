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

INFO=false
RESTORE=false
TEMP="/var/tmp/gd"
PROFILE="$(realpath /etc/portage/make.profile)" || exit 1

ETC="/etc/gd"
if [ -d $ETC/conf.d ]; then
	for file in $ETC/conf.d/*.sh; do
		source $file
	done
else
	echo "conf.d not found, skipping." 1>&2
fi

while test $# -gt 0; do
	case "$1" in
		--info) INFO=true
			;;
		--restore) RESTORE=true
			;;
		-p) p="-p"
			;;
		--*) echo "bad option $1" 1>&2; exit 1
			;;
		*) echo "argument $1" 1>&2
			;;
	esac
	shift
done

portdir=$TEMP/etc/portage

# pkglist find packages associated to set $COMMANDS
pkglist() {
	set pkgs
	files="$(gd-list-files.sh $COMMANDS)" || exit $?
	for file in $files; do
		echo "Looking for: $file" 1>&2
		p="=$(equery -q belongs -e $file)" || exit 1
		echo "Found: $p" 1>&2
		# Check if package is already included in list
		echo "$pkgs" | grep -q "$p" && continue
		pkgs="$pkgs $p"
	done
	echo "$pkgs"
}

# Restore re-emerges packages from the last run, using the system's own profile.
# The sets are store in $TEMP/etc/portage/sets
# Restore will select the newest set available.
# If there is no set available, restore will attempt to generate a list,
# based on the current settings.
restore() {
	if [ -d $portdir/sets ]; then
		if ! sets=$(ls $portdir/sets/build-*); then
			pkgs=pkglist
		else
			pkgs=$(cat $(echo "$sets" | tail -1)) || exit $1
		fi
	else
		pkgs=pkglist
	fi
	emerge --oneshot --usepkg $p $pkgs || exit 4
	emerge --depclean --ask $p || exit 4
	
	exit 0
}

if $RESTORE; then
	restore
fi

# See if we need to pull in any packages before continuing
emerge --update --oneshot $p $PACKAGES || exit 4

# Prepare temp location
mkdir -pv $TEMP/etc || exit 3
cp -av /etc/gd/portage $TEMP/etc || exit 3
mkdir -pv $portdir/sets || exit 3

echo "Setting profile $PROFILE" 1>&2
# Remove any old symlink
if [ -e $portdir/make.profile ]; then
	rm -fv $portdir/make.profile || exit 2
fi
# Create new symlink
ln -v -s $PROFILE $portdir/make.profile || exit 3

# Final check, see if we did the right thing.
if [ -f $TEMP/etc/portage/make.conf ] && [ -L $TEMP/etc/portage/make.profile ]; then
	export PORTAGE_CONFIGROOT=$TEMP
else
	echo "make.conf not found!" 1>&2
	exit 1
fi

# Prep the @build set
set="build-$(date +%s)"
for pkg in $(pkglist); do
	echo "$pkg" >> $portdir/sets/$set || exit 3
done
	
echo "Generated set in $portdir/sets/$set:" 1>&2
cat $portdir/sets/$set || exit 1

if $INFO; then
	emerge --info
	exit $?
fi

if [[ $p != "-p" ]]; then
	echo "Create backup of existing packages"
	(
		unset PORTAGE_CONFIGROOT
		quickpkg $(cat $portdir/sets/$set) || exit 4
	)
fi

echo "Building packages" 1>&2
emerge $p @$set
e=$?
echo -e "\nTo re-instal the packages to their original state, run $0 --restore"
exit $e

