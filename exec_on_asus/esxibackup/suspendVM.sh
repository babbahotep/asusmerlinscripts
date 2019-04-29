#!/bin/sh
RUNNING=0
VMS=`vim-cmd vmsvc/getallvms | grep -v Vmid | awk '{print $1}'`
for VM in $VMS ; do
     # echo "Probing VM with id: $VM."
     PWR=`vim-cmd vmsvc/power.getstate $VM | grep -v "Retrieved runtime info"`
     name=`vim-cmd vmsvc/get.config $VM | grep -i "name =" | awk '{print $3}' | head -1 | awk -F'"' '{print $2}'` 
     echo "VM with id $VM has power state $PWR (name = $name)."
     if [ "$PWR" == "Powered on" ] ; then
          RUNNING=1
          echo "Powered on VM with id $VM and name: $name"
          echo "Suspending VM with id $VM and name: $name"
          vim-cmd vmsvc/power.suspend $VM > /dev/null &
     fi
done

while true ; do
     if [ $RUNNING -eq 0 ] ; then
          echo "Gone..."
          break
     fi
     RUNNING=0
     for VM in $VMS ; do
          PWR=`vim-cmd vmsvc/power.getstate $VM | grep -v "Retrieved runtime info"`
          if [ "$PWR" == "Powered on" ] ; then
               name=`vim-cmd vmsvc/get.config $VM | grep -i "name =" | awk '{print $3}' | head -1 | awk -F'"' '{print $2}'` 
               echo "Waiting for id $VM and name: $name..."
               RUNNING=1
          fi
     done
     sleep 1
#esxcli system maintenanceMode set --enable true
done
