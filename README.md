# GD

gd is short for gentoo-deploy. Create an as small as possible iso image, containing only the bare mimimals to download and extract a stage-3. People who want to deploy more instances of gentoo, can do so easilty and automated using this tool. Handy for cloud computing, Qemu intances and more. The tools in this project are written completely in shell script, and are easy to hack.

Gentoo is a registered trademark from the Gentoo Foundation, Inc. The tools in this repository target the gentoo distribution. However, there is no affiliation between this project and the official Gentoo distribution.

## Getting Started

Before you get started with this scripts, please know that this tools are for expert users only! The scrips can mess with you system in ways inimaginable! The resulting iso system, by default, is just a BusyBox shell with a few tools. This means it is more bear-bones than the minimal-install cd, and not backup up at all by the gentoo handbook! Do not expect to get any kind of help from the community if you wrecked your system with this scripts!

### Prerequisites

This scripts depends on:
* Working shell (bash, sh, ash, busybox)
* Gentoolkit, for equery.
* Set of kernel sources (by default in /usr/src/linx, costumizable)
* Syslinux, used by the kernel's iso generation script

For instace, this should give you all you need, update to the latest version:
```
emerge -avu app-shells/bash app-portage/gentoolkit sys-kernel/gentoo-sources sys-boot/syslinux
eselect kernel list
eselect kernel set <target>
```

### Installing

Download the project from github. If you don't want to use git, download the ZIP archive from [website on GitHub](https://github.com/muhlemmer/gd), and extract it somewhere. 

```
mkdir gd
cd gd
git clone https://github.com/muhlemmer/gd.git
```
The scripts in `bin/` should be copied somewhere in your `$PATH` for example `/usr/local/bin`.
```
su -
cp -av bin/* /usr/local/bin
```
The contents of `config/` should be copied to `/etc/gd`.
```
mkdir /etc/gd
cp -av config/* /etc/gd
```

## Configuration

### /etc/gd/conf.d

First of all, have a look to the (example) configuration files in `/etc/gd/conf.d`. Since some variables are shared between scripts, all the files in `conf.d` are sourced by every script, in ascending order.
If you define a variable setting in a higher numbered file, it overwrites a previous definition. Variables that are commented out, reflect the default setting in the scripts. The example configuration is broken down in multiple files, to reflect the variables which are used by each script. You could, however, define everything in a single file and override the defaults by naming it `99-myconfig.sh`.

All accepted script variables are mentioned and explianed in the config files' comments. Please read those for more information.

### /etc/gd/portage

Here you'll find the portage configuration used by the `gd-build-packages.sh` script. If you intend to use that script (not obligatory), you might want to check `make.conf` to reflect the target machine where you want to run the iso on.
The default settings compile to a generic x86-64 target, using static linking where possible and optimised for size. In theory this should run on any x86-64 machine.
If you are on a different arch, you defenitly want to change things here!
There are no facilites in this scripts to cross-compile, but it might be hacked in if you are into that kind of thing.

### /etc/gd/include

These files will be included in the initramfs root. `include` reflects the top level of the initramfs' root filesystem. There need to be at least an executable `init` implementation there.
It is the projets' goal to provide more meanigful scripts here, but that is stil a work in progress.

## Support

These scripts are quite strait forward and are just a list of steps you would need to do if you'd want to create a bootable
iso image for a generic target, on a gentoo machine, manually. The target audience is experienced users, who can easily modify the scripts in case thay don't work. For that reason, it is not the developer's intention to provide any support to
persons who wracked their system with this scripts.

Please note that executable script documentation is this a work is process, but in the end should cover everything you need to know.
If there is anything unclear documentation wise, you can raise an issue and I'll get back to you asap.

### Issue / bug reporting

Please don't raise issues requesting all kinds of functionality, you are free to contribute instead.
Any package build failures are ussualy just the result of a mismatch between the system's native profile and the one gd-build-packages.sh attempts to compile to.
You need to examine and play around with package useflags and portage configuration to get it going the right way.

If, however you find a mis-behaviour of the scripts itself, please raise an issue explaining:
 1. Which of the scripts
 2. What did you expect to happen?
 3. What happened?

## Contributing

Please send a pull request for any improvements made. For any changes towards the portage config, please explain carfully how such a setting would serve the world and not just your setup.

## License

This project is licensed under GPL v.3 - see the [LICENSE.txt](LICENSE.txt) file for details.

gd; Short for gentoo-deploy. Create an iso image that deploys gentoo.
Copyright (C) 2018  Tim Möhlmann

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
