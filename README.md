# Sawyer Docker
Docker container definition for working with Rethink Sawyer SDK.

## Setup and usage
To use the container you should clone the repo and then run
`./build_full.sh`
from the root folder.

This will build a docker image called `sawyer-intel`.

To start the container run the
`./launch_full.sh'
command from the root folder.

This will start the container in daemon mode and launch a `terminator` window.

The container will create a home folder with your username and launch using your UID and GID. The parent folder to the `sawyer_docker` folder will be mounted into the container filesystem at `/home/$USER/ros_sawyer`. 

As part of the `build_full.sh` script a `ros_ws` workspace folder will be created as a sibling to `sawyer_docker`. The folder will therefore be accessible on your host system and within the container at `/home/$USER/ros_sawyer/ros_ws`.

