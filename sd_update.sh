#!/bin/bash
set -i

img=output/images/sdcard.img
dev_sdcard=${1:-/dev/sdb}

sudo eject -vt $dev_sdcard
echo Copying $img to $dev_sdcard
sudo dd if=$img of=$dev_sdcard bs=1M
sudo eject -v $dev_sdcard

