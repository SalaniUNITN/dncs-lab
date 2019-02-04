export DEBIAN_FRONTEND=noninteractive

#Install docker
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes

# Set-up the ip add
ip addr add 172.27.3.253/30 dev eth1
ip link set eth1 up

ip route replace 172.16.0.0/12 via 172.27.3.254

# Create a sample index page
docker kill $(docker ps -q)
docker rm $(docker ps -aq)
docker run -dit --name webserver -p 80:80 -v /var/www/:/usr/local/apache2/htdocs/ httpd:2.4
mkdir -p /var/www
chmod +r /var/www
echo "<!DOCTYPE html>
<html>
<head>
<title>PAGE TEST HOST-2-C</title>
</head>
</html>" > /var/www/index.html
