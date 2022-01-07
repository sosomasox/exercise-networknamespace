#!/bin/bash 

sudo ip netns add server11
sudo ip netns add router1
sudo ip netns add router2
sudo ip netns add server21
sudo ip netns add server22
sudo ip netns add bridge2

sudo ip link add server11-veth0 type veth peer name router1-veth0
sudo ip link add router1-veth1  type veth peer name router2-veth1
sudo ip link add router2-veth0  type veth peer name router2-br2
sudo ip link add server21-veth0 type veth peer name server21-br2
sudo ip link add server22-veth0 type veth peer name server22-br2

sudo ip link set server11-veth0 netns server11
sudo ip link set router1-veth0  netns router1
sudo ip link set router1-veth1  netns router1
sudo ip link set router2-veth0  netns router2
sudo ip link set router2-veth1  netns router2
sudo ip link set server21-veth0 netns server21
sudo ip link set server22-veth0 netns server22
sudo ip link set router2-br2    netns bridge2
sudo ip link set server21-br2   netns bridge2
sudo ip link set server22-br2   netns bridge2

sudo ip netns exec server11 ip link set server11-veth0 up
sudo ip netns exec router1  ip link set router1-veth0  up
sudo ip netns exec router1  ip link set router1-veth1  up
sudo ip netns exec router2  ip link set router2-veth0  up
sudo ip netns exec router2  ip link set router2-veth1  up
sudo ip netns exec server21 ip link set server21-veth0 up
sudo ip netns exec server22 ip link set server22-veth0 up
sudo ip netns exec bridge2  ip link set router2-br2    up
sudo ip netns exec bridge2  ip link set server21-br2   up
sudo ip netns exec bridge2  ip link set server22-br2   up

sudo ip netns exec server11 ip address add 192.0.1.1/24   dev server11-veth0
sudo ip netns exec router1  ip address add 192.0.1.254/24 dev router1-veth0
sudo ip netns exec router1  ip address add 10.0.0.1/24    dev router1-veth1
sudo ip netns exec router2  ip address add 192.0.2.254/24 dev router2-veth0
sudo ip netns exec router2  ip address add 10.0.0.2/24    dev router2-veth1
sudo ip netns exec server21 ip address add 192.0.2.1/24   dev server21-veth0
sudo ip netns exec server22 ip address add 192.0.2.2/24   dev server22-veth0

sudo ip netns exec server11 ip route add default via 192.0.1.254
sudo ip netns exec router1  ip route add 192.0.2.0/24 via 10.0.0.2
sudo ip netns exec router2  ip route add 192.0.1.0/24 via 10.0.0.1
sudo ip netns exec server21 ip route add default via 192.0.2.254
sudo ip netns exec server22 ip route add default via 192.0.2.254

sudo ip netns exec router1 sysctl net.ipv4.ip_forward=1 > /dev/null
sudo ip netns exec router2 sysctl net.ipv4.ip_forward=1 > /dev/null

sudo ip netns exec bridge2 ip link add dev br2 type bridge
sudo ip netns exec bridge2 ip link set br2 up
sudo ip netns exec bridge2 ip link set router2-br2  master br2
sudo ip netns exec bridge2 ip link set server21-br2 master br2
sudo ip netns exec bridge2 ip link set server22-br2 master br2

exit 0
