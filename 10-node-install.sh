#!/bin/bash

source ./00-env.sh

source ./node/00-ntp.sh

source ./node/01-prepare.sh

read -p "Press [Enter] key to start nova installation..."
source ./node/02-nova-client.sh

read -p "Press [Enter] key to start neutron installation..."
source ./node/03-neutron-self.sh

echo "Completed, enjoy it."
