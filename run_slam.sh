#!/bin/bash
# Set path where the workspace is located
export ROS_ECGDEMO_WS_PATH=/home/nao/ros_catkin_ecg_ws
cd ~
# Start gazebo
gnome-terminal --geometry=10x5 --tab -e "bash -c 'roslaunch darwin_gazebo indoor_darwin_gazebo.launch'" 
sleep 15
# Start slam
gnome-terminal --geometry=80x5 --tab -e "bash -c 'rosrun lsd_slam_core live_slam /image:=/darwin/camera/image_raw _calib:=$ROS_ECGDEMO_WS_PATH/config/cam_configs/darwin_cam.cfg'"
sleep 5
# Start slam viewer to visualize pointcloud
gnome-terminal --geometry=10x5 --tab -e "bash -c 'rosrun lsd_slam_viewer viewer'"
sleep 5
# Display slam pose
gnome-terminal --geometry=25x20 --tab -e "bash -c 'rostopic echo /lsd_slam/pose'"
sleep 5
# Start teleop for simple keyboard navigation
gnome-terminal --geometry=60x20 --tab -e "bash -c 'rosrun turtlebot_teleop turtlebot_teleop_key /turtlebot_teleop/cmd_vel:=/darwin/cmd_vel'"


