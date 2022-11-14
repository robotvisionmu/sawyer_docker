#!/bin/bash 
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROS_SAWYER_DIR="$SCRIPT_DIR/.."

DAEMON="-d"

while getopts i:t: flag
do
    case "${flag}" in
        i) 
            DAEMON="-it"
            shift 1;;
    esac
done

docker run $DAEMON --rm \
--network host --privileged \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
-e DISPLAY \
-v /dev:/dev \
--workdir="/home/$USER/ros_sawyer" \
--volume="$ROS_SAWYER_DIR:/home/$USER/ros_sawyer" \
--user $UID:$GID \
--volume="/etc/group:/etc/group:ro" \
--volume="/etc/passwd:/etc/passwd:ro" \
--volume="/etc/shadow:/etc/shadow:ro" \
--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
--name='ros' sawyer-intel:latest "$@"

