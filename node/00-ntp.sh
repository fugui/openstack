apt install -y ntp

sed -i -e '18,24 s/^/#/g' /etc/ntp.conf
sed -i -e '17 a server controller iburst' /etc/ntp.conf

service ntp stop
timedatectl set-ntp yes
ntpd -gq
service ntp start

timedatectl
ntpq -p
