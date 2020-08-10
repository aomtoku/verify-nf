#!/bin/bash

ssh -A 192.168.122.2 -l netfpga 'if [ ! -d NetFPGA-SUME-dev ]; then git clone git@github.com:NetFPGA/NetFPGA-SUME-dev.git; fi'
ssh -A 192.168.122.2 -l netfpga 'cd /home/netfpga/NetFPGA-SUME-dev/lib/sw/std/driver/sume_riffa_v1_0_0 && make && sudo make install && sudo reboot'

#sleep 10
