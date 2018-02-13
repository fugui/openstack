#!/bin/bash

# the environment (passwords and ip addresses)
export DATABASE_ROOT_PASS=mysqlpass
export ADMIN_PASS=openstack             # Password of user admin
export DEMO_PASS=demouser               #Password of user demo
export DASH_DBPASS=dashdb               #Database password for the Dashboard
export GLANCE_DBPASS=glancedb           #Database password for Image service
export GLANCE_PASS=glanceuser           #Password of Image service user glance
export KEYSTONE_DBPASS=keystonedb       #Database password of Identity service
export METADATA_SECRET=metadatapass     #Secret for the metadata proxy
export NEUTRON_DBPASS=neutrondb         #Database password for the Networking service
export NEUTRON_PASS=neutronuser         #Password of Networking service user neutron
export NOVA_DBPASS=novadb               #Database password for Compute service
export NOVA_PASS=novauser               #Password of Compute service user nova
export PLACEMENT_PASS=placementpass     #Password of the Placement service user placement
export RABBIT_PASS=messagequeue         #Password of RabbitMQ user openstack

export CONTROLLER_IP=192.168.10.187     #the ip address of controller
export CONTROLLER_NETWORK=enp129s0f0    #the network card device name

export NETWORK_MODE=OVS                 #Network mode, PROVIDER(Provider Network) or OVS (Open vSwitch Self Service Network)

#now we don't install cinder service.
#CINDER_DBPASS	Database password for the Block Storage service
#CINDER_PASS	Password of Block Storage service user cinder

echo "00 Setup the local environment...."
apt-get update
apt-get -y upgrade

source ./00-ntp-controller.sh

source ./01-ubuntu-env.sh

source ./03-keystone.sh

source ../admin-openrc

source ./04-glance.sh

source ./05-nova.sh

source ./controller/051-nove-add-node.sh

source ./06-neutron-self.sh

source ./07-horizon.sh

echo "Verify the installation...."

openstack service list

openstack image list

openstack catalog list

openstack compute service list

nova-status upgrade check

openstack network agent list
