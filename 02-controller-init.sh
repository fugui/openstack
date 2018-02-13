#!/bin/bash

source ./admin-openrc

#setup the inital network
openstack network create  --share --external \
  --provider-physical-network provider \
  --provider-network-type flat provider

openstack subnet create --network provider \
  --allocation-pool start=10.122.253.90,end=10.122.253.95 \
  --dns-nameserver 10.122.150.81 --gateway 10.122.252.1 \
  --subnet-range 10.122.252.1/23 provider

openstack network create selfservice

openstack subnet create --network selfservice \
  --dns-nameserver 10.122.150.81 --gateway 172.25.0.1 \
  --subnet-range 172.16.0.0/16 selfservice
  
openstack router create router

neutron router-interface-add router selfservice

neutron router-gateway-set router provider

neutron router-port-list router

#launch an instance
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
ssh-keygen -q -N ""
openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
openstack keypair list
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default

#check the status
openstack flavor list
openstack image list
openstack network list
openstack security group list

openstack server create --flavor m1.nano --image cirros \
  --nic net-id=selfservice --security-group default \
  --key-name mykey provider-instance
