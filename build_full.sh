#!/bin/bash
grep ^nameserver /etc/resolv.conf > sawyer-intel/resolv_append

BUILD_ARGS="--build-arg USER=`whoami` --build-arg UID=`id -u` --build-arg GID=`id -g`"

# 1. Dynamically find the Wi-Fi NIC
WIFI_IFACE=$(ls /sys/class/net | while read -r iface; do 
    if [ -d "/sys/class/net/$iface/wireless" ] || [ -d "/sys/class/net/$iface/phy80211" ]; then
        echo "$iface"
        break
    fi
done)

if [ -z "$WIFI_IFACE" ]; then
    echo "Error: Could not find a wireless interface."
    exit 1
fi

# 2. Re-create the network using the dynamic name
docker network rm robot_net 2>/dev/null || true

docker network create \
  --driver ipvlan \
  --subnet 192.168.2.0/24 \
  --gateway 192.168.2.1 \
  -o ipvlan_mode=l2 \
  -o parent=$WIFI_IFACE \
  robot_net

docker build $BUILD_ARGS -t sawyer-intel sawyer-intel

echo "Running script"

NETWORK=bridge ./run_command.sh -i /home/$USER/ros_sawyer/sawyer_docker/workstation_setup.sh
