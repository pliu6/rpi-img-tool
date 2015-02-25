#!/bin/sh

bootsize="64M"

rootfs="tmp/root"
bootfs="tmp/boot"

today=`date +%Y%m%d`
image="buildroot_rpi_${today}.img"

# Suppose you are using 4GB SD card
dd if=/dev/zero of=${image} bs=4MB count=1024

device=`losetup -f --show ${image}`
echo "image ${image} created and mounted as ${device}"

fdisk ${device} << EOF
n
p
1

+${bootsize}
t
c
n
p
2


w
EOF

losetup -d ${device}
device=`kpartx -va ${image} | sed -E 's/.*(loop[0-9])p.*/\1/g' | head -1`
device="/dev/mapper/${device}"
bootp=${device}p1
rootp=${device}p2

mkfs.vfat -F 32 -n "boot" ${bootp}
mkfs.ext4 -L "root" ${rootp}

mkdir -p ${rootfs}
mkdir -p ${bootfs}

mount ${rootp} ${rootfs}
mount ${bootp} ${bootfs}

cp rpi-firmware/* ${bootfs}
cp zImage ${bootfs}
tar xvf rootfs.tar -C ${rootfs}

cd ${rootfs}
sync
cd ../..

cd ${bootfs}
sync
cd ../../

umount -l ${bootp}
umount -l ${rootp}

dmsetup remove_all

echo "finishing ${image}"

kpartx -d ${image}
echo "created image ${image}"

rm -rf tmp

echo "done."
