#!/bin/bash

vm_name="netfpga0"

res=`virsh list | grep "$vm_name"`
if [ -n "${res}" ]; then
	virsh destroy ${vm_name}
else
	echo "${vm_name} is not listed on KVM"
fi

res=`virsh dumpxml ${vm_name} | grep "<name>${vm_name}</name>"`
if [ -n  "${res}" ] ; then
	virsh undefine ${vm_name}
else
	echo "${vm_name} is not defined"
fi

if [ -f snapshot-bionic-server-cloudimg.qcow2 ]; then
	rm -f snapshot-bionic-server-cloudimg.qcow2
fi

if [ -f vm-seed.qcow2 ]; then
	rm -f vm-seed.qcow2
fi
