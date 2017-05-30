################################################################################
#
# easy-rsa
#
################################################################################

EASY_RSA_VERSION = 3.0.1
EASY_RSA_SOURCE = EasyRSA-$(EASY_RSA_VERSION).tgz
EASY_RSA_SITE = https://github.com/OpenVPN/easy-rsa/releases/download/$(EASY_RSA_VERSION)

define EASY_RSA_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/easyrsa $(TARGET_DIR)/usr/bin/easyrsa
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/easy-rsa/x509-types
	$(INSTALL) -D -m 0644 $(@D)/x509-types/* $(TARGET_DIR)/etc/easy-rsa/x509-types
	$(INSTALL) -D -m 0644 $(@D)/openssl-1.0.cnf $(TARGET_DIR)/etc/easy-rsa/openssl-1.0.cnf
	$(INSTALL) -D -m 0644 $(@D)/vars.example $(TARGET_DIR)/etc/easy-rsa/vars
endef

$(eval $(generic-package))
