FROM ros:melodic-perception

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

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
python-rosdep \
python-rosinstall \
python-rosinstall-generator \
python-wstool \
build-essential \
git-core \
python-argparse \
python-vcstools \
python-pip \
ros-${ROS_DISTRO}-control-msgs \
ros-${ROS_DISTRO}-joystick-drivers \
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
COPY ./config.yaml /home/$USER/.ignition/fuel/

RUN bash -c "chmod +x /ros_entrypoint.sh"

RUN echo source "/opt/ros/$ROS_DISTRO/setup.bash" >> /home/$USER/.bashrc
RUN echo "if [ -f /home/$USER/ros_sawyer/ros_ws/devel/setup.bash ]; then source /home/$USER/ros_sawyer/ros_ws/devel/setup.bash; fi" >> /home/$USER/.bashrc

ENTRYPOINT ["/ros_entrypoint.sh"]
