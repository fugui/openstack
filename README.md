# openstack

## Prerequisites
   1. Ubuntu Server 16.04.3 LTS 
   2. Accessable to internet ( apt-get, wget, curl )
   3. Dual network card ( one for management,  one for VM service/data layer )
   4. External network information and IP segments (for floating IP ) 

## Steps
   1. edit 00-env.sh,  setup the password and environment informations
   2. install openstack:   01-controller-install.sh
   3. edit 02-controller-init.sh, setup the network information
   4. init the network,  02-controller-init.sh
   
   for each compute node:
   1.  edit 00-env.sh (the compute ip and network card)
   2.  install compute node and network client agent.  (10-node-install.sh)
   
   
