#!/bin/bash
set -i

echo On console type:
date +"date \"%Y-%_0m-%_0d %_0k:%_0M\""

cat <<EOF
then type
./devel.sh

EOF

cat <<EOF
update your ~/.sshg/config with the following
Host pi-dev
HostName pi # replace pi here with the ip obtained on dhcp if needed
User root
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

EOF

echo or type: make deploy-ssh

echo Then press enter here
read

scp -r output/images/rpi-firmware/* pi-dev:/boot/
scp output/images/zImage pi-dev:/boot/
scp output/images/rootfs.cpio.gz pi-dev:/boot/

echo "Update done! Reboot the pi"

