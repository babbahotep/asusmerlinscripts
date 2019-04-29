#!/bin/bash
#1.00 Production
#scp nopass_ssh.sh admin@192.168.1.1:/path
# works for ESXI 6.7
# install sshpass brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
# apt-get install sshpass
#usage: nopass_ssh.sh user pw hostip 

#create your keys with "ssh-keygen -t rsa"
#export SSHPASS="password"
user="$1"
pw="$2"
host="$3"
export SSHPASS="$pw"
echo $SSHPASS 
sleep 2
#assemble hostip
hostip="sshpass -e ssh $user@$host"

echo $hostip

# create .ssh folder
echo "create .ssh folder"
#ssh 
$hostip mkdir -p .ssh
echo "create backup"
#backup esxi authorizedKeys on host
#ssh 
$hostip mv .ssh/authorized_keys .ssh/authorized_keys.orig
# copy key to host
echo "copy key"
cd "$HOME"
cat .ssh/id_rsa.pub | $hostip 'cat >> .ssh/authorized_keys'
# create symlink for ESXI
echo "create link"
#ssh 
#$hostip ln -sf /opt/.ssh/authorized_keys /etc/ssh/keys-root/authorized_keys
#$hostip ln -sf /opt/.ssh/authorized_keys /home/root/.ssh/authorized_keys
# secure folders
echo "secure folder"
#ssh 
$hostip "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"
ssh $user@$host
ls -al
exit
