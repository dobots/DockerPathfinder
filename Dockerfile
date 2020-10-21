FROM osrf/ros:melodic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN git clone https://github.com/osrf/gzweb.git
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update
RUN apt-get remove modemmanager -y
RUN apt-get install -y less nodejs libjansson-dev libboost-dev imagemagick libtinyxml-dev mercurial git genromfs ninja-build exiftool astyle xxd python-argparse python-toml python-pip python-rosinstall-generator
RUN pip install --upgrade pip
RUN pip install pandas jinja2 pyserial pyyaml pyulog 
RUN apt-get install -y ant openjdk-8-jdk openjdk-8-jre
RUN apt-get install -y ros-melodic-navigation ros-melodic-hector-slam ros-melodic-teb-local-planner ros-melodic-teleop-twist-keyboard
RUN apt-get install -y geographiclib-tools gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl libgstreamer-plugins-base1.0-dev

# Download and build MAVROS:
COPY build_mavros.sh .
RUN /build_mavros.sh

RUN mkdir PX4
WORKDIR PX4
RUN git clone https://github.com/PX4/Firmware.git

WORKDIR /
# Install FastRTPS 1.7.1 and FastCDR-1.0.8
RUN wget https://www.eprosima.com/index.php/component/ars/repository/eprosima-fast-dds/eprosima-fast-rtps-1-7-2/eprosima_fastrtps-1-7-2-linux-tar-gz?format=raw -O eprosima_fastrtps-1-7-2-linux.tar.gz
RUN tar -xzf eprosima_fastrtps-1-7-2-linux.tar.gz eProsima_FastRTPS-1.7.2-Linux
RUN tar -xzf eprosima_fastrtps-1-7-2-linux.tar.gz requiredcomponents
RUN tar -xzf requiredcomponents/eProsima_FastCDR-1.0.8-Linux.tar.gz

RUN cd eProsima_FastCDR-1.0.8-Linux && ./configure --libdir=/usr/lib && make -j4 && make install
RUN cd eProsima_FastRTPS-1.7.2-Linux && ./configure --libdir=/usr/lib && make -j4 && make install
RUN rm -rf requiredcomponents eprosima_fastrtps-1-7-2-linux.tar.gz

WORKDIR /PX4/Firmware
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install toml empy numpy pyros-genmsg jinja2 packaging pyserial pyyaml pyulog
RUN DONT_RUN=1 make px4_sitl gazebo

WORKDIR /root/
RUN wget https://s3-us-west-2.amazonaws.com/qgroundcontrol/latest/QGroundControl.AppImage -O QGroundControl.AppImage
RUN chmod +x ./QGroundControl.AppImage
#RUN ./QGroundControl.AppImage --appimage-extract-and-run

RUN apt-get install -y ros-melodic-ar-track-alvar ros-melodic-jsk-rviz-plugins
RUN apt-get install -y nano

RUN catkin_ws/src/mavros/mavros/scripts/install_geographiclib_datasets.sh

#WORKDIR /gzweb
#RUN  . /usr/share/gazebo/setup.sh; ./deploy.sh -m

COPY demo_setup.sh .
COPY launch_demo_script.sh .
COPY launch_demo.sh .

EXPOSE 8080

