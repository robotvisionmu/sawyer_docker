#!/bin/bash 
xhost +local:`whoami`

./run_command.sh -d terminator

xhost -local:`whoami`
