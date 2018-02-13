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

HOSTSOK=`grep -c controller /etc/hosts`
echo $HOSTSOK

if [ "$HOSTSOK" = 0 ]; then 
cat >> /etc/hosts <<EOF
${CONTROLLER_IP} controller
EOF
fi

NETWORK_OK=`grep ${CONTROLLER_NETWORK} /etc/network/interfaces`
echo $NETWORK_OK
if [ -z "$NETWORK_OK" ]; then
cat >> /etc/network/interfaces <<EOF

auto ${CONTROLLER_NETWORK}
iface ${CONTROLLER_NETWORK} inet manual
  up ip link set dev $$IFACE up
  down ip link set dev $$IFACE down
  
EOF
fi
