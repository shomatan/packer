# packer-centos
Packer templates to build the vagrant box for CentOS.

## Requirements
+ [Packer](https://www.packer.io/)
+ [VirtualBox](https://www.virtualbox.org/)

## Usage

#### CentOS 6.2
```
packer build centos-6.2.json
vagrant box add centos-6.2 builds/virtualbox-centos-6.2.box --force
```
