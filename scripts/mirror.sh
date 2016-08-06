#!/bin/bash

echo "-------------------------------------------------------------------------"
echo "  mirror.sh"
echo "-------------------------------------------------------------------------"

LF=$(printf '\\\012_')
LF=${LF%_}

mirror_ip="192.168.33.2"
echo "=> mirror IP: ${mirror_ip}"
echo "=> Replace /etc/yum.repos.d/CentOS-Base.repo"
rm -f /etc/yum.repos.d/CentOS-Base.repo
cat << EOT > /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-\$releasever - Base
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=os&infra=\$infra
baseurl=http://${mirror_ip}/centos/\$releasever/os/\$basearch/
        http://ftp.riken.jp/Linux/centos/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#released updates
[updates]
name=CentOS-\$releasever - Updates
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=updates&infra=\$infra
baseurl=http://${mirror_ip}/centos/\$releasever/updates/\$basearch/
        http://ftp.riken.jp/Linux/centos/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-\$releasever - Extras
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=extras&infra=\$infra
baseurl=http://${mirror_ip}/centos/\$releasever/extras/\$basearch/
        http://ftp.riken.jp/Linux/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-\$releasever - Plus
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=centosplus&infra=\$infra
baseurl=http://${mirror_ip}/centos/\$releasever/centosplus/\$basearch/
        http://ftp.riken.jp/Linux/centos/\$releasever/centosplus/\$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOT

echo "=> sed /etc/yum.repos.d/epel.repo"
sed -i 's/^mirrorlist=http:/#mirrorlist=http:/g' /etc/yum.repos.d/epel.repo
sed -i 's/^#baseurl=.*/baseurl=http:\/\/'$mirror_ip'\/epel\/\$releasever\/\$basearch\/ '"$LF"'        http:\/\/ftp.jaist.ac.jp\/pub\/Linux\/Fedora\/epel\/\$releasever\/\$basearch\//g' /etc/yum.repos.d/epel.repo

# -----------------------------------------------------------------------------
echo "=> Replace /etc/yum.repos.d/remi.repo"
cat << EOT > /etc/yum.repos.d/remi.repo
[remi]
name=Remi's RPM repository for Enterprise Linux 7 - \$basearch
baseurl=http://${mirror_ip}/remi/7/remi/\$basearch/
        http://rpms.remirepo.net/enterprise/7/remi/\$basearch/
#mirrorlist=http://rpms.remirepo.net/enterprise/7/remi/mirror
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

[remi-php55]
name=Remi's PHP 5.5 RPM repository for Enterprise Linux 7 - \$basearch
baseurl=http://${mirror_ip}/remi/7/php55/\$basearch/
        http://rpms.remirepo.net/enterprise/7/php55/\$basearch/
#mirrorlist=http://rpms.remirepo.net/enterprise/7/php55/mirror
# NOTICE: common dependencies are in "remi-safe"
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

[remi-php56]
name=Remi's PHP 5.6 RPM repository for Enterprise Linux 7 - \$basearch
baseurl=http://${mirror_ip}/remi/7/php56/\$basearch/
        http://rpms.remirepo.net/enterprise/7/php56/\$basearch/
#mirrorlist=http://rpms.remirepo.net/enterprise/7/php56/mirror
# NOTICE: common dependencies are in "remi-safe"
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
EOT

# -----------------------------------------------------------------------------
echo "=> Replace /etc/yum.repos.d/remi-php70.repo"
cat << EOT > /etc/yum.repos.d/remi-php70.repo
[remi-php70]
name=Remi's PHP 7.0 RPM repository for Enterprise Linux 7 - \$basearch
baseurl=http://${mirror_ip}/remi/7/php70/\$basearch/
        http://rpms.remirepo.net/enterprise/7/php70/\$basearch/
#mirrorlist=http://rpms.remirepo.net/enterprise/7/php70/mirror
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
EOT

# -----------------------------------------------------------------------------
echo "=> Replace /etc/yum.repos.d/rpmforge.repo"
cat << EOT > /etc/yum.repos.d/rpmforge.repo
[rpmforge]
name = RHEL \$releasever - RPMforge.net - dag
baseurl=http://${mirror_ip}/rpmforge/el7/en/\$basearch/rpmforge
        http://apt.sw.be/redhat/el7/en/\$basearch/rpmforge
mirrorlist = http://mirrorlist.repoforge.org/el7/mirrors-rpmforge
#mirrorlist = file:///etc/yum.repos.d/mirrors-rpmforge
enabled=0
protect = 0
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag
gpgcheck = 1

[rpmforge-extras]
name = RHEL \$releasever - RPMforge.net - extras
baseurl=http://${mirror_ip}/rpmforge/el7/en/\$basearch/extras
        http://apt.sw.be/redhat/el7/en/\$basearch/extras
mirrorlist = http://mirrorlist.repoforge.org/el7/mirrors-rpmforge-extras
#mirrorlist = file:///etc/yum.repos.d/mirrors-rpmforge-extras
enabled = 0
protect = 0
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag
gpgcheck = 1
EOT

echo "mirror.sh finished"
echo
