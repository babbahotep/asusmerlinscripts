#! /bin/ash
#test2
rm -f listid
touch listid

######## Listing the running vms################

esxcli vm process list |grep -v "^\s.*"| grep -v "^$" > list

######## If you want to reuse list for later use #######
####### put the file in a datastore, else it ##########
#######gonna be erease on next reboot ##########
####### Command look like this: ###############

## esxcli vm process list |grep -v "^\s.*"| grep -v "^$" > /vmfs/volumes/tmp/list

########## cleaning the id.s file by keeping only the id
for name in `cat list`;do
########## Dont forget to change the path if #######
########## you choose to put it in a datastore #####

## Example: for name in `cat /vmfs/volumes/yourDatastore/list`;do

        vim-cmd vmsvc/getallvms | grep $name | grep vmx | grep -v "^$" | awk '{print $1}'>> listid
done

for id in `cat listid`;do
        ###### suspending vms##########
        echo "Suspending the running machines"
        vim-cmd vmsvc/power.suspend $id
	echo $id 

done

echo "done."
echo "shutting down the host now.."
#/bin/poweroff
vim-cmd hostsvc/maintenance_mode_enter
#excli system maintenanceMode set --enable true
#done

