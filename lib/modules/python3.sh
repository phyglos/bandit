#!/bin/bash
#
# python3 - BANDIT plugin for python3 modules
#
# Copyright (C) 2017-2019 Angel Linares Zapater
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as 
# published by the Free Software Foundation. See the COPYING file.
#
# This program is distributed WITHOUT ANY WARRANTY; without even the 
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
#

module_install()
{
    pip3 install -U ${*}
}

module_remove()
{
    pip3 uninstall -y ${*}
}

