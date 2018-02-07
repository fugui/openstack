openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano

ssh-keygen -q -N ""
openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey

openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default

openstack network create  --share --external  --provider-physical-network provider   --provider-network-type flat provider

openstack subnet create --network provider --allocation-pool start=10.122.253.92,end=10.122.253.95 --dns-nameserver 10.122.150.81 --gateway 10.122.252.1 --subnet-range 10.122.252.0/23 provider


openstack flavor list
openstack image list
openstack network list
openstack security group list





openstack server create --flavor m1.nano --image cirros  --nic net-id=provider --security-group default --key-name mykey provider-instance

