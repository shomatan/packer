#!/bin/bash

yum -y install git
curl -sS https://raw.githubusercontent.com/shomatan/init-scripts/master/init.sh | bash
curl -sS https://raw.githubusercontent.com/shomatan/init-scripts/master/neovim.sh | bash
curl -sS https://raw.githubusercontent.com/shomatan/dotfiles/master/tools/install.sh | bash

/usr/sbin/groupadd -g 501 vagrant
/usr/sbin/useradd vagrant -u 501 -g vagrant -G wheel
echo "vagrant"|passwd --stdin vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Install dotfiles
su - vagrant -c "curl -sS https://raw.githubusercontent.com/shomatan/dotfiles/master/tools/install.sh | bash"
chsh -s /bin/zsh vagrant

echo "--------------------------------------------------------------"
echo "  Installing package of building virtualbox "
echo "--------------------------------------------------------------"
yum -y install bzip2 gcc make gcc-c++ kernel-devel zlib-devel openssl-devel readline-devel sqlite-devel perl wget
yum -y install curl bind-utils file git mailx man ntp openssh-clients patch rsync screen sysstat dstat htop traceroute vim-enhanced
echo

echo "--------------------------------------------------------------"
echo "  Creating vagrant environment "
echo "--------------------------------------------------------------"
date > /etc/vagrant_box_build_time
# Installing vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
echo

echo "--------------------------------------------------------------"
echo "  Installing the virtualbox guest additions "
echo "--------------------------------------------------------------"
VBOX_VERSION=$(cat /root/.vbox_version)
cd /tmp
mount -o loop /root/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -rf /home/vagrant/VBoxGuestAdditions_*.iso
echo

echo "----------------------------------------------"
echo "  Finished init scripts"
echo "----------------------------------------------"
