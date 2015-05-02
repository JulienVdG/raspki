# Makefiles used by all subprojects

BR2_ROOTFS_POST_BUILD_SCRIPT += $(BR2_EXTERNAL)/ssh_devel.sh

BR2_ROOTFS_POST_IMAGE_SCRIPT += $(BR2_EXTERNAL)/update_rpi_config.sh
