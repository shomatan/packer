#!/bin/bash

yum -y install git > /dev/null

echo "=> System update"
yum -y update > /dev/null
yum clean all > /dev/null

echo "=> Disable selinux"
setenforce 0
sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config

echo "=> Set for only the administrator can become a root"
sed -i 's/^.*auth.*required.*pam_wheel.so use_uid/auth\t\trequired\tpam_wheel.so use_uid/g' /etc/pam.d/su

echo "=> Repository"
echo "  => epel"
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
yum -y install epel-release > /dev/null
sed -i "s/mirrorlist=https/mirrorlist=http/"  /etc/yum.repos.d/epel.repo
sed -i "s/enabled *= *1/enabled=0/g"          /etc/yum.repos.d/epel.repo
echo "  => remi"
rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
rpm -ivh     http://rpms.famillecollet.com/enterprise/remi-release-6.rpm > /dev/null
sed -i "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/remi.repo
sed -i "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/remi-safe.repo

echo "=> Package"
echo "  => sudo..." && yum -y install sudo > /dev/null
echo "  => wget..." && yum -y install wget > /dev/null
echo "  => nmap..." && yum -y install nmap > /dev/null
echo "  => zsh...." && yum -y install zsh  > /dev/null
echo "  => htop..." && yum -y install htop --enablerepo=epel > /dev/null
echo "  => screen..." && yum -y install screen > /dev/null
echo "  => build packages..." && yum -y install libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip > /dev/null
echo

echo "=> chef-client"
curl -s -S -L https://www.opscode.com/chef/install.sh | bash
echo

echo "=> Backup"
echo "  => Create backup group..."
groupadd backup
echo "  => Create backup user..."
useradd -g backup -s /bin/false backup
echo

echo "=> Change shell"
chsh -s /bin/zsh

echo "=> dotfiles"
git clone https://github.com/shomatan/dotfiles.git /root/dotfiles
git clone https://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh
ln -Fis /root/dotfiles/.zshrc /root/.zshrc
ln -s /root/dotfiles/.screenrc /root/.screenrc

/usr/sbin/groupadd -g 501 vagrant
/usr/sbin/useradd vagrant -u 501 -g vagrant -G wheel
echo "vagrant"|passwd --stdin vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Install dotfiles
git clone https://github.com/shomatan/dotfiles.git /home/vagrant/dotfiles
git clone https://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
rm -f /home/vagrant/.zshrc
ln -Fis /home/vagrant/dotfiles/.zshrc /home/vagrant/.zshrc
ln -s /home/vagrant/dotfiles/.screenrc /home/vagrant/.screenrc
chown -R vagrant:vagrant /home/vagrant
chsh -s /bin/zsh vagrant

echo "=> Accept sudo without the only wheel group"
sed -i "s/^Defaults.*requiretty/Defaults:%wheel    !requiretty/" /etc/sudoers

echo "=> sudo secure path"
sed -i "s/^Defaults    secure_path.*/Defaults    secure_path = \/sbin:\/bin:\/usr\/sbin:\/usr\/bin:\/usr\/local\/bin/" /etc/sudoers

echo "--------------------------------------------------------------"
echo "  Installing package of building virtualbox "
echo "--------------------------------------------------------------"
yum -y install bzip2 gcc make gcc-c++ kernel-devel zlib-devel openssl-devel readline-devel sqlite-devel perl wget > /dev/null
yum -y install curl bind-utils file git mailx man ntp openssh-clients patch rsync screen sysstat dstat htop traceroute vim-enhanced > /dev/null
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
