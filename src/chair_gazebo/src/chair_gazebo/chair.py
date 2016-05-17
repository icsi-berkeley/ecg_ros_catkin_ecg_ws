import random
from threading import Thread
import math
import rospy
import time
from std_msgs.msg import Float64
from sensor_msgs.msg import JointState
from geometry_msgs.msg import Twist

class WheelChair:
    """
    Client ROS class for manipulating WheelChair in Gazebo
    """

    def __init__(self, ns = '/chair/'):
    	self.ns=ns
        self.joints=None
        self.angles=None
        
        self._sub_joints=rospy.Subscriber(ns+"joint_states",JointState,self._cb_joints,queue_size=1)
        
        rospy.sleep(1)
        
        self._pub_cmd_vel=rospy.Publisher(ns+"cmd_vel",Twist)

    def set_velocity(self,x,y,t):
        msg=Twist()
        msg.linear.x=x
        msg.linear.y=y
        msg.angular.z=t
        self._pub_cmd_vel.publish(msg)

    def _cb_joints(self,msg):
        if self.joints is None:
            self.joints=msg.name
        self.angles=msg.positions