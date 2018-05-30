# Installing

This document outlines a instalation example for **gd**.

## Install dependecies (Gentoo only)

On a gentoo system, the following commands should pull in this program's dependecies:
```
emerge -avu app-shells/bash app-portage/gentoolkit sys-kernel/gentoo-sources sys-boot/syslinux
eselect kernel list
eselect kernel set <target>
```

## Install gd

Download the project from github. If you don't want to use git, download the ZIP archive from the project’s [website on GitHub](https://github.com/muhlemmer/gd), and extract it somewhere. 

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

## Alternative: set $PATH

Alternativly, you could skip to copy the scripts from `bin/` and just set your `$PATH` environment variable to the package `bin/` directory,
```
export PATH=$PATH:/path/to/gd/bin
```
