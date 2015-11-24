#! /bin/bash
gnome-terminal -e '/bin/bash -c "roslaunch darwin_gazebo darwin_gazebo.launch"' & 
sleep 10
gnome-terminal -e '/bin/bash -c "rosrun cqi_ros run_interface.py"' & 
sleep 5
gnome-terminal -e '/bin/bash -c "rosrun ros_ecgworkbench run_nlu.py"' 


