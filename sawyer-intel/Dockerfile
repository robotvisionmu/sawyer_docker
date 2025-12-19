FROM ros:noetic-perception

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 4B63CF8FDE49746E98FA01DDAD19BAB3CBF125EA

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    dbus-x11 \
    terminator \
    vim \
    net-tools \
    systemd-sysv \
    iputils-ping \
    libnss-mdns \
    && rm -rf /var/lib/apt/lists/*

# From https://sdk.rethinkrobotics.com/intera/Workstation_Setup
RUN apt-get update && apt-get install --no-install-recommends -y \
git-core \
python3-rosdep \
python3-rosinstall \
python3-rosinstall-generator \
python3-wstool \
build-essential \
git-core \
python3-vcstools \
python3-pip \
ros-${ROS_DISTRO}-control-msgs \
ros-${ROS_DISTRO}-xacro \
ros-${ROS_DISTRO}-tf2-ros \
ros-${ROS_DISTRO}-rviz \
ros-${ROS_DISTRO}-cv-bridge \
ros-${ROS_DISTRO}-actionlib \
ros-${ROS_DISTRO}-actionlib-msgs \
ros-${ROS_DISTRO}-dynamic-reconfigure \
ros-${ROS_DISTRO}-trajectory-msgs \
ros-${ROS_DISTRO}-rospy-message-converter \
ros-${ROS_DISTRO}-robot-state-publisher \
&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
ros-${ROS_DISTRO}-gazebo-* \
ros-${ROS_DISTRO}-ros-control \
ros-${ROS_DISTRO}-control-toolbox \
ros-${ROS_DISTRO}-realtime-tools \
ros-${ROS_DISTRO}-ros-controllers \
ros-${ROS_DISTRO}-tf-conversions \
ros-${ROS_DISTRO}-kdl-parser \
ros-${ROS_DISTRO}-moveit \
ros-${ROS_DISTRO}-roslint \
ros-${ROS_DISTRO}-librealsense* \
&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get dist-upgrade ros-noetic-rostime -y \
&& rm -rf /var/lib/apt/lists/*

#RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C8B3A55A6F3EFCDE
#RUN sudo mkdir -p /etc/apt/trusted.gpg.d
#RUN curl -sSf https://librealsense.intel.com/Debian/librealsense.pgp | sudo tee /etc/apt/trusted.gpg.d/librealsense.pgp &>/dev/null
#RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/librealsense.pgp] https://librealsense.intel.com/Debian/apt-repo `lsb_release -cs` main" | \
#sudo tee /etc/apt/sources.list.d/librealsense.list
#RUN apt-get update && apt-get install apt-transport-https librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg -y \
#&& rm -rf /var/lib/apt/lists/*


ARG USER=ros
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID -o $USER
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $USER

RUN git clone https://github.com/osrf/gazebo_models /home/$USER/.gazebo/models
RUN chown -R $USER:$USER /home/$USER/.gazebo

# setup entrypoint
COPY ./ros_entrypoint.sh /
COPY ./config.yaml /home/$USER/.ignition/fuel/

RUN bash -c "chmod +x /ros_entrypoint.sh"

RUN echo source "/opt/ros/$ROS_DISTRO/setup.bash" >> /home/$USER/.bashrc
RUN echo "if [ -f /home/$USER/ros_sawyer/ros_ws/devel/setup.bash ]; then source /home/$USER/ros_sawyer/ros_ws/devel/setup.bash; fi" >> /home/$USER/.bashrc
RUN echo 'PS1="[SAWYER] $PS1"' >> /home/$USER/.bashrc

ENTRYPOINT ["/ros_entrypoint.sh"]
