# ros_catkin_ecg_ws
The ROS workspace to run ECG workbench demos. This is basically a wrapper GIT repository to collect all required repositories as submodules for running the ECG workbench demos. All code is supposed to run under ROS indigo.

* Installation under MacOS (Yosemite El Capitan) *
Followed the instructions at http://wiki.ros.org/indigo/Installation/OSX/Homebrew/Source

Everything went well until 

rosdep install --from-paths src --ignore-src --rosdistro indigo -y

Error:
rosdep install --from-paths src --ignore-src --rosdistro indigo -y
executing command [brew install gazebo]
==> Installing gazebo1 from osrf/homebrew-simulation
ogre: XQuartz is required to install this formula.
You can install with Homebrew Cask:
  brew install Caskroom/cask/xquartz

You can download from:
  https://xquartz.macosforge.org
Error: An unsatisfied requirement failed this build.
ERROR: the following rosdeps failed to install
  homebrew: command [brew install gazebo] failed


Solution:
1) Install xquartz using 
brew install Caskroom/cask/xquartz
2) 