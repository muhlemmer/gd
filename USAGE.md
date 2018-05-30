# Usage

This document outlines the usage and configuration of **gd**.

## Invoking scripts
This package comes with a number of scripts. Some of them are used by the other scripts and don't need to be called by the user. For that reason they are not documented here. Creating a boot-able image is quite simple and can be achieved in three simple steps.
1. Make sure the binaries that will be included in the iso image are installed on the system.
2. Run `gd-mkisofs.sh` to copy all required binaries and libraries in the right location.
3. Run `gd-build-kernel.sh` to compile the kernel and build the iso image.
Using the default configuration, this should be enough to give you a bootable qemu iso image. See the configuration section below how to manipulate this scripts.

### 1. Required packages

The configuration variable `$COMMANDS` are all the commands, that should be included in the image. All the packages providing these commands should be installed before generating the iso file system.

#### Gentoo

For simplicity there is a variable `$PACKAGES`, which should be a list of packages providing the commands. Using the script `gd-update-packages.sh` should pull in all these packages. Note that we use the `--onshot` emerge option, to prevent addition to the world file. On the next `--depclean` all the packages should be unmerged.

#### Other Linux

On any other Linux system, you should install the required packages manually.

### 2. Make iso fs

This script's default behavior is to create a working directory `/var/tmp/gd/isofs` and populate it. The files that will be copied here are determined in 3 steps:
1. All the binaries belonging to `$COMMANDS`. (Using `which`)
2. All the libraries belonging to the binaries (Using `ldd`)
3. All the files found in `/etc/gd/include`, where `include/` is the root of the file system

### 3. Build kernel

By default, this script looks for kernel sources under `/usr/src/linux`. The first step of the script is to run `make clean` to cleanup temporary build objects. If it finds an existing `.config`, a backup will be made in order not to disturb you system's config.

If there is a filename set in variable `$KCONFIG`, it will copy that file to `/usr/src/linux/.config`. If this is not set, a default config is used instead. After `.config` generation, a *configuration merge* is executed to set some specifics from this scripts, like where to find the iso filesystem. There is an option to run `make menuconfig` after these steps, in case you want to check / change options before building. Please note that by default, there is no module handling provided. All drivers required in the image should be builtin.

After configuring, the script executes `make isoimage`, which compiles the kernel, includes the iso filesystem and generates the the bootable iso image. If everything went well, you can find the image at the location set by the `$DEST` variable. (default `/var/tmp/gd/image.iso`)

## Advanced stuff

There is also a script called **`gd-build-packages.sh`**. This is a gentoo specific script and should be used with great caution. You need this script **only** if the system you intend the iso image on has less CPU instruction sets available, or is older then the target that the packages on your system are compiled to. If you are using any other kind of distro, your packages are already generic enough. Probable only gentoo people that use `-march=native` gcc flag might find this script useful to rebuild packages to a generic target. And maybe redefining some USE flags on the way.

### How it works

First, a custom portage configuration directory is copied from `/etc/gd/portage` to `$TEMP/etc/portage`. This will contain the `make.conf` and a portage profile symlink. The profile defaults to the system's own, but can be set in the `$PROFILE` variable if you want to use a lighter profile. However, this can lead to problems in system dependencies and could require some manual tuning of USE flags.

`gd-build-packages.sh` uses the `$COMMANDS` variables to list all files in the same way `gd-mkisofs.sh` is doing. After that it runs `equery belongs` on every file to find its package. All resulting packages are written to `$TEMP/etc/portage/sets/build`.

If a build set already exists, the script will ask if you want te re-generate the file. This is usually only necessary if the last generation got interrupted or the `$COMMAND` set is changed.

#### --backup option

Using this option, the packages mentioned in the *@build* set from above will be packed by `quickpkg` and saved under `$TEMP/packages`. After that it exits. It is highly recommended to run the script in this mode once. It is highly discouraged to run the this script after rebuilding packages, as the wrong packages will be backed up.

If `/var/tmp` is not persistent over reboots, you may want to set `$TEMP` to a alternative location.

#### --restore option

Emerges the *@build* set using the system's native portage settings. This will restore the system in its original state. Where possible, it will use the backed-up packages from `--backup` as mentioned above.

If `$TEMP` was lost due to a reboot or anything else, the script regenerates the *@build* set automatically. It might be worth noting, that it is not recommended to remove commands from the `$COMMAND` variable *until* restore is run. Otherwise, the script will not find all packages.

#### --info option

Do everything from the default run, but run `emerge --info` instead of rebuilding packages and exit. Helpful for troubleshooting and checking the final portage options.

#### Default

If `gd-build-packages.sh` is run without any options, its default is to proceed to re-emerging packages in the *@build* set. This will be against the portage settings in `$TEMP/etc/portage`.

#### Remaining options
Any other command line option, not mentioned here, will be passed directly to all invocations of `emerge`. For example, if you run this script with `--pretend`, all emerge operations will run in pretend mode. Handy if you want to do a dry run.

## Configuration

### /etc/gd/conf.d

First of all, have a look to the (example) configuration files in `/etc/gd/conf.d`. Since some variables are shared between scripts, all the files in `conf.d` are sourced by every script, in ascending order.
If you define a variable setting in a higher numbered file, it overwrites a previous definition. Variables that are commented out, reflect the default setting in the scripts. The example configuration is broken down in multiple files, to reflect the variables which are used by each script. You could, however, define everything in a single file and override the defaults by naming it `99-myconfig.sh`.

All accepted script variables are mentioned and explained in the config files' comments. Please read those for more information.

### /etc/gd/portage

Here you'll find the portage configuration used by the `gd-build-packages.sh` script. If you intend to use that script (not obligatory), you might want to check `make.conf` to reflect the target machine where you want to run the iso on. The default settings compile to a generic x86-64 target, using static linking where possible and optimized for size. In theory this should run on any x86-64 machine. If you are on a different arch, you definitely want to change things here!
There are no facilities in this scripts to cross-compile, but it might be hacked in if you are into that kind of thing.

### /etc/gd/include

These files will be included in the initramfs root. `include` reflects the top level of the initramfs' root file system. There need to be at least an executable `init` implementation there.
It is the projects' goal to provide more meaningful scripts here, but that is still a work in progress.