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

# test si fichier de conf exist
if test -f ./server_main.conf 
then
  # Chargement du fichier de conf
  . ./server_main.conf

  echo $password
else
  echo "pas de fichier de conf trouver"
fi

script_name=$0
script_full_path=$(dirname "$0")

lock_first_install=$script_full_path"/lock_firstinstall.launcher_app";
etat_application=0; #0=pas modifier,needupdate=update dispo,needinstall=application pas installer

app_path=$2
app_depot_http=$3

#rm $lock_first_install;
#rm -R $app_path

install_first_time (){
    echo "Installation initiale"
    ln -sf $0  '/etc/init.d/launcher_app.sh';
    echo "--> creation du lien symbolic dans le init.d"
    apt-get update && apt-get dist-upgrade -y && apt-get install git -y && \
    touch $lock_first_install;
    echo "--> Update , distupgrade , install git et creation du lockfirstinstall"
}

compare_version_app(){
  echo "Comparaison de l'application par rapport au dépot"
  if [ -d "$app_path" ];
  then
    cd $app_path;
    git fetch
    BRANCH_local=$(git rev-parse HEAD);
    BRANCH_origin=$(git rev-parse master@{upstream});
    if [ "$BRANCH_local" == "$BRANCH_origin" ];
    then
      etat_application="0"
      echo "--> Update to date"
    else
      etat_application="needupdate"
      echo "--> need update"
    fi
  else
    etat_application="needinstall"
    echo "--> need install"
  fi
}
install_app (){
  echo "Installation de le l'application"
  mkdir -p $app_path
  git clone $app_depot_http $app_path
}
update_app(){
  echo "Update de le l'application"
  cd $app_path;
  git pull
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
