#!/bin/bash
#
#	install script for smp -- simple muisc player
#

mkdir /opt/smp
cp smp.sh /opt/smp/smp.sh
cp README.md /opt/smp/README
ln /opt/smp/smp.sh /usr/bin/smp
