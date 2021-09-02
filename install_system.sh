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
    read -t 5 -p "Do you wish to install ohmyzsh?(y(default)/n)" yn
    ${yn:=Y}
    case $yn in
        [Yy]*) echo "Install ohmyzsh proccessing"
        apt -y install zsh zplug
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        ;;
        *);;
    esac
}

install_dockercompose (){
    read -t 5 -p "Do you wish to install/Update Docker compose?(y(default)/n)" yn
    ${yn:=Y}
    case $yn in
        [Yy]*)
        echo "Docker compose Copy file to usr/bin"
        rm /usr/local/bin/docker-compose
        curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
        chmod +x /usr/local/bin/docker-compose
        ;;
        *);;
    esac
}
install_docker (){
    read -t 5 -p "Do you wish to install/Update Docker?(y(default)/n)" yn
    ${yn:=Y}
    case $yn in
        [Yy]*)
        echo "Uninstall old versions of Docker"
        apt-get -y remove docker docker-engine docker.io containerd runc

        echo "Set up the repository"
        apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release
        curl -L https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
            tee /etc/apt/sources.list.d/docker.list > /dev/null


        echo "Install Docker Engine"
        apt-get update
        apt-get -y install docker-ce docker-ce-cli containerd.io


        apt-cache madison docker-ce
        read -p "Choose Your Version(second column)" version
        apt-get -y install docker-ce=$version docker-ce-cli=$version containerd.io
        
        install_dockercompose
        ;;
        *);;
    esac
}
install_git (){
    read -t 5 -p "Do you wish to install GIT?(y(default)/n)" yn
    ${yn:=Y}
    case $yn in
        [Yy]*) echo "install of GIT proccessing"
        apt-get install git -y
        ;;
        *);;
    esac
}
update_system (){
    read -t 5 -p "Do you wish to update system?(y(default)/n)" yn
    ${yn:=Y}
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

install_zsh
install_ohmyzsh

exit 0
