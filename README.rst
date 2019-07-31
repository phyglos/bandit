    README - General description of the BANDIT toolkit

    Copyright (C) 2015-2019 Angel Linares Zapater

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License, version 2, as
    published by the Free Software Foundation. See the COPYING file.

    This program is distributed WITHOUT ANY WARRANTY; without even the
    implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Getting started
===============

The Build AND Install Toolkit, or the BANDIT, is a software toolkit used to
build and install new software functionality into a GNU/Linux system.

This functionality can be either a new software package, a set of related
packages, some script acting on the system, or any combination of them. A
group of these items is called a BANDIT bundle. A set of bundles form a
BANDIT catalog.

The BANDIT is somehow the equivalent to the package manager on some Linux
distributions. But, in addition to that, the BANDIT can also create a complete,
new TARGET system -a new, different system than the initial HOST system where
BANDIT was installed-, and then raise the phyglos distribution on that new phy
system. In this scenario BANDIT acts as a distribution installer.

In the phy GNU/Linux operating system, BANDIT is the component responsible for
building build packs from source code, and/or installing the binaries either
from these build packs or from alien binary packages.

When BANDIT is installed in a supported Linux distribution other than phyglos,
like Debian or Fedora, it is normally used to raise a new phy system in a free
partition on any internal or external disk (or even as a container image).

How to use
==========

*In the following commands replace "latest" with the desired version.*

Download the latest released version of BANDIT from ftp://phyglos.org/bandit and,
optionally, rename the BANDIT directory when needed:

    $ wget ftp://phyglos.org/bandit/bandit-latest.tar.gz
    
    $ tar xvf bandit-latest.tar.gz
    
    $ mv bandit-latest bandit

Alternatively, clone from Github.com the repository to get the development master branch.

    $ git clone https://github.com/phyglos/bandit

As root, move the folder to /opt and change into that directory, and ensure that the
root permissions are set:

    # mv bandit /opt
    
    # cd /opt
    
    # chown -R root.root /opt/bandit

Initialize the HOST environment for BANDIT from the bandit home directory:

    # cd bandit
    
    # source bandit.env

Bandit should work now in the HOST. Test with:

    # bandit --version

or, to get help about all bandit options, issue:

    # bandit --help

More information
================

See the documentation at https://docs.phyglos.org/bandit for more information about the status, roadmap, handbook and reference.

The RELEASE file describes the main changes in this release.

The COPYING file contains the GNU License for this software.

