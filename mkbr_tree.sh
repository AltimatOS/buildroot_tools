#!/bin/bash

# Author: Gary L. Greene, Jr. <greeneg@tolharadys.net>
#
# This script creates a brand new build root on a Linux host for AltimatOS.
# Once AltimatOS is self-hosting, it will be modified to work exclusively
# from that platform.
#
# License: Apache Public License, v2
#
# PRE-RUN STEPS:
#
# This script assumes that the Linux host that is being used as a build
# machine has already had a volume, assumed to be /dev/sdb1 created and
# formatted as XFS. This script will take it from there. Note, this script
# requires root rights, and should not be run under sudo, as it needs more
# than EUID root rights.

if [[ $(id -ru --name) != "root" ]]; then
    echo "This script requires real root rights"
    exit -1
fi

export LESS='-MPM .Line %lt of %lb: %Pb: .?e(END) Press Q to continue'
(
cat <<EOF
This script will modify the installation of your Linux host to mirror more
closely to how AltimatOS's directory structure is laid out, and will auto
install a number of software tools to ensure that the system can be used
as a build host for AltimatOS.

These changes include:
  * /dev/sdb1 will be formatted as XFS
  * /dev/sdb1 will be mounted at /AltimatOS
  * The initial directory tree for AltimatOS will be created inside the
    /AltimatOS mount point:
    /AltimatOS
    |-> Applications
    |---> Common/{bin,lib,lib64,share/{docs,info,man}}
    |-> dev
    |-> proc
    |-> sys
    |-> System
    |---> bin
    |---> boot
    |---> cfg
    |---> lib
    |---> lib64
    |---> local
    |-----> bin
    |-----> cfg
    |-----> lib
    |-----> lib64
    |-----> share/{docs,info,man}
    |---> sbin
    |---> share/{docs,info,man}
    |---> tmp
    |---> var/{cache,adm,lib,log,spool,tmp}
    |-> Users/{Administrator,LocalServices,NetworkServices}
    |-> Volumes
  * Correct permissions will be set on System/tmp (1777)
  * Symbolic links will be generaged for backwards compatibility:
    /AltimatOS/bin        -> /AltimatOS/System/bin
    /AltimatOS/etc        -> /AltimatOS/System/cfg
    /AltimatOS/lib        -> /AltimatOS/System/lib
    /AltimatOS/lib64      -> /AltimatOS/System/lib64
    /AltimatOS/sbin       -> /AltimatOS/System/sbin
    /AltimatOS/tmp        -> /AltimatOS/System/tmp
    /AltimatOS/usr        -> /AltimatOS/System
    /AltimatOS/var        -> /AltimatOS/System/var
    /AltimatOS/System/etc -> /AltimatOS/System/cfg
  * Adding symbolic links to the host to create the /Users and /Applications
    trees. /System will be created, and overlay bind mounts will be mounted on
    certain directories under there to mimic the layout used in AltimatOS.
  * Scripts and tools for building lpkg packages will be installed on the
    host system.
  * The cross-tools tree will be created at /AltimatOS/tools and the build
    root will be created at /AltimatOS/sources
EOF
) | less 
