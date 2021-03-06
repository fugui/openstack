#!/bin/bash

openstack user create --domain default --password NEUTRON_PASS neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

apt install -y neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-dhcp-agent neutron-metadata-agent


sed -i -e 's/connection = sqlite:\/\/\/\/var\/lib\/neutron\/neutron\.sqlite/connection = mysql+pymysql:\/\/neutron:NEUTRON_DBPASS@controller\/neutron/g' /etc/neutron/neutron.conf
sed -i -e '3 a transport_url = rabbit:\/\/openstack:RABBIT_PASS@controller\nservice_plugins =\nauth_strategy = keystone\nnotify_nova_on_port_status_changes = true\nnotify_nova_on_port_data_changes = true'  /etc/neutron/neutron.conf
sed -i -e 's/#auth_uri = <None>/auth_uri = http:\/\/controller:5000\nauth_url = http:\/\/controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = neutron\npassword = NEUTRON_PASS/g' /etc/neutron/neutron.conf
sed -i -e 's/#auth_url = <None>/auth_url = http:\/\/controller:35357\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nregion_name = RegionOne\nproject_name = service\nusername = nova\npassword = NOVA_PASS/g' /etc/neutron/neutron.conf

sed -i -e '/#type_drivers/a type_drivers = flat,vlan\ntenant_network_types =\nmechanism_drivers = linuxbridge\nextension_drivers = port_security' /etc/neutron/plugins/ml2/ml2_conf.ini
sed -i -e '/#flat_networks/a flat_networks = provider' /etc/neutron/plugins/ml2/ml2_conf.ini
sed -i -e 's/#enable_ipset = true/enable_ipset = true/g' /etc/neutron/plugins/ml2/ml2_conf.ini


sed -i -e 's/#physical_interface_mappings =/physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i -e 's/#enable_vxlan = true/enable_vxlan = false/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i -e '/#enable_security_group/a enable_security_group = true\nfirewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver' /etc/neutron/plugins/ml2/linuxbridge_agent.ini

sed -i -e '/^#interface_driver/a interface_driver = linuxbridge\ndhcp_driver = neutron.agent.linux.dhcp.Dnsmasq\nenable_isolated_metadata = true' /etc/neutron/dhcp_agent.ini


sed -i -e '/^#nova_metadata_host/a nova_metadata_host = controller\nmetadata_proxy_shared_secret = METADATA_SECRET' /etc/neutron/metadata_agent.ini

sed -i -e '/^\[neutron]/a url = http:\/\/controller:9696\nauth_url = http:\/\/controller:35357\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nregion_name = RegionOne\nproject_name = service\nusername = neutron\npassword = NEUTRON_PASS\nservice_metadata_proxy = true\nmetadata_proxy_shared_secret = METADATA_SECRET' /etc/nova/nova.conf

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron


service nova-api restart
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
