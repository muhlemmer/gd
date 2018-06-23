#!/bin/sh

# Bring up the loopback network
ifconfig lo 127.0.0.1 || exit 1
