#!/bin/bash
grep ^nameserver /etc/resolv.conf > sawyer-intel/resolv_append

BUILD_ARGS="--build-arg USER=`whoami` --build-arg UID=`id -u` --build-arg GID=`id -g`"

docker network create \
  --driver ipvlan \
  --subnet 192.168.1.0/24 \
  --gateway 192.168.1.1 \
  -o ipvlan_mode=l2 \
  -o parent=wlo1 \
  robot_net

docker build $BUILD_ARGS -t sawyer-intel sawyer-intel

echo "Running script"

./run_command.sh -i /home/$USER/ros_sawyer/sawyer_docker/workstation_setup.sh
