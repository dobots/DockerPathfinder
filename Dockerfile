FROM osrf/ros:melodic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


RUN git clone https://github.com/osrf/gzweb.git
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update
RUN apt-get install -y nodejs libjansson-dev libboost-dev imagemagick libtinyxml-dev mercurial
RUN apt-get install -y ros-melodic-navigation ros-melodic-hector-slam ros-melodic-teb-local-planner
WORKDIR /gzweb
RUN  . /usr/share/gazebo/setup.sh; ./deploy.sh -m
EXPOSE 8080
