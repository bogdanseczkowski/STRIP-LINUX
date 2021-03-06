#!/bin/bash
emerge-webrsync
eselect profile set "default/linux/amd64/17.0/hardened"
emerge cpuid2cpuflags
np=$(nproc)
enp=`expr $np + 1`
flag=$(gcc -c -Q -march=native --help=target |grep "\-march="|awk '$1=$1'| sed "s/ //g")
echo '
COMMON_FLAGS="-O3 -pipe '$flag\" >> /etc/portage/make.conf
echo '
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
CHOST="x86_64-pc-linux-gnu"
EMERGE_DEFAULT_OPTS="--keep-going=y --autounmask-write=y"
MAKEOPTS="-j'$enp\" >> /etc/portage/make.conf
CPU=$(cpuid2cpuflags)
out="${CPU//': '/=\"}"
echo "$out" \" >> /etc/portage/make.conf
echo '=sys-devel/gcc-8.2.0-r3 ~amd64' >> /etc/portage/package.keywords
emerge  world
emerge git-sources genkernel curl app-arch/lz4 sys-boot/grub:2 app-portage/gentoolkit dhcpcd
echo -e "y\n" | etc-update --automode -3
echo -e "y\n" | etc-update --automode -3
emerge app-portage/gentoolkit
gcc-config 2 
source /etc/profile
revdep-rebuild
emerge git-sources genkernel curl 
emerge app-arch/lz4
wget https://raw.githubusercontent.com/bogdanseczkowski/STRIP-LINUX/master/config/4.18/config.amd64
cd /usr/src/linux
wget https://raw.githubusercontent.com/bogdanseczkowski/OPTINUX/master/config/patch/grasky2kernel.patch
patch -Np1 -i ./grasky2kernel.patch
cd /
genkernel --menuconfig --kernel-config=config.amd64 all
rm ./config.amd64

emerge  --newuse --deep sys-boot/grub:2
emerge dhcpcd 

read -erp "Enter drive for GRUB2 installation: " -i "/dev/sda" drive
grub-install --target=i386-pc $drive
grub-mkconfig -o /boot/grub/grub.cfg

rc-update add dhcpcd default
rc-update add sshd default

echo "root:toor" | chpasswd

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale set en_US.utf8

emerge --depclean
eclean-dist --deep

exit
