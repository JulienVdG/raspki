# raspki
a Raspberry PI as an offline PKI

# get buildroot
either clone with `--recursive` option
or use `git submodule update --init`

# build step

1. build toolchain: `make -f Makefile.toolchain oldconfig toolchain`

2. build raspki: `make`
