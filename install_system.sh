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
    read -t 30 -p "Do you wish to install ohmyzsh? " -e -i 'n' yn || yn=Y
    case $yn in
        [Yy]*) echo "Install ohmyzsh proccessing"
        apt -y install zsh zplug
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        ;;
        *);;
    esac
}

install_dockercompose (){
    read -t 30 -p "Do you wish to install/Update Docker compose? " -e -i 'Y' yn || yn=Y
    case $yn in
        [Yy]*)
        echo "Docker compose Copy file to usr/bin"
        apt-get update
        apt-get install docker-compose-plugin
        docker compose version
        ;;
        *);;
    esac
}
install_docker (){
    read -t 30 -p "Do you wish to install/Update Docker? " -e -i 'Y' yn || yn=Y
    case $yn in
        [Yy]*)
        echo "Unistall docker"
        apt-get -y remove docker-ce docker-ce-cli containerd.io
        
        echo "Install Prerequisites"
        apt-get install apt-transport-https ca-certificates curl gnupg lsb-release

        echo "Add Docker’s GPG Repo Key"
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        echo "Adding the Docker repository in the sources"
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

        echo "Install Docker Engine"
        apt-get update
        apt-get install docker-ce docker-ce-cli containerd.io
        docker run hello-world
        
        install_dockercompose
        ;;
        *);;
    esac
}
install_git (){
    read -t 30 -p "Do you wish to install GIT? " -e -i 'Y' yn || yn=Y
    case $yn in
        [Yy]*) echo "install of GIT proccessing"
        apt-get install git -y
        ;;
        *);;
    esac
}
update_system (){
    read -t 30 -p "Do you wish to update system? " -e -i 'Y' yn || yn=Y
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
