#!/bin/bash
grep ^nameserver /etc/resolv.conf > sawyer-intel/resolv_append

BUILD_ARGS="--build-arg USER=`whoami` --build-arg UID=`id -u` --build-arg GID=`id -g`"

docker build $BUILD_ARGS -t sawyer-intel sawyer-intel

echo "Running script"

./run_command.sh -i /home/$USER/ros_sawyer/sawyer_docker/workstation_setup.sh
