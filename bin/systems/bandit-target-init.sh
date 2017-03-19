#!/bin/bash
#
# bandit-target-init.sh - Initialize the TARGET system
#
# Copyright (C) 2015-2017 Angel Linares Zapater
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as 
# published by the Free Software Foundation. See the COPYING file.
#
# This program is distributed WITHOUT ANY WARRANTY; without even the 
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
#

source $BANDIT_HOME/etc/bandit.conf
source $BANDIT_HOME/bin/bandit_common

###----------------------------------------
# Install BANDIT, from HOST to TARGET
###----------------------------------------

bandit_log "Installing the BANDIT in the TARGET system..." 

bandit_msg "Copying BANDIT in the TARGET filesystem..."
bandit_mkdir $BANDIT_HOST_TGT_MNT$BANDIT_HOME
cp    $BANDIT_HOME/*             $BANDIT_HOST_TGT_MNT$BANDIT_HOME 2&>/dev/null
cp -R $BANDIT_HOME/{bin,etc,lib} $BANDIT_HOST_TGT_MNT$BANDIT_HOME 

bandit_msg "Copying catalogs in the TARGET filesystem..."
bandit_mkdir $BANDIT_HOST_TGT_MNT$BANDIT_CATALOGS
cp -R $BANDIT_CATALOGS/* $BANDIT_HOST_TGT_MNT$BANDIT_CATALOGS

bandit_msg "Copying caches in the TARGET filesystem..."
bandit_mkdir $BANDIT_HOST_TGT_MNT$BANDIT_XSOURCES
cp -R $BANDIT_XSOURCES/* $BANDIT_HOST_TGT_MNT$BANDIT_XSOURCES
bandit_mkdir $BANDIT_HOST_TGT_MNT$BANDIT_XBUILDS
cp -R $BANDIT_XBUILDS/* $BANDIT_HOST_TGT_MNT$BANDIT_XBUILDS

###----------------------------------------
# Layout TARGET filesystem
###----------------------------------------

bandit_log "Preparing TARGET root filesystem..."

# Change ownership to root
chown -R root:root $BANDIT_HOST_TGT_MNT/$BANDIT_HOME
chown -R root:root $BANDIT_HOST_TGT_MNT/$BANDIT_BUILDER_DIR

## Create filesystem layout

# root
mkdir -pv $BANDIT_HOST_TGT_MNT/{bin,boot,dev,etc/{opt,sysconfig},home}
mkdir -pv $BANDIT_HOST_TGT_MNT/{media/{floppy,cdrom,usb},mnt}
mkdir -pv $BANDIT_HOST_TGT_MNT/{proc,sys,run}
mkdir -pv $BANDIT_HOST_TGT_MNT/{sbin,srv,var}
install -dv -m 0750 $BANDIT_HOST_TGT_MNT/root
install -dv -m 1777 $BANDIT_HOST_TGT_MNT/tmp $BANDIT_HOST_TGT_MNT/var/tmp

# special devices
mknod -m 600 $BANDIT_HOST_TGT_MNT/dev/console c 5 1
mknod -m 666 $BANDIT_HOST_TGT_MNT/dev/null c 1 3
if [ -h $BANDIT_HOST_TGT_MNT/dev/shm ]; then
  mkdir -pv $BANDIT_HOST_TGT_MNT/$(readlink $BANDIT_HOST_TGT_MNT/dev/shm)
fi

# libs
case $BANDIT_TARGET_ARCH in
    x86) 
	ln -sv lib32 $BANDIT_HOST_TGT_MNT/lib
        ln -sv lib32 $BANDIT_HOST_TGT_MNT/usr/lib
        ln -sv lib32 $BANDIT_HOST_TGT_MNT/usr/local/lib
	;;
    x86_64) 
	mkdir -pv $BANDIT_HOST_TGT_MNT/lib32
	mkdir -pv $BANDIT_HOST_TGT_MNT/usr/{,local}/lib32
	mkdir -pv $BANDIT_HOST_TGT_MNT/lib64
	mkdir -pv $BANDIT_HOST_TGT_MNT/usr/{,local}/lib64
	ln -sv lib64 $BANDIT_HOST_TGT_MNT/lib
        ln -sv lib64 $BANDIT_HOST_TGT_MNT/usr/lib
        ln -sv lib64 $BANDIT_HOST_TGT_MNT/usr/local/lib
	;;
esac

# usr
mkdir -pv $BANDIT_HOST_TGT_MNT/usr/{,local/}{bin,include,sbin,src}
mkdir -pv $BANDIT_HOST_TGT_MNT/usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v  $BANDIT_HOST_TGT_MNT/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v  $BANDIT_HOST_TGT_MNT/usr/libexec
mkdir -pv $BANDIT_HOST_TGT_MNT/usr/{,local/}share/man/man{1..8}

# var
mkdir -v $BANDIT_HOST_TGT_MNT/var/{log,mail,spool}
ln -sv /run $BANDIT_HOST_TGT_MNT/var/run
ln -sv /run/lock $BANDIT_HOST_TGT_MNT/var/lock
mkdir -pv $BANDIT_HOST_TGT_MNT/var/{opt,cache,lib/{color,misc,locate},local}


bandit_log "Create essential files and symlinks..."

# bin
ln -sv $BANDIT_BUILDER_DIR/bin/{bash,cat,echo,pwd,stty} $BANDIT_HOST_TGT_MNT/bin
ln -sv $BANDIT_BUILDER_DIR/bin/file $BANDIT_HOST_TGT_MNT/usr/bin
ln -sv $BANDIT_BUILDER_DIR/bin/perl $BANDIT_HOST_TGT_MNT/usr/bin
ln -sv bash $BANDIT_HOST_TGT_MNT/bin/sh

# etc
ln -sv /proc/self/mounts $BANDIT_HOST_TGT_MNT/etc/mtab

cat > $BANDIT_HOST_TGT_MNT/etc/passwd <<EOF
root:x:0:0:root:/root:/bin/bash
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

cat > $BANDIT_HOST_TGT_MNT/etc/group <<EOF
root:x:0:
nogroup:x:99:
EOF

# libs
ln -sv $BANDIT_BUILDER_DIR/lib/libgcc_s.so{,.1} $BANDIT_HOST_TGT_MNT/usr/lib
ln -sv $BANDIT_BUILDER_DIR/lib/libstdc++.so{,.6} $BANDIT_HOST_TGT_MNT/usr/lib
sed "s#$BANDIT_BUILDER_DIR#usr#" $BANDIT_BUILDER_DIR/lib/libstdc++.la > $BANDIT_HOST_TGT_MNT/usr/lib/libstdc++.la

# var/logs
touch $BANDIT_HOST_TGT_MNT/var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v 13 $BANDIT_HOST_TGT_MNT/var/log/lastlog
chmod -v 664  $BANDIT_HOST_TGT_MNT/var/log/lastlog
chmod -v 600  $BANDIT_HOST_TGT_MNT/var/log/btmp


###----------------------------------------
# Create custom command to enter the BUILDER system
###----------------------------------------

bandit_log "Creating a custom command to enter BUILDER..."

cat > $BANDIT_HOME/bin/bandit-builder-enter <<EOF
mounted="\$(grep $BANDIT_HOST_TGT_MNT /etc/mtab)"
if [ -z "\$mounted" ]; then
    mount -v $BANDIT_TARGET_PART $BANDIT_HOST_TGT_MNT
fi

mount --bind /dev      $BANDIT_HOST_TGT_MNT/dev
mount -t devpts devpts $BANDIT_HOST_TGT_MNT/dev/pts -o gid=5,mode=620
mount -t proc  proc    $BANDIT_HOST_TGT_MNT/proc
mount -t sysfs sysfs   $BANDIT_HOST_TGT_MNT/sys
mount -t tmpfs tmpfs   $BANDIT_HOST_TGT_MNT/run

chroot $BANDIT_HOST_TGT_MNT $BANDIT_BUILDER_DIR/bin/env -i \
HOME=/root \
TERM=$TERM \
PS1='\\u@\\h:[BUILDER]:\\w\\$ ' \
BANDIT_HOME=$BANDIT_HOME \
PATH=/bin:/usr/bin:/sbin:/usr/sbin:$BANDIT_BUILDER_DIR/bin:$BANDIT_HOME/bin \
$BANDIT_BUILDER_DIR/bin/bash --login +h

umount $BANDIT_HOST_TGT_MNT/run
umount $BANDIT_HOST_TGT_MNT/sys
umount $BANDIT_HOST_TGT_MNT/proc
umount $BANDIT_HOST_TGT_MNT/dev/pts 
umount $BANDIT_HOST_TGT_MNT/dev

if [ -z "\$mounted" ]; then
    umount -v $BANDIT_HOST_TGT_MNT
fi
EOF
chmod +x $BANDIT_HOME/bin/bandit-builder-enter

echo
bandit_msg "To enter the BUILDER system, use the command..." green
echo
bandit_msg "bandit-builder-enter" green


###----------------------------------------
# Create custom command to enter the TARGET system
###----------------------------------------

bandit_log "Creating a custom command to enter TARGET..."

cat > $BANDIT_HOME/bin/bandit-target-enter <<EOF
mounted="\$(grep $BANDIT_HOST_TGT_MNT /etc/mtab)"
if [ -z "\$mounted" ]; then
    mount -v $BANDIT_TARGET_PART $BANDIT_HOST_TGT_MNT
fi

mount --bind /dev      $BANDIT_HOST_TGT_MNT/dev
mount -t devpts devpts $BANDIT_HOST_TGT_MNT/dev/pts -o gid=5,mode=620
mount -t proc  proc    $BANDIT_HOST_TGT_MNT/proc
mount -t sysfs sysfs   $BANDIT_HOST_TGT_MNT/sys
mount -t tmpfs tmpfs   $BANDIT_HOST_TGT_MNT/run

chroot $BANDIT_HOST_TGT_MNT /usr/bin/env -i \
HOME=/root \
TERM=$TERM \
PS1='\\u@\\h:[TARGET]:\\w\\$ ' \
BANDIT_HOME=$BANDIT_HOME \
PATH=/bin:/usr/bin:/sbin:/usr/sbin:$BANDIT_HOME/bin \
/bin/bash --login +h

umount $BANDIT_HOST_TGT_MNT/run
umount $BANDIT_HOST_TGT_MNT/sys
umount $BANDIT_HOST_TGT_MNT/proc
umount $BANDIT_HOST_TGT_MNT/dev/pts 
umount $BANDIT_HOST_TGT_MNT/dev

if [ -z "\$mounted" ]; then
    umount -v $BANDIT_HOST_TGT_MNT
fi
EOF
chmod +x $BANDIT_HOME/bin/bandit-target-enter

echo
bandit_msg "To enter the new TARGET system, once built, use the command..." green
echo
bandit_msg "bandit-target-enter" green

