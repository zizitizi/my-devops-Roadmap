

### https://forums.docker.com/t/adding-a-new-nic-to-a-docker-container-in-a-specific-order/19173/3



 There are 2 solutions to do this: First is the one almost detailed completely here, but it do works with current docker releases - complete tutorial can be found here docker hub forum

Solution 2 is to do everything in the rock-bottom layer. I have included the details comment section of the link above, which I also copy here:

Since docker is also using linux’s networking namespaces you can do this in the rock-bottom layer as well. Unfortunately, Docker tries to hide this from the user, but the namespaces are still existing under the hood. In order to get them to be managed by ip netns tool, do the following:

get the process id (pid) of your running container:
$ sudo docker inspect -f '{{.State.Pid}}' <container name>

<container name> is not your label:tag name, it is the name that docker automatically assign to it once a container is fired up - get yours via docker ps command and look for the last column (NAME).

create a symlink from the /proc/ filesystem to /var/run/ 2.1. First, create a netns directory in /var/run/ $ sudo mkdir -p /var/run/netns
2.2. Using the PID you have just obtained, create the symlink $ sudo ln -sf /proc/<PID>/ns/net /var/run/netns/<YOUR DESIRED NETNS NAME FOR YOU CONTAINER>

Now, if you execute ip netns list, you will see the networking namespace of your container.

From now on, there is no docker specific stuffs, just create a veth pair, bring them up, and attach one end of it to the container and you are fine: $ sudo ip link add veth1_container type veth peer name veth1_root

$ sudo ifconfig veth1_container up

$ sudo ifconfig veth1_root up

$ sudo ip link set veth1_container netns <YOUR NETNS NAME>

$ sudo ip netns exec <YOUR NETNS NAME> ifconfig veth1_container up

The last command might be a bit overcomplicated, but it seemed that bringing up this interface natively in the container is not possible due to missing permissions :)

Note that the MAC address could also be changed in the same way I have shown in solution 1, before attaching it to the container, or after - does not really matter, just different commands need to be used (recall the permission issue just mentioned above).

I hope it helps.








