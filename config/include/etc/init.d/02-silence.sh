#!/bin/sh

#Silence kernel messages
echo "3 3 3 3" > /proc/sys/kernel/printk
echo "Kernel silenced"