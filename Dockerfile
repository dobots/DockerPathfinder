FROM osrf/ros:melodic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


RUN git clone https://github.com/osrf/gzweb.git
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt install -y nodejs libjansson-dev libboost-dev imagemagick libtinyxml-dev mercurial
WORKDIR /gzweb
RUN  . /usr/share/gazebo/setup.sh; ./deploy.sh -m
EXPOSE 8080
