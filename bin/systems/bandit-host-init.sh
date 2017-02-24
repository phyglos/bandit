#!/bin/bash
#
# bandit-host-init.sh - Initialize the HOST system to use BANDIT
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
# Set up a new user 'bandit'
###----------------------------------------

bandit_log "Setting up BANDIT user in HOST ..." 

groupadd $BANDIT_GRP
useradd -g $BANDIT_GRP -s /bin/bash -m -k /dev/null $BANDIT_USR

echo "$BANDIT_USR:$BANDIT_PSW" | chpasswd

# Prepare user environment
cat > /home/$BANDIT_USR/.bash_profile <<EOF
exec env -i HOME=/home/$BANDIT_USR TERM=$TERM PS1='\u@\h:\w\$ ' /bin/bash
EOF

cat > /home/$BANDIT_USR/.bashrc <<EOF
set +h
umask 022
LC_ALL=POSIX

BANDIT_HOME=$BANDIT_HOME
PATH=$BANDIT_BUILDER_DIR/bin:/bin:/usr/bin:$BANDIT_HOME/bin

export LC_ALL PATH BANDIT_HOME
EOF

# Take ownership of user and BANDIT directory
chown -R $BANDIT_USR:$BANDIT_GRP $BANDIT_HOME
chown -vR $BANDIT_USR:$BANDIT_GRP /home/$BANDIT_USR


###----------------------------------------
# Prepare partitions and directories in HOST
###----------------------------------------

bandit_log "Preparing TARGET partition..." 

## Format target root partition
lsblk -ip
bandit_msg "Enter 'init' to erase $BANDIT_TARGET_PART :" red 
read CMD
[ "$CMD" == "init" ] || bandit_exit "Cancelled"

mkdir -pv $BANDIT_HOST_TGT_MNT
mkfs -v -t $BANDIT_TARGET_PART_TYPE -L ${BANDIT_TARGET_PART_LABEL} $BANDIT_TARGET_PART

mount -v -t $BANDIT_TARGET_PART_TYPE $BANDIT_TARGET_PART $BANDIT_HOST_TGT_MNT

bandit_log "Preparing TARGET swap area..." 

## Format target swap partition
lsblk -ip
bandit_msg "Enter 'init' to erase $BANDIT_TARGET_SWAP :" red 
read CMD
[ "$CMD" == "init" ] || bandit_exit "Cancelled "

mkswap -L ${BANDIT_TARGET_SWAP_LABEL} $BANDIT_TARGET_SWAP
echo
/sbin/swapon -v $BANDIT_TARGET_SWAP


bandit_log "Preparing the BUILDER system..." 

## Add BUILDER directory into TARGET filesystem and link to the HOST filesystem
mkdir -pv $BANDIT_HOST_TGT_MNT$BANDIT_BUILDER_DIR
chown -R $BANDIT_USR:$BANDIT_GRP $BANDIT_HOST_TGT_MNT$BANDIT_BUILDER_DIR

ln -sv $BANDIT_HOST_TGT_MNT$BANDIT_BUILDER_DIR $BANDIT_BUILDER_DIR


# Done
bandit_log "The HOST system is ready..."
echo
bandit_msg "You can log as the user $BANDIT_USR to continue: " green
echo
bandit_msg "#su - $BANDIT_USR" green
echo
