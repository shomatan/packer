# packer-centos
Packer templates to build the vagrant box for CentOS.

## Requirements
+ [Packer](https://www.packer.io/)
+ [VirtualBox](https://www.virtualbox.org/)

## Usage
#### CentOS 7.3.1611
```
packer build latest.json
vagrant box add centos-7.3 builds/virtualbox-centos-7.3.1611.box --force
```

#### CentOS 6.2
```
packer build centos-6.2.json
vagrant box add centos-6.2 builds/virtualbox-centos-6.2.box
```
