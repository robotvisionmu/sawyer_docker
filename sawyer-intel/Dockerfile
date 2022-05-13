FROM ros:noetic-perception

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    terminator \
    vim \
    net-tools \
    iputils-ping \
    pip \
    && rm -rf /var/lib/apt/lists/*

# From https://sdk.rethinkrobotics.com/intera/Workstation_Setup
RUN apt-get update && apt-get install --no-install-recommends -y \
git-core \
python3-wstool \
python3-vcstools \
python3-rosdep \
ros-${ROS_DISTRO}-control-msgs \
ros-${ROS_DISTRO}-xacro \
ros-${ROS_DISTRO}-tf2-ros \
ros-${ROS_DISTRO}-rviz \
ros-${ROS_DISTRO}-cv-bridge \
ros-${ROS_DISTRO}-actionlib \
ros-${ROS_DISTRO}-actionlib-msgs \
ros-${ROS_DISTRO}-dynamic-reconfigure \
ros-${ROS_DISTRO}-trajectory-msgs \
ros-${ROS_DISTRO}-rospy-message-converter\
&& rm -rf /var/lib/apt/lists/*

RUN pip install argparse

RUN apt-get update && apt-get install --no-install-recommends -y \
ros-${ROS_DISTRO}-gazebo-* \
ros-${ROS_DISTRO}-ros-control \
ros-${ROS_DISTRO}-control-toolbox \
ros-${ROS_DISTRO}-realtime-tools \
ros-${ROS_DISTRO}-ros-controllers \
ros-${ROS_DISTRO}-tf-conversions \
ros-${ROS_DISTRO}-kdl-parser \
ros-${ROS_DISTRO}-moveit \
&& rm -rf /var/lib/apt/lists/*

ARG USER=ros
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID -o $USER
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $USER

RUN git clone https://github.com/osrf/gazebo_models /home/$USER/.gazebo/models
RUN chown -R $USER:$USER /home/$USER/.gazebo

# setup entrypoint
COPY ./ros_entrypoint.sh /

RUN bash -c "chmod +x /ros_entrypoint.sh"

ENTRYPOINT ["/ros_entrypoint.sh"]
