apt install -y nova-compute

sed -i -e "4 a transport_url = rabbit://openstack:RABBIT_PASS@controller\nmy_ip=${HW_COMPUTE1_IP}\nuse_neutron = True\nfirewall_driver = nova.virt.firewall.NoopFirewallDriver" /etc/nova/nova.conf

sed -i -e "s/#auth_strategy = keystone/auth_strategy = keystone/g" /etc/nova/nova.conf

sed -i -e "/\[keystone_authtoken/a auth_uri = http:\/\/controller:5000\nauth_url = http:\/\/controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = nova\npassword = NOVA_PASS" /etc/nova/nova.conf

sed -i -e '/^\[vnc]/a enabled = True\nvncserver_listen = 0.0.0.0\nvncserver_proxyclient_address = $my_ip\nnovncproxy_base_url = http:\/\/controller:6080\/vnc_auto.html' /etc/nova/nova.conf



sed -i -e 's/#api_servers = <None>/api_servers = http:\/\/controller:9292/g' /etc/nova/nova.conf

sed -i -e 's/#lock_path = \/tmp/lock_path = \/var\/lib\/nova\/tmp/g' /etc/nova/nova.conf

sed -i -e '/log_dir/d' /etc/nova/nova.conf

sed -i -e 's/os_region_name = openstack/os_region_name = RegionOne\nproject_domain_name = Default\nproject_name = service\nauth_type = password\nuser_domain_name = Default\nauth_url = http:\/\/controller:35357\/v3\nusername = placement\npassword = PLACEMENT_PASS/g' /etc/nova/nova.conf

service nova-compute restart
