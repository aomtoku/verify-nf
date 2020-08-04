#!/bin/bash

os_image="bionic-server-cloudimg-amd64.img"
vm_image="snapshot-bionic-server-cloudimg.qcow2"
vm_seed="vm-seed.qcow2"
vm_size="5G"
repo="NetFPGA-SUME-live"

for pkgs in virtinst cloud-image-utils
do
if [ -z `apt -a list ${pkgs} | grep "installed"` ]; then
	echo "now {pkgs}"
	sudo apt install ${pkgs}
fi
done

if [ ! -f ${os_image} ] ; then
	echo "  downloading ... "
	wget https://cloud-images.ubuntu.com/bionic/current/${os_image}
	if [ ! -f ${os_image} ] ; then
		echo "[Ok] OS image: downloaded."
	else 
		echo "Error: failed to download ${os_image}"
		exit -1
	fi
else
	echo "[Ok] OS image: you already have it."
fi

if [ ! -f ${vm_image} ]; then
	echo "creating VM disk..."
	qemu-img create -b ${os_image} -f qcow2 ${vm_image} ${vm_size}
	qemu-img info ${vm_image}
else
	echo ""
fi

if [ ! -f ${vm_seed} ]; then
	cloud-localds -v --network-config=network_config_static.cfg ${vm_seed} cloud_init.cfg
fi

# show seed disk just generated
#qemu-img info ${vm_seed}

virt-install --name netfpga0 \
  --virt-type kvm --memory 2048 --vcpus 1 \
  --boot hd,menu=on \
  --disk path=${vm_seed},device=cdrom \
  --disk path=${vm_image},device=disk \
  --nographics \
  --os-type Linux --os-variant ubuntu18.04 \
  --network network:default
#  --console pty,target_type=serial


if [ ! -d ${repo} ]; then
	echo "Error: ${repo} not found "
else
	scp ${repo} --password netfpga netfpga@192.168.122.2:~/
fi

#echo "Starting verification script..."
#ssh -n --password netfpga netfpga@192.168.122.2 'bash '

