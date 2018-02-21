#!/bin/bash

openstack user create --domain default --password ${GLANCE_PASS} glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

apt install -y glance


sed -i -e "s/#connection = <None>/connection = mysql+pymysql:\/\/glance:${GLANCE_DBPASS}@controller\/glance/g" /etc/glance/glance-api.conf

sed -i -e "s/#auth_section = <None>/auth_uri = http:\/\/controller:5000\nauth_url = http:\/\/controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = glance\npassword = ${GLANCE_PASS}/g" /etc/glance/glance-api.conf

sed -i -e "s/#flavor = keystone/flavor = keystone/g"  /etc/glance/glance-api.conf
sed -i -e "s/#stores = file,http/stores = file,http\ndefault_store = file\nfilesystem_store_datadir = \/var\/lib\/glance\/images\//g" /etc/glance/glance-api.conf

sed -i -e "s/#connection = <None>/connection = mysql+pymysql:\/\/glance:${GLANCE_DBPASS}@controller\/glance/g" /etc/glance/glance-registry.conf
sed -i -e "s/#auth_section = <None>/auth_uri = http:\/\/controller:5000\nauth_url = http:\/\/controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = glance\npassword = ${GLANCE_PASS}/g" /etc/glance/glance-registry.conf
sed -i -e "s/#flavor = keystone/flavor = keystone/g"  /etc/glance/glance-registry.conf

su -s /bin/sh -c "glance-manage db_sync" glance
service glance-registry restart
service glance-api restart

wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
openstack image create "cirros"  --file cirros-0.3.5-x86_64-disk.img   --disk-format qcow2 --container-format bare  --public

openstack image list
