#!/bin/sh
# restorehost user host configBundle???.tgz

user=$1
host=$2
config=$3
bundle="configBundle.tgz"
echo "Config:" $config

cp $config $bundle
echo "rename" 
ls -al
scp configBundle.tgz $user@$host:/tmp && ls -al && rm $bundle
echo "copy"
ssh $user@$host ls /tmp
scp suspendVM.sh $user@$host:/tmp
echo "copy suspend script"
ssh $user@$host ls /tmp
ssh $user@$host sh /tmp/suspendVM.sh
#ssh $user@$host 'bash -s /tmp/suspendVM.sh'
ssh $user@$host vim-cmd hostsvc/maintenance_mode_enter
echo "suspend"
#cp configBundle*.tgz configBundle.tgz
#mv configBundle.tgz /tmp/configBundle.tgz
ssh $user@$host vim-cmd hostsvc/firmware/restore_config /tmp/configBundle.tgz
ssh $user@$host ls /tmp
exit
