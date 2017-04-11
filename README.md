# raspki
a Raspberry PI as an offline PKI

# get buildroot
either clone with `--recursive` option
or use `git submodule update --init`

# build step

1. build toolchain: `make -f Makefile.toolchain`

2. build raspki: `make`

# install

Mount SdCard as `/media/usb0` then copy the files:
```
cp -R output/images/rpi-firmware/* /media/usb0
cp output/images/zImage /media/usb0
cp output/images/rootfs.cpio.gz /media/usb0
```

