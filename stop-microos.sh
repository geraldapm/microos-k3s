#!/bin/bash

CURRENT_DIR=$(pwd)

vms=(
    "gpmcontrolplane1"
    "gpmcontrolplane2"
    "gpmcontrolplane3"
    "gpmworker1"
    "gpmworker2"
)

for vm in ${vms[*]}; do
    echo "Destroying VM $vm"
    virsh destroy $vm
    virsh undefine $vm --remove-all-storage
    rm -f $vm.ign
done