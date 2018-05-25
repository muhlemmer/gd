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
# However, variables given in this example only apply to gd-build-packages.sh

# Run emerge --info after setting everything up and exit.
# Usefull as dry run to check if setting are ok
# This mode can also be invoked by using the '--info' command line option
# INFO=false

# Run a restore, session. Restore rebuilds packages to the original state,
# using the sytem's own profile and make.conf.
# If there are any backed up packages present, those will be used.
# RESTORE=false

# Create a backup using 'quickpkg' and exit.
# Better use command line option '--backup' once and then run the script normally.
# BACKUP=false

# In principle, all portage options can be set in /etc/gd/portage/make.conf.
# Exported variables will override those settings.
# See `man portage` and `man emerge` for more info.

# Where the backed-up system packages are put and restored from.
# export PKGDIR="$TEMP/packages"

# Makeopts overide;
export MAKEOPTS="-j8"