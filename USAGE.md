# Usage

This document outlines the usage and configuration of **gd**.

## Invoking scripts
This package comes with a number of scripts. Some of them are used by the other scripts and don't need to be called by the user. For that reason they are not documented here. Creating a boot-able image is quite simple and can be achieved in three simple steps.
1. Run `gd-build-packages.sh` to setup an uClibc crossdev environment and emerge the neccesary packages
2. Run `gd-mkisofs.sh` to copy all required binaries and libraries in the right location.
3. Run `gd-build-kernel.sh` to compile the kernel and build the iso image.
Using the default configuration, this should be enough to give you a bootable qemu iso image. See the configuration section below how to manipulate this scripts.

### 1. gd-build-packages.sh

The configuration variable `$COMMANDS` are all the commands, that should be included in the image. All the packages providing these commands should be mentions in the `$PACKAGES` variable.

Any command line option will be passed directly to the final invocations of `emerge`. For example, if you run this script with `--pretend`, the emerge operation will run in pretend mode. Handy if you want to do a dry run. See `man emerge` for more details.

### 2. gd-mkisofs.sh

This script's default behavior is to create a working directory `/usr/src/isofs` and populate it. The files that will be copied here are determined in 3 steps:
1. All the binaries belonging to `$COMMANDS`. (Using `which`)
2. All the libraries belonging to the binaries (Using a `ldd`-like method)
3. All the files found in `/etc/gd/include`, where `include/` is the root of the file system

### 3. gd-build-kernel.sh

By default, this script looks for kernel sources under `/usr/src/linux`. The first step of the script is to run `make clean` to cleanup temporary build objects. If it finds an existing `.config`, a backup will be made in order not to disturb you system's config.

If there is a filename set in variable `$KCONFIG`, it will be used as the base for a *configuration merge*. If this is not set, a default config is used as base instead. The base configuration will be merged with some specific configurations from this script, like where to find the iso filesystem. There is an option to run `make menuconfig` after these steps, in case you want to check / change options before building. Please note that by default, there is no module handling provided. All drivers required in the image should be builtin.

After configuring, the script executes `make isoimage`, which compiles the kernel, includes the iso filesystem and generates the the bootable iso image. If everything went well, you can find the image at the location set by the `$DEST` variable. (default `/var/tmp/gd/image.iso`)

## Configuration

### /etc/gd/gd.conf

First of all, have a look to the (example) configuration file `/etc/gd/gd.conf`. Variables that are commented out, reflect the default setting in the scripts. All accepted script variables are mentioned and explained in the config file's comments. Please read those for more information.

### /etc/gd/portage

Here you'll find the portage configuration used by the `gd-build-packages.sh` script. You might want to check `make.conf` to reflect the target machine where you want to run the iso on. The default settings compile to a generic x86-64 uClibc target, using static linking where possible and optimized for size. In theory this should run on any x86-64 machine. If you are on a different arch, you definitely want to change things here!

### /etc/gd/include

These files will be included in the initramfs root. `include` reflects the top level of the initramfs' root file system. There need to be at least an executable `init` implementation there. By default it already includes the run scripts to get the system initialized up to a working wired network connection.
