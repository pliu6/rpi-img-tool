# rpi-img-tool

How to use mkimage.sh?
1. After build buildroot for Raspberry Pi, copy mkimage.sh to the image folder
2. Run the script with root to generate buildroot_rpi_xxx.img
3. Use dd command to create new SD card
#dd if=buildroot_rpi_xxx.img of=/dev/sdX bs=4M

How to use mkcard.sh?
1. Just run the script to partition the SD card and format the partitions.

The SD card will have 2 partitions mount to /boot and /root
