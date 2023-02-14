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

install_ohmyzsh (){
    read -t 30 -p "Do you wish to install ohmyzsh?(y(default)/n)" -e -i 'n' yn || yn=Y
    case $yn in
        [Yy]*) echo "Install ohmyzsh proccessing"
        apt -y install zsh zplug
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        ;;
        *);;
    esac
}

install_dockercompose (){
    read -t 30 -p "Do you wish to install/Update Docker compose?(y(default)/n)" -e -i 'Y' yn || yn=Y
    case $yn in
        [Yy]*)
        echo "Docker compose Copy file to usr/bin"
        rm /usr/local/bin/docker-compose
        curl -L "https://github.com/docker/compose/releases/download/2.16.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
        chmod +x /usr/local/bin/docker-compose
        ;;
        *);;
    esac
}
install_docker (){
    read -t 30 -p "Do you wish to install/Update Docker?(y(default)/n)" -e -i 'Y' yn || yn=Y
    case $yn in
        [Yy]*)
        echo "Uninstall old versions of Docker"
        apt-get -y remove docker docker-engine docker.io containerd runc

        echo "Install Docker Engine"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        
        install_dockercompose
        ;;
        *);;
    esac
}
install_git (){
    read -t 30 -p "Do you wish to install GIT?(y(default)/n)" -e -i 'Y' yn || yn=Y
    case $yn in
        [Yy]*) echo "install of GIT proccessing"
        apt-get install git -y
        ;;
        *);;
    esac
}
update_system (){
    read -t 30 -p "Do you wish to update system?(y(default)/n)" -e -i 'Y' yn || yn=Y
    case $yn in
        [Yy]*) echo "update system proccessing"
        apt-get dist-upgrade -y
        ;;
        *);;
    esac
}



echo "Update of all package list"
apt-get update 

update_system
install_git


install_docker

install_ohmyzsh

exit 0
