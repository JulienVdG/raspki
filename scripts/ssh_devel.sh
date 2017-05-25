#!/bin/sh

# copy our pubkey
mkdir -p $1/root/.ssh/
chmod 0700 $1/root/.ssh/
chmod 0700 $1/root
cp -p ~/.ssh/id_rsa.pub $1/root/.ssh/authorized_keys
chmod 0600 $1/root/.ssh/authorized_keys

# disable ssh autostart
if [ -e $1/etc/init.d/S50sshd ]; then
  mv $1/etc/init.d/S50sshd $1/root
fi

# install devel helper script
install -D -m 755 $BR2_EXTERNAL_BUILDROOT_SUBMODULE_PATH/devel/devel.sh $1/root
