#!/bin/bash
# ./backuphost.sh user hostip

user="root"
host1="192.168.1.120"
host2="192.168.1.130"
host3="192.168.1.140"
sshx="/usr/bin/ssh -i /home/root/.ssh/id_rsa "
echo "user:" "$user" "and" "host ip:" "$host1" "$host2" "$host3"

# sync Config
echo "Sync Config on ESXI host" 
$sshx $user@$host1 vim-cmd hostsvc/firmware/sync_config
echo $?
sleep 3
$sshx $user@$host2 vim-cmd hostsvc/firmware/sync_config
echo $?
sleep 3
$sshx $user@$host3 vim-cmd hostsvc/firmware/sync_config
echo $?
sleep 3
# create backup archive and download
#ipaddr=$(hostname -i)
stamp=`date '+%Y_%m_%d-%H-%M'`
echo "date" $stamp
sleep 3
echo "Backup and download ESXI host config"
URL1=$($sshx $user@$host1 vim-cmd hostsvc/firmware/backup_config)
URL2=$($sshx $user@$host2 vim-cmd hostsvc/firmware/backup_config)
URL3=$($sshx $user@$host3 vim-cmd hostsvc/firmware/backup_config)

path1="$(echo $URL1 | cut -d "*" -f 2)"
path2="$(echo $URL2 | cut -d "*" -f 2)"
path3="$(echo $URL3 | cut -d "*" -f 2)"
proto1=$(echo $URL1 | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*")
proto2=$(echo $URL2 | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*")
proto3=$(echo $URL3 | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*")

xfile1=$(echo "${URL1##*/}")
xfile2=$(echo "${URL2##*/}")
xfile3=$(echo "${URL3##*/}")

xfile21=$(echo $stamp"_"$host1"__"$xfile1)
xfile22=$(echo $stamp"_"$host2"__"$xfile2)
xfile23=$(echo $stamp"_"$host3"__"$xfile3)

hosturl1=$(echo $proto1$host1$path1)
hosturl2=$(echo $proto2$host2$path2)
hosturl3=$(echo $proto3$host3$path3)

echo "date" $stamp
echo "datefile" $xfile2
sleep 3

#echo $host
#echo "1" $hosturl
#echo "2" $proto$host$path
#echo "3" $xfile
wget --no-check-certificate --continue $hosturl1 -O $xfile1
wget --no-check-certificate --continue $hosturl2 -O $xfile2
wget --no-check-certificate --continue $hosturl3 -O $xfile3

echo "new file name" $xfile2
sleep 3
mv -f $xfile1 /mnt/ASUS32GB/esxibackups/120/$xfile21
mv -f $xfile2 /mnt/ASUS32GB/esxibackups/130/$xfile22
mv -f $xfile3 /mnt/ASUS32GB/esxibackups/140/$xfile23
#scp $xfile admin@192.168.1.1:/jffs/esxiscripts

sh /jffs/customscripts/exec_on_asus/mail.sh esxi@home.lan esxi@home.lan "esxi backup complete"  "$xfile21 $xfile22 $xfile23"

#extract URL
# Extract the protocol (includes trailing "://").
#PARSED_PROTO="$(echo $PROJECT_URL | sed -nr 's,^(.*://).*,\1,p')"

# Remove the protocol from the URL.
#PARSED_URL="$(echo ${PROJECT_URL/$PARSED_PROTO/})"

# Extract the user (includes trailing "@").
#PARSED_USER="$(echo $PARSED_URL | sed -nr 's,^(.*@).*,\1,p')"

# Remove the user from the URL.
#PARSED_URL="$(echo ${PARSED_URL/$PARSED_USER/})"

# Extract the port (includes leading ":").
#PARSED_PORT="$(echo $PARSED_URL | sed -nr 's,.*(:[0-9]+).*,\1,p')"

# Remove the port from the URL.
#PARSED_URL="$(echo ${PARSED_URL/$PARSED_PORT/})"

# Extract the path (includes leading "/" or ":").
#PARSED_PATH="$(echo $PARSED_URL | sed -nr 's,[^/:]*([/:].*),\1,p')"

# Remove the path from the URL.
#PARSED_HOST="$(echo ${PARSED_URL/$PARSED_PATH/})"

ls -al | grep config*

#echo "url" $PARSED_URL
#echo $PARSED_URL
#echo "path" $PARSEDPATH
#echo 
#echo
#echo

exit
