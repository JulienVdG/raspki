# raspki
a Raspberry PI as an offline PKI

# get buildroot
either clone with `--recursive` option
or use `git submodule update --init`

# build step

1. build toolchain: `make -f Makefile.toolchain`

2. build raspki: `make`

# install

Identify your sdcard device (assuming sdb bellow)
```
sudo dd if=output/images/sdcard.img of=/dev/sdb bs=1M
```

