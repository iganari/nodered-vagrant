#!/bin/bash

set -x

### prepare apt-get
apt-get update
apt-get upgrade -y
apt-get install -y vim openssh-server


### prepare ssh.service
systemctl start ssh
systemctl enable ssh
# systemctl status ssh


### setting editor
curl https://gist.githubusercontent.com/iganari/a2baec1af976425cc8e21ccd68cf5585/raw/b6fce2cc91e1c77da759af1d2ea7b771b597787f/_vimrc -o /root/.vimrc
ls -la /usr/bin/vim.basic 
unlink /etc/alternatives/editor
ln -s  /usr/bin/vim.basic /etc/alternatives/editor
apt --purge remove -y nano


### setting datetime
rm -rfv /etc/localtime &&\
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo 'LANG="en_US.UTF-8"' > /etc/default/locale


### install nodeje-8 for Node-RED
apt remove --purge -y nodejs
curl -sL https://deb.nodesource.com/setup_8.x | /bin/bash
apt-get install -y nodejs
npm install -g --unsafe-perm node-red


### create working user
username='pi'
useradd -m -s /bin/bash ${username}
echo "${username} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${username}
chmod 0440                                  /etc/sudoers.d/${username}
cp    /root/.vimrc            /home/${username}/.vimrc
chown ${username}:${username} /home/${username}/.vimrc

### copy install script of Node-RED 

app_path='/opt/nodered-vagrant'

mkdir                         ${app_path}
chmod 0777 -R                 ${app_path} 
chown ${username}:${username} ${app_path}
cp ./init-node-red.sh         ${app_path}/init-node-red.sh
chown ${username}:${username} ${app_path}/init-node-red.sh
chmod 0755                    ${app_path}/init-node-red.sh

cp etc/systemd/system/node-red.service /etc/systemd/system/node-red.service
chmod 0755 /etc/systemd/system/node-red.service
chown root:root /etc/systemd/system/node-red.service

cp usr/bin/node-red-start /usr/bin/node-red-start 
cp usr/bin/node-red-stop  /usr/bin/node-red-stop
chmod 0755                /usr/bin/node-red-st* 
chown root:root           /usr/bin/node-red-st*
