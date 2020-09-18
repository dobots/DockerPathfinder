#!/bin/bash


#check if there is a /build and /devel in the current PWD
if [ -f devel/.catkin ]; then
echo "Starting from Catkin Workspace: $PWD, making it available in '/projects' in the container."

sed -i 's/;\/projects\/src//' devel/.catkin
echo -n "`cat devel/.catkin`;/projects/src" > devel/.catkin

docker run -iPt \
    --rm \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$XAUTHORITY:$XAUTHORITY" \
    --env="XAUTHORITY=$XAUTHORITY" \
    --volume="$PWD:/projects" \
    --runtime=nvidia \
    --name="gazebo_test" \
    gazebo_test:latest \
    bash

else
echo "If you run this script from a built catkin workspace it will make that workspace available to the Docker container."

docker run -iPt \
    --rm \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$XAUTHORITY:$XAUTHORITY" \
    --env="XAUTHORITY=$XAUTHORITY" \
    --runtime=nvidia \
    --name="gazebo_test" \
    gazebo_test:latest \
    bash
fi



