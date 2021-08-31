#!/bin/bash
### BEGIN INIT INFO
# Provides:           install_system.sh
# Required-Start:     $syslog $remote_fs
# Required-Stop:      $syslog $remote_fs
# Should-Start:       cgroupfs-mount cgroup-lite
# Should-Stop:        cgroupfs-mount cgroup-lite
# Default-Start:      2 3 4 5
# Default-Stop:       0 1 6
# Short-Description:  Service for enterprise docker
# Description:
### END INIT INFO

script_name=$0
script_full_path=$(dirname "$0")

echo "mise a jours de la liste des packages"
apt-get update 

update_system()
Install_git()
exit 0

update_system (){
    read -p "Do you wish to update system?(y/n)" yn
    case $yn in
        [Yy]*) echo "update system proccessing"
        apt-get dist-upgrade -y
        ;;
        *) echo "Please answer yes(y) or no(other^^).";;
    esac
}

Install_git (){
    read -p "Do you wish to install GIT?(y/n)" yn
    case $yn in
        [Yy]*) echo "install of GIT proccessing"
        apt-get install git -y
        ;;
        *) echo "Please answer yes(y) or no(other^^).";;
    esac
}



