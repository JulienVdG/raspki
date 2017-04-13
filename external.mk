# Makefiles used by all subprojects
include $(sort $(wildcard $(BR2_EXTERNAL)/package/*/*.mk))

BR2_ROOTFS_POST_BUILD_SCRIPT += $(BR2_EXTERNAL)/scripts/ssh_devel.sh

BR2_ROOTFS_POST_IMAGE_SCRIPT += $(BR2_EXTERNAL)/scripts/update_rpi_config.sh

DEPLOY_FILES = $(BINARIES_DIR)/rpi-firmware/* $(BINARIES_DIR)/zImage $(BINARIES_DIR)/rootfs.cpio.gz
DEPLOY_SSH_OPTS ?= -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null"
DEPLOY_SSH_USERHOST ?= root@$(BR2_TARGET_GENERIC_HOSTNAME)

deploy-sd:
	if [ -d $(DEPLOY_DIR) ]; then cp -R $(DEPLOY_FILES) $(DEPLOY_DIR); fi

deploy-ssh:
	scp $(DEPLOY_SSH_OPTS) -r $(DEPLOY_FILES) $(DEPLOY_SSH_USERHOST):/boot

