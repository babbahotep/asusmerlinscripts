#!/bin/sh
user="root"
host="192.168.1.120"

#scp suspendVM.sh $user@$host:/tmp
#scp sus2.sh $user@$host:/tmp
scp s3.sh $user@$host:/tmp
echo "copy suspend script"
ssh $user@$host ls /tmp
#ssh $user@$host chmod 777 /tmp/s3.sh
#cat sus2.sh | ssh -T $user@$host # WORKING! 
#cat s3,sh | ssh -T $user@$host
#cat suspendVM.sh | ssh -T $user@$host #WORKING!
# screen -S moo ash -s /tmp/sus2.sh
ssh $user@$host sh /tmp/suspendVM.sh
#ssh $user@$host vim-cmd hostsvc/maintenance_mode_enter
echo "suspend"
