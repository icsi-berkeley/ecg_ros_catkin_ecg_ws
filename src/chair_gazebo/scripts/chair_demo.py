#!/usr/bin/env python

import rospy
from chair_gazebo.chair import WheelChair


if __name__=="__main__":
    rospy.init_node("wheelchair_demo")
    
    rospy.loginfo("Instantiating WheelChair Client")
    chair=WheelChair()
    rospy.sleep(1)
    
    rospy.loginfo("WheelChair Demo Starting")

    chair.set_velocity(1,0,0.3)
    rospy.sleep(5)
    chair.set_velocity(0,0,0)
    rospy.sleep(3)
    chair.set_velocity(-1,0,-0.3)
    rospy.sleep(5)
    chair.set_velocity(0,0,0)
    rospy.sleep(3)
    chair.set_velocity(0,0,0.5)
    rospy.sleep(12)
    chair.set_velocity(0,0,0)
    rospy.sleep(3)
    chair.set_velocity(0,0,-0.5)
    rospy.sleep(12)
    chair.set_velocity(0,0,0)
    
    rospy.loginfo("Demo Finished")