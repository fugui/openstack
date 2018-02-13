#!/bin/bash

# the environment (passwords and ip addresses)
source ./00-env.sh

echo "00 Setup the local environment...."
apt-get update
apt-get -y upgrade

source ./controller/00-ntp-controller.sh

source ./controller/01-ubuntu-env.sh

source ./controller/03-keystone.sh

source ./admin-openrc

source ./controller/04-glance.sh

source ./controller/05-nova.sh

source ./controller/051-nove-add-node.sh

source ./controller/06-neutron-self.sh

source ./controller/07-horizon.sh

echo "Verify the installation...."
openstack service list
openstack image list
openstack catalog list
openstack compute service list
nova-status upgrade check
openstack network agent list
