#!/bin/bash

yum -y install acpid
systemctl enable acpid
systemctl start acpid

# cloud-init を使用した公開鍵の取得
yum -y install cloud-init cloud-utils cloud-utils-growpart dracut-modules-growroot
yum clean all

# BOOTPROTO="dhcp" 全てのNICでDHCPでアドレスを取得する(0~3の最大4つ)
# PEERDNS="no" OpenstackのDHCPサーバーからのDNS情報をOSに自動設定しない
for i in 0 1 2 3
do
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth$i
DEVICE="eth$i"
BOOTPROTO="dhcp"
IPV6INIT="no"
MTU="1500"
NM_CONTROLLED="no"
ONBOOT="yes"
TYPE="Ethernet"
PEERDNS="no"
EOF
done

# NOZEROCONF=yes 余計なルーティングをしない
cat << EOF > /etc/sysconfig/network
NETWORKING=yes
NOZEROCONF=yes
EOF

# 明示的にDNSサーバーを指定する
systemctl stop NetworkManager
systemctl disable NetworkManager
cat << EOF > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# userでのログインを許可
sed -i -e 's/^    name: centos$/    name: user/' /etc/cloud/cloud.cfg

# rootパスワード無効
usermod -L root
