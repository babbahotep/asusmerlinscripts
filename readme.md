my personal crappy scripts to customize an ASUS Merlin router.

running:
entware
bash
htop
iperf
mc
xmail
Diversion
ntp server
openssh-sftp-server

asus_copy_on_boot: files to copy on boot from usb to /jffs

/configs
avahi settings
dnsmasq.conf.add
  - pxe boot
  - auto assign ips in specific ranges for VMs and IoT devices based on their mac address  
  / block youtube and netflix for the kid's devices

/copy to local PC
files to copy to local PC
- scripts to distribute ssh keys for ssh without password
- boot / shutdown Dell Idrac servers

/exec on asus - scripts to run on the router
- benchmark for asus routers
- create daily backups of ESXI configs and store on asus USB (see services-start for daily cron job)
- email backup results
