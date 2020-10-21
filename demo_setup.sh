#!/bin/bash

cd ~/catkin_ws
. devel_isolated/setup.bash

export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/projects/bart_drones/ros_packages/px4_based:/projects/comp4drones_project
cd /PX4/Firmware
source Tools/setup_gazebo.bash $PWD $PWD/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd):$(pwd)/Tools/sitl_gazebo

cd /projects/comp4drones_project/
roslaunch fire_station_description bringup_uav_rover.launch

