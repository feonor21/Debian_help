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
install_git()


install_docker()

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

install_git (){
    read -p "Do you wish to install GIT?(y/n)" yn
    case $yn in
        [Yy]*) echo "install of GIT proccessing"
        apt-get install git -y
        ;;
        *) echo "Please answer yes(y) or no(other^^).";;
    esac
}


install_docker (){
    read -p "Do you wish to install/Update Docker?(y/n)" yn
    case $yn in
        [Yy]*)
        echo "Uninstall old versions of Docker"
        apt-get remove docker docker-engine docker.io containerd runc

        echo "Set up the repository"
        apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
        curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
            tee /etc/apt/sources.list.d/docker.list > /dev/null


        echo "Install Docker Engine"
        apt-get update
        apt-get install docker-ce docker-ce-cli containerd.io


        apt-cache madison docker-ce
        read -p "Choose Your Version(second column)" yn
        apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io

        install_dockercompose()

        ;;
        *) echo "Please answer yes(y) or no(other^^).";;
    esac
}
install_dockercompose (){
    read -p "Do you wish to install/Update Docker compose?(y/n)" yn
    case $yn in
        [Yy]*)
        echo "Docker compose Copy file to usr/bin"
        rm /usr/local/bin/docker-compose
        curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
        chmod +x /usr/local/bin/docker-compose
        ;;
        *) echo "Please answer yes(y) or no(other^^).";;
    esac
}


