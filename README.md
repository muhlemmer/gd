# GD

Create an as small as possible iso image, containing only the bare minimals to download and extract a stage-3. People who want to deploy more instances of gentoo, can do so easily and automated using this tool. The tools in this project are written completely in shell script, and are easy to hack.

Possible usecases:
* A cheap to store installation iso on cloud computing platforms
* Send the iso by e-mail, because it's really small
* Use scripts to fully auto-deploy gentoo instances.
   * Because the image is small, you can easily store dedicated images for server specific configurations, cheap.
   * Quickly fire up a server, using the customizations from you favorite distro!
   * It becomes more powerfull if you pull in pre-compiled packages from a server
* Create a miniature rescue cd, with only the tools the really need.

gd is short for gentoo-deploy. Gentoo is a registered trademark from the Gentoo Foundation, Inc. The tools in this repository target the gentoo distribution. However, there is no affiliation between this project and the official Gentoo distribution.

## Getting Started

Before you get started with this scripts, please know that this tools are for expert users only! The scrips can mess with you system in ways unimaginable! The resulting iso system, by default, is just a BusyBox shell with a few tools. This means it is more bear-bones than the gentoo minimal-install cd, and not backup up at all by the gentoo handbook! Do not expect to get any kind of help from the community if you wrecked your system with this scripts!

### Prerequisites

This scripts depends on:
* Working shell (bash, sh, ash, busybox)
* Gentoolkit, for equery.
* Set of kernel sources (by default in /usr/src/linx, settable)
* Syslinux, used by the kernel's iso generation script

### Installing

Installing is simple. The scripts in the `bin/` directory belong somewhere in `$PATH`. The contents of `config/` should be copied to `/etc/gd`.

See [INSTALLING.md](INSTALLING.md) for more details. After installing you might want to read [USAGE.md](USAGE.md) for more documentation.

## Support

These scripts are quite strait forward and are just a list of steps you would need to do if you'd want to create a boot-able iso image for a generic target, on a gentoo machine, manually. The target audience is experienced users, who can easily modify the scripts in case they don't work. For that reason, it is not the developer's intention to provide any support to persons who wracked their system using any of this scripts.

If there is anything unclear in the documentation, please raise an issue and I will get back to you as soon as possible.

### Issue / bug reporting

Please don't raise issues requesting all kinds of functionality, you are free to contribute instead.
Any package build failures are usually just the result of a mismatch between the system's native profile and the one `gd-build-packages.sh` attempts to compile to.
You need to examine and play around with package useflags and portage configuration to get it going the right way.

If, however you find a miss-behaviour of the scripts itself, please raise an issue explaining:
 1. Which of the scripts
 2. What did you expect to happen?
 3. What happened?

## Contributing

Please send a pull request for any improvements made. For any changes towards the portage config, please explain carefully how such a setting would serve the world and not just your setup.

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
