#!/bin/bash
#
# bandit-host-clean.sh - Clean the HOST system from previous installations
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
# Remove previous users ans partitions from HOST
###----------------------------------------

bandit_log "Removing BANDIT user from HOST..."

userdel $BANDIT_USR
rm -vrf /home/$BANDIT_USR
rm -vrf /var/mail/$BANDIT_USR

bandit_log "Removing TARGET partitions from HOST system..."

# Switch off swap partition
swapoff -v $BANDIT_TARGET_SWAP

# Umount the target directory
umount -vfl $BANDIT_HOST_TGT_MNT            
rm -rf $BANDIT_HOST_TGT_MNT            

# Remove crosstools host link
rm -rf $BANDIT_BUILDER_DIR

# Remove bespoken commands
rm $BANDIT_HOME/bin/bandit-builder-enter
rm $BANDIT_HOME/bin/bandit-target-enter

# Done
echo
bandit_msg "The HOST system is clean" green
echo

