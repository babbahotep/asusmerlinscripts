#!/bin/bash
#1.00 production
#execute on asus router
#asus_nopw USER IP
#create your keys with
#/usr/bin/dropbearkey -f id_rsa -t rsa
#/usr/bin/dropbearkey -y -f id_rsa > id_rsa.pub
# ssh ssh -i ~/.ssh/id_rsa admin@xxxx.asuscomm.com
user="$1"
host="$2"
#assemble hostip
hostip="ssh $user@$host"

echo $hostip

# create .ssh folder
echo "create .ssh folder"
#ssh 
#$hostip mkdir -p /opt/.ssh
echo "create backup"
#backup esxi authorizedKeys on host
#ssh 
$hostip cp /etc/ssh/keys-root/authorized_keys /etc/ssh/keys-root/authorized_keys.orig
# copy key to host
echo "copy key"
#original cat .ssh/id_rsa.pub | ssh $hostip 'cat >> /opt/.ssh/authorized_keys'
cat $HOME/.ssh/id_rsa.pub | $hostip 'cat >> /etc/ssh/keys-root/authorized_keys'
# create symlink for ESXI
echo "create link"
#ssh 
#$hostip ln -sf /opt/.ssh/authorized_keys /etc/ssh/keys-root/authorized_keys
# secure folders
echo "secure folder"
#ssh 
$hostip "chmod 700 /etc/ssh; chmod 640 /etc/ssh/keys-root/authorized_keys"
ssh $user@$host
ls
exit
