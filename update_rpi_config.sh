#!/bin/sh

# generate command line
echo "dwc_otg.fiq_fix_enable=1 sdhci-bcm2708.sync_after_dma=0 dwc_otg.lpm_enable=0 console=ttyAMA0,115200" > $BINARIES_DIR/rpi-firmware/cmdline.txt

# generate default config
cat <<EOF >$BINARIES_DIR/rpi-firmware/config.txt
arm_freq=700
core_freq=250
kernel=zImage
disable_overscan=1
gpu_mem_256=100
gpu_mem_512=100
sdram_freq=400
over_voltage=0
initramfs rootfs.cpio.gz followkernel
EOF

