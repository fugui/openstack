#/bin/sh

INSTANCE_NAME=$1
VOLUME_ID=`cinder create --display-name ${INSTANCE_NAME} 10 | grep -sw id | awk '{ print $4 }'`
HOSTNAME=`cinder show $VOLUME_ID | grep "os-vol-host-attr:host" | awk '{print $4}'`

echo $VOLUME_ID  at $HOSTNAME

openstack server create --flavor CASCCE   \
     --image a37419e2-b8b6-4adc-bdfc-e057dd4fa4fd \
     --block-device source=$VOLUME_ID \
     --key-name cas \
     --availability-zone nova:dsde06 \
     --nic net-id=provider \
     --security-group 1aa5bf7c-5b37-430e-867e-9bbf777fd8ba \
     ${INSTANCE_NAME}
