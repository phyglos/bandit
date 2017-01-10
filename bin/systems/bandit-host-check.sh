#!/bin/bash
#
# bandit-host-check.sh - Check for HOST build requirements
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

source $BANDIT_HOME/bin/bandit_common

###----------------------------------------
# Check whether the HOST meets the building requirements
###----------------------------------------

bandit_log "Checking HOST building requirements..." 

export LC_ALL=C

echo
echo "CHECK: bash >= 3.2"
bash --version | head -n1 | cut -d" " -f2-4
echo
echo "CHECK: sh is a link to bash"
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH

echo
echo "CHECK: binutils >= 2.17"
echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-

echo
echo "CHECK: bison >= 2.3"
bison --version | head -n1
echo
echo "CHECK: yacc is a link to bison or an executable file"
if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found" 
fi

echo
echo "CHECK: bzip2 >= 1.0.4"
bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-

echo
echo "CHECK: coreutils >= 6.9"
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2

echo
echo "CHECK: diff >= 2.8.1"
diff --version | head -n1

echo
echo "CHECK: findutils >= 4.2.31"
find --version | head -n1

echo
echo "CHECK: gawk >= 4.0.1"
gawk --version | head -n1
echo
echo "CHECK: awk is a link to gawk"
if [ -h /usr/bin/awk ]; then
  echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo awk is `/usr/bin/awk --version | head -n1`
else 
  echo "awk not found" 
fi

echo
echo "CHECK: gcc >= 4.7"
gcc --version | head -n1
g++ --version | head -n1

echo
echo "CHECK: glibc >= 2.11"
ldd --version | head -n1 | cut -d" " -f2-  # glibc version

echo
echo "CHECK: grep >= 2.5.1a"
grep --version | head -n1

echo
echo "CHECK: gzip >= 1.3.12"
gzip --version | head -n1

echo
echo "CHECK: linux >= 2.6.32"
cat /proc/version

echo
echo "CHECK: m4 >= 1.4.10"
m4 --version | head -n1

echo
echo "CHECK: make >= 3.81"
make --version | head -n1

echo
echo "CHECK: patch >= 2.5.4"
patch --version | head -n1

echo
echo "CHECK: perl >= 5.8.8"
echo Perl `perl -V:version`

echo
echo "CHECK: sed >= 4.1.5"
sed --version | head -n1

echo
echo "CHECK: tar >= 1.22"
tar --version | head -n1

echo
echo "CHECK: texinfo >= 4.7"
makeinfo --version | head -n1

echo
echo "CHECK: xz >= 5.0.0"
xz --version | head -n1

echo
echo "CHECK: gmp, mpfr and mpc are all found or all not found"
for lib in lib{gmp,mpfr,mpc}.la; do
  echo $lib: $(if find /usr/lib* -name $lib |
               grep -q $lib;then :;else echo not;fi) found
done
unset lib

bandit_log "Checking HOST compilation capabilities..." 

echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]; then 
    echo "g++ compilation OK"
else
    echo "g++ compilation failed"
fi
rm -f dummy.c dummy

