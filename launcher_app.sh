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


lock_first_install="/etc/launcher_app/lock_firstinstall.launcher_app";
etat_application=0; #0=pas modifier,needupdate=update dispo,needinstall=application pas installer
app_path="/etc/app_service/"
app_depot_http="https://github.com/feonor21/laucher_debian9.git"
set -x #echo on

install_first_time (){
    echo "Installation initiale"
    ln -sf $basename  '/etc/init.d/launcher_app.sh';
    echo "--> creation du lien symbolic dans le init.d"
    apt-get update && apt-get dist-upgrade -y && apt-get install git -y && \
    touch $lock_first_install;
    echo "--> Update , distupgrade , install git et creation du lockfirstinstall"
    echo "->Installation initiale Terminer"
}

compare_version_app(){
  echo "Comparaison de l'application par rapport au dépot"
  if [ -d "$app_path" ]; then
    cd $app_path;
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [ "$BRANCH" = "" ]
    then
      etat_application="needinstall"
      echo "need install"
    else
      if [ "$BRANCH" != "master" ]
      then
        etat_application="needupdate"
        echo "need update"
      else
        etat_application="0"
        echo "Update to date"
      fi
    fi
  else
    etat_application="needinstall"
    echo "need install"
  fi
}
install_app (){
  echo "Installation de le l'application"
  mkdir -p $app_path
  cd $app_path;
  git clone $app_depot_http
}
update_app(){
echo ""
}

case $1 in
  start)
    if test ! -f $lock_first_install; then install_first_time; fi
    compare_version_app
    case $etat_application in
      needinstall)
        install_app
      ;;
      needupdate)
        update_app
    	;;
      esac
	;;
  stop)
	;;
  *)
  echo ""
  echo ""
	echo "Usage: "$basename
  echo "Make by Feonor"
  echo ""
  echo "start|stop"
	exit 1
esac
exit 0
