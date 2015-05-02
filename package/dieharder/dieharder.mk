################################################################################
#
# dieharder
#
################################################################################

DIEHARDER_VERSION = 3.31.1
DIEHARDER_SITE = http://www.phy.duke.edu/~rgb/General/dieharder/
DIEHARDER_SOURCE = dieharder-$(DIEHARDER_VERSION).tgz
DIEHARDER_LICENSE = GPLv2
DIEHARDER_LICENSE_FILES = GPL
DIEHARDER_DEPENDENCIES = gsl
DIEHARDER_SUBDIR = dieharder-$(DIEHARDER_VERSION)
DIEHARDER_AUTORECONF = YES

# fix endiannes detection
ifeq ($(BR2_ENDIAN),"BIG")
BR2_AC_CV_C_ENDIAN = ac_cv_c_endian=bin
else
BR2_AC_CV_C_ENDIAN = ac_cv_c_endian=little
endif
DIEHARDER_CONF_OPTS = $(BR2_AC_CV_C_ENDIAN)

# parallel build fail, disable it
DIEHARDER_MAKE=$(MAKE1)

$(eval $(autotools-package))
