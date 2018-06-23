#!/bin/sh

# Bring up the eth0 interface
ifconfig eth0 up || exit 1

# Use udhcpc to obtain adress. Script is run to set the interface
udhcpc -s /etc/udhcpc/simple.script.sh -i eth0