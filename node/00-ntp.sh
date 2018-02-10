apt install -y chrony

sed -i -e 's/pool 2\.debian\.pool\.ntp\.org offline iburst/server controller iburst/g' /etc/chrony/chrony.conf

service chrony restart

chronyc sources
