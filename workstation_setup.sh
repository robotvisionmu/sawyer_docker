#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROS_SAWYER_DIR="$SCRIPT_DIR/.."

source /opt/ros/$ROS_DISTRO/setup.bash

mkdir -p $ROS_SAWYER_DIR/ros_ws/src
cd $ROS_SAWYER_DIR/ros_ws/src
wstool init .

git clone https://github.com/RethinkRobotics/sawyer_robot.git
wstool merge sawyer_robot/sawyer_robot.rosinstall
wstool update

wstool merge https://raw.githubusercontent.com/RethinkRobotics/sawyer_moveit/melodic_devel/sawyer_moveit.rosinstall
wstool update

git clone https://github.com/RethinkRobotics/sawyer_simulator.git
git clone https://github.com/RethinkRobotics-opensource/sns_ik.git -b melodic-devel

wstool merge sawyer_simulator/sawyer_simulator.rosinstall
wstool update

cd $ROS_SAWYER_DIR/ros_ws
catkin_make

cp $ROS_SAWYER_DIR/ros_ws/src/intera_sdk/intera.sh $ROS_SAWYER_DIR/ros_ws

# set the ros_version
sed -i "s/ros_version=.*/ros_version=$ROS_DISTRO/" intera.sh

echo "source $ROS_SAWYER_DIR/ros_ws/devel/setup.bash" >> /home/john/.bashrc
