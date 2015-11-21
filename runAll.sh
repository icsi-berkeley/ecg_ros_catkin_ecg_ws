#! /bin/bash
roslaunch darwin_gazebo darwin_gazebo.launch & 
rosrun ros_cqi run_interface.py & 
rosrun ros_ecgworkbench run_nlu.py & 


