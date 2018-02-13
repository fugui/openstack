#!/bin/bash

apt install -y openstack-dashboard

sed -i -e "/^OPENSTACK_HOST/c OPENSTACK_HOST = \"controller\"" /etc/openstack-dashboard/local_settings.py

sed -i -e "155,161 s/^/#/g" /etc/openstack-dashboard/local_settings.py

sed -i -e "154 a SESSION_ENGINE = 'django.contrib.sessions.backends.cache'\nCACHES = {\n    'default': {\n         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',\n         'LOCATION': 'controller:11211',\n    }\n}" /etc/openstack-dashboard/local_settings.py

sed -i -e "/^OPENSTACK_KEYSTONE_URL/c OPENSTACK_KEYSTONE_URL = \"http://%s:5000/v3\" % OPENSTACK_HOST" /etc/openstack-dashboard/local_settings.py

sed -i -e "/^OPENSTACK_KEYSTONE_DEFAULT_ROLE/c OPENSTACK_KEYSTONE_DEFAULT_ROLE = \"user\"" /etc/openstack-dashboard/local_settings.py

sed -i -e "/#OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT/a OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True" /etc/openstack-dashboard/local_settings.py

sed -i -e "/#OPENSTACK_API_VERSIONS/a OPENSTACK_API_VERSIONS = {\n    \"identity\": 3,\n    \"image\": 2,\n    \"volume\": 2,\n }" /etc/openstack-dashboard/local_settings.py

sed -i -e "/^OPENSTACK_KEYSTONE_DEFAULT_DOMAIN/a OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = \"Default\"" /etc/openstack-dashboard/local_settings.py

sed -e -e "4 a WSGIApplicationGroup %{GLOBAL}" /etc/apache2/conf-available/openstack-dashboard.conf

service apache2 reload
