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


connection = sqlite:////var/lib/nova/nova_api.sqlite
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api

connection = sqlite:////var/lib/nova/nova.sqlite
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova

transport_url = rabbit://openstack:RABBIT_PASS@controller
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = NOVA_PASS