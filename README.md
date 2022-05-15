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

To add new packages it is recommended that they be placed in `/home/$USER/ros_sawyer/ros_ws/src/` since this will mean they are includes as part of the `ros_ws` workspace and so avoid having to add new `souce` lines the `.bashrc`.

## Testing the setup
To test the setup, start by launching the image
```./launch_full.sh```

From the `terminator` prompt run the following commands:
```
$ ./intera.sh sim
$ roslaunch sawyer_sim_examples sawyer_pick_and_place_demo.launch
```


