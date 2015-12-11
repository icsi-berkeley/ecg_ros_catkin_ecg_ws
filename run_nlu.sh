#!/bin/bash
# Set path where the workspace is located
export ROS_ECGDEMO_WS_PATH=/home/nao/ros_catkin_ecg_ws
cd ~
# Start gazebo
gnome-terminal --geometry=10x5 --tab -e "bash -c 'roslaunch darwin_gazebo indoor_darwin_gazebo.launch'" 
sleep 10
gnome-terminal --geometry=60x20 --tab -e "bash -c 'rosrun ros_cqi run_interface.py'"
sleep 5
gnome-terminal --geometry=60x20 --tab -e "bash -c 'cd $ROS_ECGDEMO_WS_PATH/src/ros_ecgworkbench/scripts && rosrun ros_ecgworkbench run_nlu.py'" 


