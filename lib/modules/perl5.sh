#!/bin/bash
#
# perl5 - BANDIT plugin for perl5 module 
#
# Copyright (C) 2016 Àngel Linares Zapater
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
    cpan -i ${*}
}

