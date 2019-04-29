#!/bin/bash
hostip="sshpass -e ssh"
$hostip admin@192.168.1.121 "racadm serveraction powerup"
$hostip admin@192.168.1.131 "racadm serveraction powerup"
#hostip admin@192.168.1.141 "racadm serveraction powerup"
exit
