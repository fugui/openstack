apt install -y chrony


sed -i -e "s/pool 2.debian.pool.ntp.org offline iburst/server szxntp01-in.huawei.com iburst\nserver szxntp02-in.huawei.com iburst/g"  /etc/chrony/chrony.conf
sed -i -e "67 a allow 0.0.0.0/0" /etc/chrony/chrony.conf

service chrony restart
