apt install -y software-properties-common
add-apt-repository -y cloud-archive:pike

apt update 
apt -y dist-upgrade

apt install -y python-openstackclient
