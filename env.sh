#!/bin/sh

export HW_CONTROLLER_IP=192.168.0.106
export HW_COMPUTE1_IP=192.168.0.218

cat >> /etc/hosts  <<EOF
${HW_CONTROLLER_IP}    controller
${HW_COMPUTE1_IP}      compute1
EOF