# exercise_networknamespace

## Set up

```
sh ./setup.sh
```


## Clean up

```
sh ./cleanup.sh
```


## Exercise

```
sudo ip netns exec server11 ping -c 3 192.0.2.1   -I 192.0.1.1
sudo ip netns exec server11 ping -c 3 192.0.2.2   -I 192.0.1.1
sudo ip netns exec server11 ping -c 3 192.0.1.254 -I 192.0.1.1

sudo ip netns exec server21 ping -c 3 192.0.1.1   -I 192.0.2.1
sudo ip netns exec server21 ping -c 3 192.0.2.2   -I 192.0.2.1
sudo ip netns exec server21 ping -c 3 192.0.2.254 -I 192.0.2.1

sudo ip netns exec server22 ping -c 3 192.0.1.1   -I 192.0.2.2
sudo ip netns exec server22 ping -c 3 192.0.2.1   -I 192.0.2.2
sudo ip netns exec server22 ping -c 3 192.0.2.254 -I 192.0.2.2

sudo ip netns exec router1 ping -c 3 10.0.0.2    -I 10.0.0.1
sudo ip netns exec router1 ping -c 3 192.0.2.254 -I 192.0.1.254

sudo ip netns exec router2 ping -c 3 10.0.0.1    -I 10.0.0.2
sudo ip netns exec router2 ping -c 3 192.0.1.254 -I 192.0.2.254
```
