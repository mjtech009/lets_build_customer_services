#!/bin/bash -ex
apt-get update -y && apt upgrade -y && apt install docker.io unzip wget curl nginx docker-compose telnet -y
useradd -m ${username}
echo "${username}:${password}" | chpasswd
usermod -G root ${username}
systemctl start docker
systemctl enable docker
usermod -aG docker ${username}
chown "${username}":"${username}" /home/"${username}"/.docker -R
chmod g+rwx "$HOME/.docker" -R
chmod 666 /var/run/docker
su ${username}
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source /home/${username}/.nvm/nvm.sh
