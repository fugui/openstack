 apt install -y neutron-linuxbridge-agent
 
 sed -i -e '/^connection/d' /etc/neutron/neutron.conf
 sed -i -e '2 a transport_url = rabbit://openstack:RABBIT_PASS@controller\nauth_strategy = keystone' /etc/neutron/neutron.conf
 sed -i -e 's/#auth_uri = <None>/auth_uri = http:\/\/controller:5000\nauth_url = http:\/\/controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = neutron\npassword = NEUTRON_PASS/g'  /etc/neutron/neutron.conf
 
sed -i -e '/^#physical_interface_mappings/a physical_interface_mappings=provider:enp129s0f1' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i -e '/^#enable_vxlan/a enable_vxlan = false' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i -e '/^#enable_security_group/a enable_security_group = true\nfirewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
 
sed -i -e '/^\[neutron]/a url = http:\/\/controller:9696\nauth_url = http:\/\/controller:35357\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nregion_name = RegionOne\nproject_name = service\nusername = neutron\npassword = NEUTRON_PASS' /etc/nova/nova.conf

service nova-compute restart
service neutron-linuxbridge-agent restart
