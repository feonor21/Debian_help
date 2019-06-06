#!/bin/bash

### BEGIN INIT INFO
# Provides:           launcher_app
# Required-Start:     $syslog $remote_fs
# Required-Stop:      $syslog $remote_fs
# Should-Start:       cgroupfs-mount cgroup-lite
# Should-Stop:        cgroupfs-mount cgroup-lite
# Default-Start:      2 3 4 5
# Default-Stop:       0 1 6
# Short-Description:  Service for enterprise docker
# Description:
### END INIT INFO
set -x #echo on
lockfirstinstall="/etc/launcher_app/lock_firstinstall.launcher_app";



install_first_time ()
{
    ln -sf $basename  '/etc/init.d/launcher_app.sh';
    apt-get update && apt-get dist-upgrade -y && apt-get install git -y && \
    touch $lockfirstinstall;
}


if test ! -f $lockfirstinstall; then install_first_time; fi
