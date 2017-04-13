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

# test the random generator

```
dieharder -a -g 201 -f /dev/hwrng
```
This is _VERY_ slow the raspberry pi rng has a low bandwidth.
About 2.84e+04 rands/second as reported by dieharder mesured on a raspberry pi 2.

```
dieharder -a -g 201 -f /dev/chaoskey0
```
The ChaosKey is a little faster 6.20e+04 rands/second when connected to a raspberry pi2.

To test /dev/random use:
```
dieharder -a -g 500
```
