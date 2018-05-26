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
