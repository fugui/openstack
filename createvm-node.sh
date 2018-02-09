#!/bin/sh

INSTANCE_NAME=$1
VOLUME_ID=`cinder create --display-name ${INSTANCE_NAME} 30 | grep -sw id | awk '{ print $4 }'`
HOSTNAME_LVM=`cinder show $VOLUME_ID | grep "os-vol-host-attr:host" | awk '{print $4}'`

echo $VOLUME_ID  at $HOSTNAME_LVM

IFS='@'
read -ra ADDR <<< "$HOSTNAME_LVM"

if [ ${#ADDR[@]} -eq 2 ]; then
    HOSTNAME=${ADDR[0]}

    openstack server create --flavor CASCCE   \
         --image 5a2d60da-04f1-4890-b049-c2e40c946551 \
         --block-device source=$VOLUME_ID \
         --key-name cas \
         --availability-zone nova:dsde06 \
         --nic net-id=provider \
         --security-group 1aa5bf7c-5b37-430e-867e-9bbf777fd8ba \
         ${INSTANCE_NAME}
fi
