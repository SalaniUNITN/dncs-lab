# DNCS-LAB assigment by Nicola Arnoldi

A.Y. 2018/19  
This repository contains the Vagrant files required to run the network.


## Table of contents

-   [Network map](#network-map)
-   [Network configuration](#network-configuration)
    -   [Subnets](#subnets)
    -   [VLANs](#vlans)
    -   [Interface-IP mapping](#interface-ip-mapping)
-   [Reachability](#reachability)
-   [Web Server](#web-server)
-   [How-to](#how-to)

## Network map

         +------------------------------------------------------------+
         |                                                        eth0|
     +---+---+                  +------------+                 +------+-----+
     |       |                  |            |                 |            |
     |       +------------------+  router-1  +-----------------+  router-2  |
     |   v   |              eth0|            |eth2         eth2|            |
     |   a   |                  +-----+------+                 +------+-----+
     |   g   |                        |eth1                       eth1|
     |   r   |                        |                               |
     |   a   |                        |                           eth1|
     |   n   |                        |eth1                     +-----+----+
     |   t   |             +----------+-----------+             |          |
     |       |             |                      |             |          |
     |   m   +-------------+        switch        |             | host-2-c |
     |   a   |         eth0|                      |             |          |
     |   n   |             +---+--------------+---+             |          |
     |   a   |                 |eth2      eth3|                 +-----+----+
     |   g   |                 |              |                   eth0|
     |   e   |                 |              |                       |
     |   m   |                 |eth1      eth1|                       |
     |   e   |           +-----+----+    +----+-----+                 |
     |   n   |           |          |    |          |                 |
     |   t   |           |          |    |          |                 |
     |       +-----------+ host-1-a |    | host-1-b |                 |
     |       |       eth0|          |    |          |                 |
     |       |           |          |    |          |                 |
     +--+-+--+           +----------+    +----+-----+                 |
        | |                               eth0|                       |
        | +-----------------------------------+                       |
        +-------------------------------------------------------------+

## Network configuration

### Subnets
| Subnet | Devices (Interface)                   | Network address   | Netmask         | # avaible IPs for the hosts              |
| ------ | ------------------------------------- | ----------------- | --------------- | ----------------------- |
| A      | router-1 (eth1.10)<br>host-1-a (eth1) | 172.27.1.0/24     | 255.255.255.0   |      [2<sup>32-24</sup>-2]=254 |
| B      | router-1 (eth1.20)<br>host-1-b (eth1) | 172.27.2.224/27   | 255.255.255.224 |      [2<sup>32-27</sup>-2]=30  |
| C      | router-2 (eth1)<br>host-2-c (eth1)    | 172.27.3.252/30   | 255.255.255.252 |      [2<sup>32-30</sup>-2]=2   |
| D      | router-1 (eth2)<br>router-2 (eth2)    | 172.31.255.252/30 | 255.255.255.252 |      [2<sup>32-30</sup>-2]=2   |

### VLANs

The newtork has only one connection between [_router-1_] and [_switch_], the use of virtual LANs is necessary. So we set up 2 VIDs for network A and B.

                 +------------+
                 |            |                
                 +  router-1  +
                 |            |        
                 +-----+------+          +--------------+       
                       |eth1             | VID | Subnet |
                       |                 | --- | ------ |
                       |                 |  10 | A      |
                       |                 |  20 | B      |   
                       |                 +--------------+            
                       |                         
                       |eth1                   
            +----------+-----------+         
            |                      |           
            +        switch        |            
            |                      |          
            +---+--------------+---+



### Interface-IP mapping

We chose lower IP addresses for hosts and higher for routers.

| Device   | Interface | IP                  | Subnet | VLAN VID  |
|:--------:|:---------:|:-------------------:|:------:|:---------:|
| host-1-a | `eth1`    | `172.27.1.1/24 `    | A      |   --      |
| router-1 | `eth1.10` | `172.27.1.254/24`   | A      |   10      |
| host-1-b | `eth1`    | `172.27.2.225/27`   | B      |   --      |
| router-1 | `eth1.20` | `172.27.2.254/27`   | B      |   20      |
| host-2-c | `eth1`    | `172.27.3.253/30`   | C      |    --     |
| router-2 | `eth1`    | `172.27.3.254/30`   | C      |    --     |
| router-1 | `eth2`    | `172.31.255.253/30` | D      |    --     |
| router-2 | `eth2`    | `172.31.255.254/30` | D      |    --     |

## Vagrant and devices configuration


In order to create and configure the network devices, in [Vagrantfile](/Vagrantfile) were introduced some lines as follow:

```ruby
config.vm.define "router-1" do |routera|
  ...
end
config.vm.define "router-2" do |router2|
  ...
end
config.vm.define "switch" do |switch|
  ...
end
config.vm.define "host-1-a" do |host1a|
  ...
end
config.vm.define "host-1-b" do |host1b|
  ...
end
config.vm.define "host-2-c" do |host2c|
  ...
end
```


## Reachability

To test the reachability of the web server, you can ping any machine from any other, for example:

-A) to ping _host-1-b_ from _host-1-a_: `ping 172.27.2.225`

-B) to ping _host-2-c_ from _host-1-a_: `ping 172.27.3.253`

and expect the following result:

A)`PING 172.27.2.225 (172.27.2.225) 56(84) bytes of data.
64 bytes from 172.27.2.225: icmp_seq=1 ttl=63 time=4.57 ms
...`

B)`PING 172.27.3.253 (172.27.3.253) 56(84) bytes of data.
64 bytes from 172.27.3.253: icmp_seq=1 ttl=62 time=1.73 ms
...`


the same you can do it with all the other hosts.

## Web Server
To test the web server on host-2-c, we just need to download a simple index page, writing the command written below:

`curl 172.27.3.253`

The result it will be:
```html
<!DOCTYPE html>
<html>
<head>
<title>PAGE TEST HOST-2-C</title>
</head>
</html>
```

## How-to

- Install Virtualbox
- Install Vagrant
- Clone this repository

    ```bash
    ~$ git clone https://github.com/SalaniUNITN/dncs-lab.git
    ```

-   Then move into the repo (cd dncs-lab), finally run the command `vagrant up --provision` to create the virtual topology.
-   Finally to move on each host run the command: `vagrant host-1-a` (or host-1-b or host-2-c )
