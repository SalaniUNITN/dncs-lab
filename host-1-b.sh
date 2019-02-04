export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes

# Set-up the ip add
ip addr add 172.27.2.225/27 dev eth1
ip link set eth1 up

ip route replace 172.16.0.0/12 via 172.27.2.254
