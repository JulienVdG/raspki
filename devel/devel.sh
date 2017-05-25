#!/bin/sh

mkdir /boot
mount /dev/mmcblk0p1 /boot

udhcpc
/root/S50sshd start

