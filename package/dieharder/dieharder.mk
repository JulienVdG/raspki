################################################################################
#
# dieharder
#
################################################################################

DIEHARDER_VERSION = 3.31.1
DIEHARDER_SITE = http://www.phy.duke.edu/~rgb/General/dieharder
DIEHARDER_SOURCE = dieharder-$(DIEHARDER_VERSION).tgz
DIEHARDER_SUBDIR = dieharder-$(DIEHARDER_VERSION)
DIEHARDER_LICENSE = GPLv2 with beverage clause
DIEHARDER_LICENSE_FILES = $(DIEHARDER_SUBDIR)/COPYING
DIEHARDER_DEPENDENCIES = gsl

#DIEHARDER_CONF_OPTS = --includedir=$(STAGING_DIR)/usr/include
# fix endiannes detection
ifeq ($(BR2_ENDIAN),"BIG")
DIEHARDER_CONF_ENV = ac_cv_c_endian=big
else
DIEHARDER_CONF_ENV = ac_cv_c_endian=little
endif

# parallel build fail, disable it
DIEHARDER_MAKE = $(MAKE1)

$(eval $(autotools-package))
