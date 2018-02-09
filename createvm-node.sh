#/bin/sh

INSTANCE_NAME=CAS2_CONSOLE=$1

cinder create --display-name ${INSTANCE_NAME} 50
cinder list
openstack server create --flavor CAS16G   \
     --image 5a2d60da-04f1-4890-b049-c2e40c946551 \
     --block-device source=6dbaeb51-82ac-4f23-ac92-2f7ee70cf594 \
     --key-name cas \
     --availability-zone nova:dsde05 \
     --nic net-id=provider \
     --security-group 1aa5bf7c-5b37-430e-867e-9bbf777fd8ba \
     ${INSTANCE_NAME}
