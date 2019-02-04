export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
apt install -y curl --assume-yes

# Set-up the ip add
ip addr add 172.27.1.1/24 dev eth1
ip link set eth1 up

ip route replace 172.16.0.0/12 via 172.27.1.254
