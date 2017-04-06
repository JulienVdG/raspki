################################################################################
#
# dieharder
#
################################################################################

DIEHARDER_VERSION = 3.31.1
DIEHARDER_SITE = http://www.phy.duke.edu/~rgb/General/dieharder
DIEHARDER_SOURCE = dieharder-$(DIEHARDER_VERSION).tgz
DIEHARDER_STRIP_COMPONENTS = 2
DIEHARDER_LICENSE = GPLv2 with beverage clause
DIEHARDER_LICENSE_FILES = COPYING
DIEHARDER_DEPENDENCIES = gsl host-libtool

# Fix m4 links to points to the ones in staging (provided by libtool hence
# the patch dependency).
define DIEHARDER_POST_PATCH_FIXUP
        for m in $(@D)/m4/*; do \
		l=$$(readlink $$m) ;\
		rm $$m ;\
		ln -s $(HOST_DIR)$$l $$m ;\
	done
endef
DIEHARDER_POST_PATCH_HOOKS += DIEHARDER_POST_PATCH_FIXUP

# Ensure the libtool version is updated,
# also make _CONF_ENV works instead of _CONF_OPTS for endiannes
DIEHARDER_AUTORECONF = YES

# fix endiannes detection
ifeq ($(BR2_ENDIAN),"BIG")
DIEHARDER_CONF_ENV = ac_cv_c_endian=big
else
DIEHARDER_CONF_ENV = ac_cv_c_endian=little
endif

# parallel build fail, disable it
DIEHARDER_MAKE = $(MAKE1)

$(eval $(autotools-package))
