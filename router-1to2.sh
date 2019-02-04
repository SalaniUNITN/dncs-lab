export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
wget -O- https://apps3.cumulusnetworks.com/setup/cumulus-apps-deb.pubkey | apt-key add -
add-apt-repository "deb [arch=amd64] https://apps3.cumulusnetworks.com/repos/deb $(lsb_release -cs) roh-3"
apt-get update
apt-get install -y frr --assume-yes --force-yes

#PROVISIONING
vagrant up --provision

# Set-up the interfaces
ip link add link eth1 name eth1.H10 type vlan id 10
ip link add link eth1 name eth1.H20 type vlan id 20

ip link set eth1 up
ip link set eth2 up
ip link set eth1.H10 up
ip link set eth1.H20 up

ip addr add 172.27.1.254/24 dev eth1.H10
ip addr add 172.27.2.254/27 dev eth1.H20
ip addr add 172.31.255.253/30 dev eth2

ip link set eth1 up
ip link set eth2 up
ip link set eth1.H10 up
ip link set eth1.H20 up

#set up OSPFD
sysctl net.ipv4.ip_forward=1
sed -i 's/zebra=no/zebra=yes/g' /etc/frr/daemons
sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
service frr restart
vtysh -c 'configure terminal' -c 'interface eth2' -c 'ip ospf area 0.0.0.0'
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'
