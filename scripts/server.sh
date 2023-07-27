#!/bin/bash -ex
apt-get update -y && apt upgrade -y && apt install docker.io unzip wget curl nginx docker-compose telnet -y
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
apt-get install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
useradd -m ${username}
echo "${username}:${password}" | chpasswd
systemctl start docker
systemctl enable docker
usermod -aG docker ${username}
chown "${username}":"${username}" /home/"${username}"/.docker -R
chmod g+rwx "$HOME/.docker" -R
chmod 666 /var/run/docker
su ${username}
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source /home/${username}/.nvm/nvm.sh
