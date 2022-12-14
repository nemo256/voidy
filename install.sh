#!/usr/bin/env bash

# Set a bold custom terminus font
xbps-install -Syu terminus-font gptfdisk parted
# setfont ter-v32b

################################################
#                                              #
# Create a .env file containing these options: #
#                                              #
################################################
#
# USERNAME=<New user name>
# PASSWORD=<New user password>
# HOSTNAME=<Hostname eg: macbook>
# SHELL=<eg: /bin/bash>
# TOKEN=<Your Github token (PAT)>
# DISK=<eg: /dev/sda>
# MOUNT_OPTIONS=<eg for ssd add: "noatime,ssd,...">
# FS=<Filesystem eg: ext4, btrfs...>
# TIMEZONE=<eg: Europe/Paris>
# KEYMAP=<eg: us,uk,es...>
# REPO=<https://repo-default.voidlinux.org/current>
# ARCH=<x86_64, i686, arm...>

source .env

# Logo
clear
echo -ne "
------------------------------------------------------------------------------------------
                       /$$    /$$         /$$       /$$          
                      | $$   | $$        |__/      | $$          
                      | $$   | $$/$$$$$$  /$$  /$$$$$$$ /$$   /$$                        
                      |  $$ / $$/$$__  $$| $$ /$$__  $$| $$  | $$
                       \  $$ $$/ $$  \ $$| $$| $$  | $$| $$  | $$
                        \  $$$/| $$  | $$| $$| $$  | $$| $$  | $$
                         \  $/ |  $$$$$$/| $$|  $$$$$$$|  $$$$$$$
                          \_/   \______/ |__/ \_______/ \____  $$
                                                        /$$  | $$
                                                       |  $$$$$$/
                                                        \______/
------------------------------------------------------------------------------------------
                               Automated Voidy Installer
------------------------------------------------------------------------------------------
"

echo -ne "
                               Press any key to continue...
"
read

echo -ne "
------------------------------------------------------------------------------------------
                                   Formating Disks
------------------------------------------------------------------------------------------
"
umount -A --recursive /mnt # make sure everything is unmounted before we start
# Disk prep
sgdisk -Z ${DISK} # zap all on disk
sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

# Create partitions
sgdisk -n 1::+128M --typecode=1:af00 --change-name=1:'Boot Loader' ${DISK} # partition 1 (Boot loader Partition)
sgdisk -n 2::+256M --typecode=2:8300 --change-name=2:'Boot' ${DISK} # partition 2 (Boot Partition)
sgdisk -n 3::-0 --typecode=3:8300 --change-name=3:'Root' ${DISK} # partition 3 (Root), default start, remaining space

if [[ ! -d "/sys/firmware/efi" ]]; then
    sgdisk -A 1:set:2 ${DISK}
fi
partprobe ${DISK}

# Make filesystems
echo -ne "
------------------------------------------------------------------------------------------
                                  Creating Filesystems
------------------------------------------------------------------------------------------
"
partition2=${DISK}2
partition3=${DISK}3

mkfs.vfat ${partition2}
mkfs.ext4 -L Root ${partition3}
mount -t ext4 ${partition3} /mnt

# Mount target
mkdir /mnt/boot
mount ${partition2} /mnt/boot/

if ! grep -qs '/mnt' /proc/mounts; then
    echo "Drive is not mounted, can not continue"
    echo "Rebooting in 3 Seconds ..." && sleep 1
    echo "Rebooting in 2 Seconds ..." && sleep 1
    echo "Rebooting in 1 Second ..." && sleep 1
    reboot now
fi

echo -ne "
------------------------------------------------------------------------------------------
                                   Voidy Installation 
------------------------------------------------------------------------------------------
"
# Copy the RSA keys from the installation medium to the target root directory
mkdir -p /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

# Start the installation
XBPS_ARCH=$ARCH xbps-install -Sy -r /mnt -R "$REPO" base-system

echo -ne "
------------------------------------------------------------------------------------------
                                   Generating FsTab
------------------------------------------------------------------------------------------
"
cp /proc/mounts /mnt/etc/fstab
echo " 
  Generated /etc/fstab:
"
cat /mnt/etc/fstab

echo -ne "
------------------------------------------------------------------------------------------
                          GRUB BIOS Bootloader Install And Check
------------------------------------------------------------------------------------------
"
if [[ ${DISK} != /dev/vda ]]; then
  if [[ ! -d "/sys/firmware/efi" ]]; then
      grub-install --boot-directory=/mnt/boot ${DISK}
      echo "Installed bootloader for BIOS!"
  else
      echo "Skipping (UEFI)!"
  fi
fi
echo -ne "
------------------------------------------------------------------------------------------
                                 Adding Swap Memory (8GB)
------------------------------------------------------------------------------------------
"
# mkdir -p /mnt/opt/swap
# chattr +C /mnt/opt/swap
# dd if=/dev/zero of=/mnt/opt/swap/swapfile bs=1M count=4096 status=progress
# chmod 600 /mnt/opt/swap/swapfile
# chown root /mnt/opt/swap/swapfile
# mkswap /mnt/opt/swap/swapfile
# swapon /mnt/opt/swap/swapfile
# echo "/opt/swap/swapfile	none	swap	sw	0	0" >> /mnt/etc/fstab

echo -ne "
------------------------------------------------------------------------------------------
                            chrooting Into The New Installation
------------------------------------------------------------------------------------------
"
# Mount the pseudo-filesystems needed for a chroot
mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc

# Copy all configuration files
echo "Copying configuration files..."
cp /etc/resolv.conf /mnt/etc/
cp -fr /root/voidy/postinstall.sh /root/voidy/.env /mnt/root && echo "Copied successfully"

# Redirect to the postinstall script
( chroot /mnt /root/postinstall.sh ) |& tee postinstall.log
cp postinstall.log /mnt/root
