openstack user create --domain default --password NOVA_PASS nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne  compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
openstack user create --domain default --password PLACEMENT_PASS placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778
apt install -y nova-api nova-conductor nova-consoleauth  nova-novncproxy nova-scheduler nova-placement-api


sed  -i -e "s/connection = sqlite:\/\/\/\/var\/lib\/nova\/nova_api.sqlite/connection = mysql+pymysql:\/\/nova:NOVA_DBPASS@controller\/nova_api/g" /etc/nova/nova.conf
sed  -i -e "s/connection = sqlite:\/\/\/\/var\/lib\/nova\/nova.sqlite/connection = mysql+pymysql:\/\/nova:NOVA_DBPASS@controller\/nova/g" /etc/nova/nova.conf
sed  -i -e "4 a transport_url = rabbit://openstack:RABBIT_PASS@controller" /etc/nova/nova.conf
sed  -i -e "5 a my_ip = ${HW_CONTROLLER_IP}" /etc/nova/nova.conf
sed  -i -e "5 a use_neutron = True" /etc/nova/nova.conf
sed  -i -e "5 a firewall_driver = nova.virt.firewall.NoopFirewallDriver" /etc/nova/nova.conf
sed  -i -e "s/#auth_strategy = keystone/auth_strategy = keystone/g" /etc/nova/nova.conf
sed  -i -e "s/#auth_uri = <None>/auth_uri = http:\/\/controller:5000\nauth_url = http:\/\/controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = nova\npassword = NOVA_PASS/g" /etc/nova/nova.conf

sed  -i -e 's/^\[vnc]/\[vnc]\nenabled = true\nvncserver_listen = $my_ip\nvncserver_proxyclient_address = $my_ip/g'  /etc/nova/nova.conf
sed  -i -e "s/^\[glance]/[glance]\napi_servers = http:\/\/controller:9292/g" /etc/nova/nova.conf
sed  -i -e 's/^\[oslo_concurrency]/[oslo_concurrency]\nlock_path = \/var\/lib\/nova\/tmp/g' /etc/nova/nova.conf

sed -i '/log_dir/d' /etc/nova/nova.conf

sed -i -e "s/os_region_name = openstack/os_region_name = RegionOne\nproject_domain_name = Default\nproject_name = service\nauth_type = password\nuser_domain_name = Default\nauth_url = http:\/\/controller:35357\/v3\nusername = placement\npassword = PLACEMENT_PASS/g" /etc/nova/nova.conf

su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
nova-manage cell_v2 list_cells
nova-manage cell_v2 simple_cell_setup

service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart

nova-manage cell_v2 simple_cell_setup
