#!/bin.sh
hostip="sshpass -e ssh"
$hostip ssh admin@192.168.1.121 "racadm serveraction powerdown"
$hostip ssh admin@192.168.1.131 "racadm serveraction powerdown"
#$hostip ssh admin@192.168.1.141 "racadm serveraction powerdown"
exit
