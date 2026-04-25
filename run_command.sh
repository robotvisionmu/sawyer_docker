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

# Add DNS servers from host if available (excluding loopback)
DNS_ARGS=""
if [ -f "$SCRIPT_DIR/sawyer-intel/resolv_append" ]; then
    while read -r line; do
        if [[ $line =~ ^nameserver\ ([^ ]+) ]]; then
            ns="${BASH_REMATCH[1]}"
            if [[ $ns != 127.* ]]; then
                DNS_ARGS="$DNS_ARGS --dns $ns"
            fi
        fi
    done < "$SCRIPT_DIR/sawyer-intel/resolv_append"
fi

docker run $DAEMON --rm \
	--net=${NETWORK:-robot_net} \
	$DNS_ARGS \
	--privileged \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	-e DISPLAY \
	-v /dev:/dev \
	-v /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket \
	--workdir="/home/$USER/ros_sawyer" \
	--volume="$ROS_SAWYER_DIR:/home/$USER/ros_sawyer" \
	--user $UID:$GID \
	--volume="/etc/group:/etc/group:ro" \
	--volume="/etc/passwd:/etc/passwd:ro" \
	--volume="/etc/shadow:/etc/shadow:ro" \
	--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
	--name='ros' sawyer-intel:latest "$@"

