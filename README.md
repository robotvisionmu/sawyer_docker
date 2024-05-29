# Sawyer Docker
Docker image definition for working with Rethink Sawyer SDK.

## Setup and usage
To use the container you should clone the repo and then run
`./build_full.sh`
from the root folder.

This will build a docker image called `sawyer-intel`.

To start the container run the
`./launch_full.sh`
command from the root folder.

This will start the container in daemon mode and launch a `terminator` window.

The container will launch using your UID and GID and include a home folder using your username. The parent folder to the `sawyer_docker` folder on your host system will be mounted into the container filesystem at `/home/$USER/ros_sawyer`. 

As part of the `build_full.sh` script a `ros_ws` workspace folder will be created as a sibling to `sawyer_docker`. The folder will therefore be accessible on your host system and within the container at `/home/$USER/ros_sawyer/ros_ws`.

The resulting folder hierarchy will look like this: 

```
home 
└ USER  
 └ ros_sawyer  
  ├ ros_ws 
  └ sawyer_docker
 ``` 

The `.bashrc` file in the home folder will source the system ROS and `ros_ws` `setup.bash` scripts, so the full set of packages will be accessible by default.

To add new packages it is recommended that they be placed in `/home/$USER/ros_sawyer/ros_ws/src/` since this will mean they are included as part of the `ros_ws` workspace and so avoid having to add new `souce` lines the `.bashrc`.

### Testing the setup
To test the setup, start by launching the image
```./launch_full.sh```

From the `terminator` prompt run the following commands:
```
$ cd ros_ws
$ ./intera.sh sim
$ roslaunch sawyer_sim_examples sawyer_pick_and_place_demo.launch
```
## Connecting to a physical robot

⚠️Ensure that you've read the SDK documentation and robot documentation on safe usage of the robot first. Ensure that the emergency stop is outside the operating volume. Ensure that you stay outside the operating volume of the robot unless absolutely necessary. Always ensure your code/setup works in simulation before trying on the physical robot. Generally, operate programmes at slow speed before operating at normal/faster speed.

Boot up the robot in SDK mode. It takes a few minutes (displaying closed eyes) and should eventually show a "Sawyer SDK" screen. When this screen appears it should be ready for use. (If the robot is not in SDK mode it then it needs to be switched to SDK mode - TODO.)

When connecting to a physical robot you will need to ensure that the docker container resolves .local addresses correctly. On my Ubuntu 20.04 system this requires ensuring the systemd.resolve has multicast DNS switched on on the ethernet port that you are connecting via.

To check your system you can running the following command:
```
systemd-resolve --status
```
and then look for the relevant interface setting.

To manually turn the setting on you can use the following command:
```
systemd-resolve --set-mdns=yes --interface=<<ETHERNET_INTERFACE_NAME>>
```

To set this up to automatically switch on you should place a NetworkManager dispatcher script in `/etc/NetworkManager/dispatcher.d/`. See [the following article for more details](https://askubuntu.com/questions/1111652/network-manager-script-when-interface-up).

Below is an example script. Save it in the above folder e.g. as `mdns-on-eth`, ensuring that you make it executable (i.e. `sudo chmod +x mdns-on-eth`)
```
#!/usr/bin/env bash

interface=$1
event=$2

if [[ $interface != "<<ETHERNET_INTERFACE_NAME>>" ]] || [[ $event != "up" ]]
then
  return 0
fi

echo "setting mdns=on on interface=$interface" | systemd-cat -p info -t dispatch_script
systemd-resolve --set-mdns=yes --interface=<<ETHERNET_INTERFACE_NAME>>
```

To test your setup you should unplug and plug in your ethernet cable to your Sawyer robot. Ensure that you can ping the robot from your host terminal using the robot's .local hostname i.e. `ROBOTSERIALNO.local` (where ROBOTSERIAL is read from the back of the Sawyer control computer chassis). Then launch the docker container (i.e.`./launch_full.sh`). From inside your container you should then try to ping your robot using its `ROBOTSERIALNO.local` hostname.

### Configure `intera.sh`
Finally, you will need to add your robot name and hostname to the `intera.sh` script. You will find this in the `ros_ws` folder. Edit it and set both the `robot_hostname` and `your_hostname` variables to the specifics of your system. 

### Testing the setup
To test the setup for connecting to a physical robot, start by launching the image
```./launch_full.sh```

From the `terminator` prompt run the following commands:
```
$ cd ros_ws
$ ./intera.sh 
$ rosrun intera_examples head_wobbler.py
``` 
## Going further
Once you have everything setup you can take a look at the [Sawyer documentation](https://support.rethinkrobotics.com/support/solutions) for more information.


