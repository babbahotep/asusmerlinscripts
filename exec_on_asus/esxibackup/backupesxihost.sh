#!/bin/bash
# ./backuphost.sh user hostip
# id-rsa.pub on every host
# esxi needs ssh -i /path/to/id_rsa
user="root"
host1="192.168.1.120"
host2="192.168.1.130"
host3="192.168.1.140"
stamp=`date '+%Y_%m_%d-%H-%M'`
BACKUP_KEEP=3 # set number of days to keep
sshx="/usr/bin/ssh -i /home/root/.ssh/id_rsa "
echo "user:" "$user" "and" "host ip:" "$host1" "$host2" "$host3"
echo "date" $stamp

# Host 1
echo "check if next $host1 is up"
if ping -c1 $host1 1>/dev/null 2>/dev/null
then
  echo "$host1 is up"
  ESXI_VERSION_BASE=$($sshx $user@$host1 vmware -v | awk '{ print $3 }' | sed "s/\./-/g")
  echo "base" $ESXI_VERSION_BASE
  sleep 3
  ESXI_VERSION_BUILD=$($sshx $user@$host1 vmware -v | awk '{ print $4 }')
  echo "build" $ESXI_VERSION_BUILD
  sleep 3
  # sync Config
  echo "Sync Config on ESXI host"
  $sshx $user@$host1 vim-cmd hostsvc/firmware/sync_config
  echo "Backup and download ESXI host config"
  URL1=$($sshx $user@$host1 vim-cmd hostsvc/firmware/backup_config)
  path1="$(echo $URL1 | cut -d "*" -f 2)"
  proto1=$(echo $URL1 | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*")
  xfile1=$(echo "${URL1##*/}")
  #xfile21=$(echo $stamp"_"$host1"__"$xfile1)
  xfile21=${stamp}_"base"_${ESXI_VERSION_BASE}-${ESXI_VERSION_BUILD}_${host1}__${xfile1}
  echo "filename" $xfile21
  sleep 3
  hosturl1=$(echo $proto1$host1$path1)
  wget --no-check-certificate --continue $hosturl1 -O $xfile1
  mv -f $xfile1 /mnt/ASUS32GB/esxibackups/120/$xfile21
else
  echo "$host1 is down and nothing here"
fi

# Host 2
echo "check if next $host2 is up"
if ping -c1 $host1 1>/dev/null 2>/dev/null
then
  echo "$host2 is up"
  ESXI_VERSION_BASE=$($sshx $user@$host1 vmware -v | awk '{ print $3 }' | sed "s/\./-/g")
  echo "base" $ESXI_VERSION_BASE
  ESXI_VERSION_BUILD=$($sshx $user@$host1 vmware -v | awk '{ print $4 }')
  echo "build" $ESXI_VERSION_BUILD
  # sync Config
  echo "Sync Config on ESXI host"
  $sshx $user@$host2 vim-cmd hostsvc/firmware/sync_config
  echo "Backup and download ESXI host config"
  URL2=$($sshx $user@$host2 vim-cmd hostsvc/firmware/backup_config)
  path2="$(echo $URL2 | cut -d "*" -f 2)"
  proto2=$(echo $URL2 | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*")
  xfile2=$(echo "${URL2##*/}")
  xfile22=${stamp}_"base"_${ESXI_VERSION_BASE}-${ESXI_VERSION_BUILD}_${host2}__${xfile2}
  echo "filename" $xfile22
  hosturl2=$(echo $proto2$host2$path2)
  wget --no-check-certificate --continue $hosturl2 -O $xfile2
  mv -f $xfile2 /mnt/ASUS32GB/esxibackups/130/$xfile22
else
  echo "$host2 is down and nothing here"
fi

# Host 3
echo "check if next $host3 is up"
if ping -c1 $host1 1>/dev/null 2>/dev/null
then
echo "$host3 is up"
ESXI_VERSION_BASE=$($sshx $user@$host1 vmware -v | awk '{ print $3 }' | sed "s/\./-/g")
echo "base" $ESXI_VERSION_BASE
ESXI_VERSION_BUILD=$($sshx $user@$host1 vmware -v | awk '{ print $4 }')
echo "build" $ESXI_VERSION_BUILD
# sync Config
echo "Sync Config on ESXI host"
$sshx $user@$host3 vim-cmd hostsvc/firmware/sync_config
echo "Backup and download ESXI host config"
URL3=$($sshx $user@$host3 vim-cmd hostsvc/firmware/backup_config)
path3="$(echo $URL3 | cut -d "*" -f 2)"
proto3=$(echo $URL3 | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*")
xfile3=$(echo "${URL3##*/}")
xfile23=${stamp}_"base"_${ESXI_VERSION_BASE}-${ESXI_VERSION_BUILD}_${host3}__${xfile3}
echo "filename" $xfile23
hosturl3=$(echo $proto3$host3$path3)
wget --no-check-certificate --continue $hosturl3 -O $xfile3
mv -f $xfile3 /mnt/ASUS32GB/esxibackups/140/$xfile23

else
  echo "$host3 is down and nothing here"
fi

# remove old backups
find /mnt/ASUS32GB/esxibackups/120/ -mtime +$BACKUP_KEEP -type f -exec rm {} \;
echo 'remaining:' ls /mnt/ASUS32GB/esxibackups/120/
sleep 3
find /mnt/ASUS32GB/esxibackups/130/ -mtime +$BACKUP_KEEP -type f -exec rm {} \;
echo 'remaining:' ls /mnt/ASUS32GB/esxibackups/130/
sleep 3
find /mnt/ASUS32GB/esxibackups/140/ -mtime +$BACKUP_KEEP -type f -exec rm {} \;
echo 'remaining:' ls /mnt/ASUS32GB/esxibackups/140/
sleep 3
sh /jffs/customscripts/exec_on_asus/mail.sh esxi@home.lan esxi@home.lan "esxi backup complete"  "$xfile21 /n /n $xfile22 /n /n $xfile23"

exit
