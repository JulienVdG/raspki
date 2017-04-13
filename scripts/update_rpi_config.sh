#!/bin/sh

# generate command line
echo "console=ttyAMA0,115200" > $BINARIES_DIR/rpi-firmware/cmdline.txt

# generate default config
cat <<EOF >$BINARIES_DIR/rpi-firmware/config.txt
kernel=zImage
initramfs rootfs.cpio.gz followkernel
disable_overscan=1
gpu_mem_256=100
gpu_mem_512=100
gpu_mem_1024=100
EOF

