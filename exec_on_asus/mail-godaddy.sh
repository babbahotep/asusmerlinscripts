#!/bin/sh
#mail.sh to from text
# echo "This is a test email." | /usr/sbin/sendmail -S"192.168.1.1" -f"router@domain.com" esxi@home.lan


userfrom="cb@cbus.ch" #$1
userto=$2
subject=$3
text=$4

SMTP="mail.cbus.ch"
FROM="$userfrom"
FROMNAME="xmail $userfrom"
TO="$userto"

echo "Subject: $subject" >/tmp/mail.txt
echo "From: \\"$FROMNAME\\"<$FROM>" >>/tmp/mail.txt
echo "Date: $(date -R)" >>/tmp/mail.txt
echo "$text" >>/tmp/mail.txt
echo "My new IP is: $(nvram get wan0_ipaddr)" >>/tmp/mail.txt
echo "" >>/tmp/mail.txt
echo "--- " >>/tmp/mail.txt
echo "Your friendly router." >>/tmp/mail.txt
echo "" ­­>>/tmp/mail.txt

cat /tmp/mail.txt | /usr/sbin/sendmail -S"$SMTP" -f"$FROM" $TO

rm /tmp/mail.txt
