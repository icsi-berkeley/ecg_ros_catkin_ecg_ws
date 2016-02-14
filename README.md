# ros_catkin_ecg_ws
The ROS workspace to run ECG workbench demos. This is basically a wrapper GIT repository to collect all required repositories as submodules for running the ECG workbench demos. All code is supposed to run under ROS indigo and tested with Ubuntu 14.04. Everything is tested with Python 2.7.X only, Python 3.X will probably not work. 

## Installation and Dependencies
The installation notes are based on the following tutorial for DARwin-OP:
http://www.generationrobots.com/en/content/83-carry-out-simulations-and-make-your-darwin-op-walk-with-gazebo-and-ros


Install prerequisites for the gazebo_darwin packages and do:

	sudo apt-get install git ros-indigo-desktop-full ros-indigo-gazebo-plugins ros-indigo-gazebo-ros ros-indigo-gazebo-ros-control ros-indigo-hector-gazebo ros-indigo-hector-gazebo-plugins ros-indigo-effort-controllers ros-indigo-joint-state-controller ros-indigo-joint-state-publisher ros-indigo-turtlebot-teleop 

Then clone this git repository. Its root folder is a new catkin workspace, which we assume to be ~/ros_catkin_ecg_ws. You'll execute most other commands in these instructions from there. 

Next, you need to initialize and update the submodules within this repository. The submodules contain the ROS code for the darwin robot and the ECG workbench. Cd into ~/ros_catkin_ecg_ws and do the following:
	
	cd ~/ros_catkin_ecg_ws
	git submodule update --init --recursive	
	
Make sure that you have checked out the py2 branch of ecg workbench:

	cd ~/ros_catkin_ecg_ws/src/ros_ecgworkbench
	git checkout py2

Now you need to build the workspace. Do this by 
	
	cd ~/ros_catkin_ecg_ws
	catkin_make
	catkin_make install

Next you need to source come setup file. We recommend to do this automatically by doing that in your .bashrc.

	echo "source ~/ros_catkin_ecg_ws/devel/setup.bash" >> ~/.bashrc
	source ~/.bashrc

To setup the indoor environment, we need to do some not very elegant things and copy a predefined indoor environment launch file for the darwin to the darwin_gazeob launch folder:

	cp config/launch_config/indoor_darwin_gazebo.launch src/darwin_gazebo/launch

Next we setup the ecg workbench stuff. Therefore, we go into its respective scripts directory and initialize everything. 

	cd ~/ros_catkin_ecg_ws/src/ros_ecgworkbench/scripts
	./nlu.sh

(TODO: This might give an error. However, the whole ecg stuff is actually only important for people working on it. Hence, for dealing only with the robot side, it is not required.)


## Starting Gazebo and Related Modules

Before starting gazebo the first time, I recommend downloading all 3d models for gazebo, since this speeds up the starting processes. To do so, execute the script (takes ~5 minutes, depending on your internet connection):

	./download_gazebo_models.sh

You can now start gazebo, which should bring up an indoor environment that we use for our experiments:

	roslaunch darwin_gazebo indoor_darwin_gazebo.launch

To have the robot walking, execute the test walking script that comes with darwin. I recommend to have a look at that script to see how the walking behaviour is executed. You can find it uner src/darwin_gazebo/src/. 

	rosrun darwin_gazebo walter_demo.py

To get started with our system, you'll want to start the CQI. Do so by entering:

	rosrun ros_cqi run_interface.py

Take a look at all files under the folder src/ros_cqi to understand how it works. 

To run the NLU system, start the ECG workbench first. 

rosrun ros_ecgworkbench run_nly.py

(TODO: This gives an error. Sean, could you work on that?)

Now, enter the following in the text input console which should have come up, to move the robot to coordinates 1 1:

	Robot1, move to location 1 1!


## Troubleshooting
If there are problems with gazebo, especially the downloading of the world models, try the following before starting it:

	export LC_NUMERIC=C

# Unsuccessful Partial Installation Protocol for ROS indigo under MacOS (Yosemite El Capitan) To be solved...
Followed the instructions at http://wiki.ros.org/indigo/Installation/OSX/Homebrew/Source

Everything went well until 

	rosdep install --from-paths src --ignore-src --rosdistro indigo -y

Got the following error:

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


Try to fix: by installing xquartz using 

	brew install Caskroom/cask/xquartz

Then the next error was:

			ERROR: the following rosdeps failed to install
			  homebrew: Failed to detect successful installation of [gazebo]
			  homebrew: Failed to detect successful installation of [graphviz]
			  homebrew: Failed to detect successful installation of [theora]

Try to fix by installing gazebo2
	
	brew install gazebo2

which resulted in the following output (symlink conflicts with gazebo1):

			==> Installing gazebo2 from osrf/homebrew-simulation
			==> Downloading http://gazebosim.org/distributions/gazebo/releases/gazebo-2.2.6.t
			==> Downloading from https://osrf-distributions.s3.amazonaws.com/gazebo/releases/
			######################################################################## 100.0%
			==> Downloading https://gist.githubusercontent.com/scpeters/9199370/raw/afe595587
			######################################################################## 100.0%
			==> Downloading https://bitbucket.org/osrf/gazebo/commits/91f6f3c59f40af34855548c
			######################################################################## 100.0%
			==> Patching
			patching file deps/opende/CMakeLists.txt
			patching file gazebo/gui/TimePanel.cc
			Hunk #1 succeeded at 118 (offset -60 lines).
			patching file gazebo/gui/TimePanel.hh
			Hunk #1 succeeded at 62 (offset -4 lines).
			==> cmake .. -DCMAKE_C_FLAGS_RELEASE= -DCMAKE_CXX_FLAGS_RELEASE= -DCMAKE_INSTALL_
			==> make install
			Error: The `brew link` step did not complete successfully
			The formula built, but is not symlinked into /usr/local
			Could not symlink bin/gazebo
			Target /usr/local/bin/gazebo
			is a symlink belonging to gazebo1. You can unlink it:
			  brew unlink gazebo1

			To force the link and overwrite all conflicting files:
			  brew link --overwrite gazebo2

			To list all files that would be deleted:
			  brew link --overwrite --dry-run gazebo2

			Possible conflicting files are:
			/usr/local/bin/gazebo -> /usr/local/Cellar/gazebo1/1.9.7/bin/gazebo
			/usr/local/bin/gzclient -> /usr/local/Cellar/gazebo1/1.9.7/bin/gzclient
			/usr/local/bin/gzfactory -> /usr/local/Cellar/gazebo1/1.9.7/bin/gzfactory
			/usr/local/bin/gzlog -> /usr/local/Cellar/gazebo1/1.9.7/bin/gzlog
			/usr/local/bin/gzmodel_create -> /usr/local/Cellar/gazebo1/1.9.7/bin/gzmodel_create
			/usr/local/bin/gzsdf -> /usr/local/Cellar/gazebo1/1.9.7/bin/gzsdf
			/usr/local/bin/gzserver -> /usr/local/Cellar/gazebo1/1.9.7/bin/gzserver
			/usr/local/bin/gzstats -> /usr/local/Cellar/gazebo1/1.9.7/bin/gzstats
			/usr/local/bin/gztopic -> /usr/local/Cellar/gazebo1/1.9.7/bin/gztopic
			/usr/local/share/gazebo/cmake/gazebo-config.cmake
			/usr/local/share/gazebo/setup.sh
			/usr/local/share/gazebo/cmake/gazebo-config.cmake
			/usr/local/share/gazebo/setup.sh
			/usr/local/lib/libgazebo.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo.dylib
			/usr/local/lib/libgazebo_ccd.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_ccd.dylib
			/usr/local/lib/libgazebo_common.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_common.dylib
			/usr/local/lib/libgazebo_gimpact.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_gimpact.dylib
			/usr/local/lib/libgazebo_gui.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_gui.dylib
			/usr/local/lib/libgazebo_gui_building.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_gui_building.dylib
			/usr/local/lib/libgazebo_gui_viewers.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_gui_viewers.dylib
			/usr/local/lib/libgazebo_math.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_math.dylib
			/usr/local/lib/libgazebo_msgs.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_msgs.dylib
			/usr/local/lib/libgazebo_ode.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_ode.dylib
			/usr/local/lib/libgazebo_opcode.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_opcode.dylib
			/usr/local/lib/libgazebo_opende_ou.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_opende_ou.dylib
			/usr/local/lib/libgazebo_physics.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_physics.dylib
			/usr/local/lib/libgazebo_physics_ode.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_physics_ode.dylib
			/usr/local/lib/libgazebo_rendering.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_rendering.dylib
			/usr/local/lib/libgazebo_selection_buffer.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_selection_buffer.dylib
			/usr/local/lib/libgazebo_sensors.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_sensors.dylib
			/usr/local/lib/libgazebo_skyx.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_skyx.dylib
			/usr/local/lib/libgazebo_transport.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_transport.dylib
			/usr/local/lib/libgazebo_util.dylib -> /usr/local/Cellar/gazebo1/1.9.7/lib/libgazebo_util.dylib
			/usr/local/lib/pkgconfig/gazebo.pc -> /usr/local/Cellar/gazebo1/1.9.7/lib/pkgconfig/gazebo.pc
			/usr/local/lib/pkgconfig/gazebo_ode.pc -> /usr/local/Cellar/gazebo1/1.9.7/lib/pkgconfig/gazebo_ode.pc
			/usr/local/lib/pkgconfig/gazebo_transport.pc -> /usr/local/Cellar/gazebo1/1.9.7/lib/pkgconfig/gazebo_transport.pc
			==> Summary
			🍺  /usr/local/Cellar/gazebo2/2.2.6: 769 files, 63M, built in 13.3 minutes
			----------

Postponed this problem and tried to install graphviz:

	brew install graphviz


That worked fine. Then did the rosdep install again:

	rosdep install --from-paths src --ignore-src --rosdistro indigo -y

The graphviz issue is resolved, now the error is:
			
			ERROR: the following rosdeps failed to install
			  homebrew: Failed to detect successful installation of [theora]
			  homebrew: Failed to detect successful installation of [gazebo]


Next, installed theora:

 	brew install theora

Then did the rosdep install again:

	rosdep install --from-paths src --ignore-src --rosdistro indigo -y

It went fine, now the error is:
			
			ERROR: the following rosdeps failed to install
			  homebrew: Failed to detect successful installation of [gazebo]

Getting back to the gazebo issue, I did 

	brew unlink gazebo1
	brew link --overwrite gazebo2

So that the system now uses gazebo2. Then I tried again:
	
	rosdep install --from-paths src --ignore-src --rosdistro indigo -y

With the same error:
			
			ERROR: the following rosdeps failed to install
			  homebrew: Failed to detect successful installation of [gazebo]


I assume that the error is not a big deal since gazebo2 and gazebo1 both installed successfully. So let's skip the gazebo test using the --skip-keys option and resolve the rest of the dependencies:

	rosdep install --from-paths src --ignore-src --rosdistro indigo -y --skip-keys gazebo

This resulted in:

			ERROR: the following rosdeps failed to install
			  homebrew: command [brew install pyqwt] failed


I did 

	brew install pyqwt

With the result:

	Warning: pyqwt-5.2.0 already installed

Since already installed I skip this key too, and try to resolve dependencies again. 

	rosdep install --from-paths src --ignore-src --rosdistro indigo -y --skip-keys gazebo pyqwt

Result:

	All required rosdeps installed successfully

Then I installed the catkin workspace with :
	
	./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release 



Then the following error occurred involving gazebo:

			==> Processing catkin package: 'gazebo_ros'
			==> Creating build directory: 'build_isolated/gazebo_ros'
			==> Building with env: '/Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh'
			==> cmake /Users/meppe/ROS/homebrew_catkin_ws/src/gazebo_ros_pkgs/gazebo_ros -DCATKIN_DEVEL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/gazebo_ros -DCMAKE_INSTALL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/install_isolated -DCMAKE_BUILD_TYPE=Release -G Unix Makefiles in '/Users/meppe/ROS/homebrew_catkin_ws/build_isolated/gazebo_ros'
			-- The C compiler identification is AppleClang 7.0.0.7000176
			-- The CXX compiler identification is AppleClang 7.0.0.7000176
			-- Check for working C compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc
			-- Check for working C compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc -- works
			-- Detecting C compiler ABI info
			-- Detecting C compiler ABI info - done
			-- Detecting C compile features
			-- Detecting C compile features - done
			-- Check for working CXX compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++
			-- Check for working CXX compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ -- works
			-- Detecting CXX compiler ABI info
			-- Detecting CXX compiler ABI info - done
			-- Detecting CXX compile features
			-- Detecting CXX compile features - done
			-- Using CATKIN_DEVEL_PREFIX: /Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/gazebo_ros
			-- Using CMAKE_PREFIX_PATH: /Users/meppe/ROS/homebrew_catkin_ws/install_isolated
			-- This workspace overlays: /Users/meppe/ROS/homebrew_catkin_ws/install_isolated
			-- Found PythonInterp: /usr/local/bin/python (found version "2.7.10") 
			-- Using PYTHON_EXECUTABLE: /usr/local/bin/python
			-- Using default Python package layout
			-- Found PY_em: /Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/em.pyc  
			-- Using empy: /Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/em.pyc
			-- Using CATKIN_ENABLE_TESTING: ON
			-- Call enable_testing()
			-- Using CATKIN_TEST_RESULTS_DIR: /Users/meppe/ROS/homebrew_catkin_ws/build_isolated/gazebo_ros/test_results
			-- Found gtest: gtests will be built
			-- Using Python nosetests: /Library/Frameworks/Python.framework/Versions/2.7/bin/nosetests-2.7
			-- catkin 0.6.16
			-- Using these message generators: gencpp;genlisp;genpy
			-- Found PkgConfig: /usr/local/bin/pkg-config (found version "0.29") 
			-- Checking for module 'libxml-2.0'
			--   Found libxml-2.0, version 2.9.0
			CMake Error at CMakeLists.txt:26 (find_package):
			  By not providing "Findgazebo.cmake" in CMAKE_MODULE_PATH this project has
			  asked CMake to find a package configuration file provided by "gazebo", but
			  CMake did not find one.

			  Could not find a package configuration file provided by "gazebo" with any
			  of the following names:

			    gazeboConfig.cmake
			    gazebo-config.cmake

			  Add the installation prefix of "gazebo" to CMAKE_PREFIX_PATH or set
			  "gazebo_DIR" to a directory containing one of the above files.  If "gazebo"
			  provides a separate development package or SDK, be sure it has been
			  installed.


			-- Configuring incomplete, errors occurred!
			See also "/Users/meppe/ROS/homebrew_catkin_ws/build_isolated/gazebo_ros/CMakeFiles/CMakeOutput.log".
			<== Failed to process package 'gazebo_ros': 
			  Command '['/Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh', 'cmake', '/Users/meppe/ROS/homebrew_catkin_ws/src/gazebo_ros_pkgs/gazebo_ros', '-DCATKIN_DEVEL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/gazebo_ros', '-DCMAKE_INSTALL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/install_isolated', '-DCMAKE_BUILD_TYPE=Release', '-G', 'Unix Makefiles']' returned non-zero exit status 1

			Reproduce this error by running:
			==> cd /Users/meppe/ROS/homebrew_catkin_ws/build_isolated/gazebo_ros && /Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh cmake /Users/meppe/ROS/homebrew_catkin_ws/src/gazebo_ros_pkgs/gazebo_ros -DCATKIN_DEVEL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/gazebo_ros -DCMAKE_INSTALL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/install_isolated -DCMAKE_BUILD_TYPE=Release -G 'Unix Makefiles'



Then I linked gazebo1 again instead of gazebo2

	brew unlink gazebo2
	brew link --overwrite gazebo1

I installed the catkin workspace again with :

	./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release 


Again an error occurred: 

			Checking for module 'libopenni'
			--   Package 'libopenni' not found
			-- Could NOT find openni (missing:  OPENNI_LIBRARY OPENNI_INCLUDE_DIRS) 
			** WARNING ** apps features related to openni will be disabled
			-- Found OpenGL: /System/Library/Frameworks/OpenGL.framework  
			CMake Error at /usr/local/share/pcl-1.8/PCLConfig.cmake:46 (message):
			  simulation is required but glew was not found
			Call Stack (most recent call first):
			  /usr/local/share/pcl-1.8/PCLConfig.cmake:645 (pcl_report_not_found)
			  /usr/local/share/pcl-1.8/PCLConfig.cmake:808 (find_external_library)
			  CMakeLists.txt:8 (find_package)


			-- Configuring incomplete, errors occurred!
			See also "/Users/meppe/ROS/homebrew_catkin_ws/build_isolated/pcl_ros/CMakeFiles/CMakeOutput.log".
			<== Failed to process package 'pcl_ros': 
			  Command '['/Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh', 'cmake', '/Users/meppe/ROS/homebrew_catkin_ws/src/perception_pcl/pcl_ros', '-DCATKIN_DEVEL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros', '-DCMAKE_INSTALL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/install_isolated', '-DCMAKE_BUILD_TYPE=Release', '-G', 'Unix Makefiles']' returned non-zero exit status 1

			Reproduce this error by running:
			==> cd /Users/meppe/ROS/homebrew_catkin_ws/build_isolated/pcl_ros && /Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh cmake /Users/meppe/ROS/homebrew_catkin_ws/src/perception_pcl/pcl_ros -DCATKIN_DEVEL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros -DCMAKE_INSTALL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/install_isolated -DCMAKE_BUILD_TYPE=Release -G 'Unix Makefiles'

			Command failed, exiting.				

Then I did :

	brew install openni

Then I did again:

	./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

The next error was 

			Checking for module 'libopenni2'
			--   Package 'libopenni2' not found
			-- Could NOT find OpenNI2 (missing:  OPENNI2_LIBRARY OPENNI2_INCLUDE_DIRS) 
			** WARNING ** visualization features related to openni2 will be disabled
			-- Could NOT find ensenso (missing:  ENSENSO_LIBRARY ENSENSO_INCLUDE_DIR) 
			** WARNING ** visualization features related to ensenso will be disabled
			-- Could NOT find DAVIDSDK (missing:  DAVIDSDK_LIBRARY DAVIDSDK_INCLUDE_DIR) 
			** WARNING ** visualization features related to davidSDK will be disabled
			-- Could NOT find DSSDK (missing:  _DSSDK_LIBRARIES) 
			** WARNING ** visualization features related to dssdk will be disabled
			-- Could NOT find RSSDK (missing:  _RSSDK_LIBRARIES) 
			** WARNING ** visualization features related to rssdk will be disabled
			CMake Error at /usr/local/share/pcl-1.8/PCLConfig.cmake:46 (message):
			  simulation is required but glew was not found
			Call Stack (most recent call first):
			  /usr/local/share/pcl-1.8/PCLConfig.cmake:645 (pcl_report_not_found)
			  /usr/local/share/pcl-1.8/PCLConfig.cmake:808 (find_external_library)
			  CMakeLists.txt:8 (find_package)


			-- Configuring incomplete, errors occurred!
			See also "/Users/meppe/ROS/homebrew_catkin_ws/build_isolated/pcl_ros/CMakeFiles/CMakeOutput.log".
			<== Failed to process package 'pcl_ros': 
			  Command '['/Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh', 'cmake', '/Users/meppe/ROS/homebrew_catkin_ws/src/perception_pcl/pcl_ros', '-DCATKIN_DEVEL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros', '-DCMAKE_INSTALL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/install_isolated', '-DCMAKE_BUILD_TYPE=Release', '-G', 'Unix Makefiles']' returned non-zero exit status 1

			Reproduce this error by running:
			==> cd /Users/meppe/ROS/homebrew_catkin_ws/build_isolated/pcl_ros && /Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh cmake /Users/meppe/ROS/homebrew_catkin_ws/src/perception_pcl/pcl_ros -DCATKIN_DEVEL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros -DCMAKE_INSTALL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/install_isolated -DCMAKE_BUILD_TYPE=Release -G 'Unix Makefiles'

			Command failed, exiting.


I did 

	brew install openni2

Then I did again:

	./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

The same error occurred:

			-- Checking for module 'libopenni2'
			--   Package 'libopenni2' not found
			-- Could NOT find ensenso (missing:  ENSENSO_LIBRARY ENSENSO_INCLUDE_DIR) 
			** WARNING ** visualization features related to ensenso will be disabled
			-- Could NOT find DAVIDSDK (missing:  DAVIDSDK_LIBRARY DAVIDSDK_INCLUDE_DIR) 
			** WARNING ** visualization features related to davidSDK will be disabled
			-- Could NOT find DSSDK (missing:  _DSSDK_LIBRARIES) 
			** WARNING ** visualization features related to dssdk will be disabled
			-- Could NOT find RSSDK (missing:  _RSSDK_LIBRARIES) 
			** WARNING ** visualization features related to rssdk will be disabled
			CMake Error at /usr/local/share/pcl-1.8/PCLConfig.cmake:46 (message):
			  simulation is required but glew was not found
			Call Stack (most recent call first):
			  /usr/local/share/pcl-1.8/PCLConfig.cmake:645 (pcl_report_not_found)
			  /usr/local/share/pcl-1.8/PCLConfig.cmake:808 (find_external_library)
			  CMakeLists.txt:8 (find_package)


			-- Configuring incomplete, errors occurred!
			See also "/Users/meppe/ROS/homebrew_catkin_ws/build_isolated/pcl_ros/CMakeFiles/CMakeOutput.log".
			<== Failed to process package 'pcl_ros': 
			  Command '['/Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh', 'cmake', '/Users/meppe/ROS/homebrew_catkin_ws/src/perception_pcl/pcl_ros', '-DCATKIN_DEVEL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros', '-DCMAKE_INSTALL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/install_isolated', '-DCMAKE_BUILD_TYPE=Release', '-G', 'Unix Makefiles']' returned non-zero exit status 1

			Reproduce this error by running:
			==> cd /Users/meppe/ROS/homebrew_catkin_ws/build_isolated/pcl_ros && /Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh cmake /Users/meppe/ROS/homebrew_catkin_ws/src/perception_pcl/pcl_ros -DCATKIN_DEVEL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros -DCMAKE_INSTALL_PREFIX=/Users/meppe/ROS/homebrew_catkin_ws/install_isolated -DCMAKE_BUILD_TYPE=Release -G 'Unix Makefiles'

			Command failed, exiting.


Followed the hint at http://stackoverflow.com/questions/26311715/solving-a-difficult-compilation-issue
That is, glew seems to be not present anymore in MacOS since 10.9 (Mavericks), so that the file 
/usr/local/share/pcl-1.8/PCLConfig.cmake is deprecated. 
To fix the issue, change the following line (around line number 500) in that file:
	
	/System/Library/Frameworks/GLEW.framework/Versions/A/Headers

to line:
	
	/usr/local/Cellar/glew/1.13.0/include/GL


Then, running catkin_make_isolated again caused other errors:

	[ 20%] Built target pcl_ros_gencfg
	[ 22%] Linking CXX executable /Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros/lib/pcl_ros/convert_pcd_to_image
	[ 23%] Linking CXX executable /Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros/lib/pcl_ros/convert_pointcloud_to_image
	[ 25%] Linking CXX executable /Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros/lib/pcl_ros/pcd_to_pointcloud
	ld: framework not found GLEW
	clang: error: linker command failed with exit code 1 (use -v to see invocation)
	ld: framework not found GLEW
	clang: error: linker command failed with exit code 1 (use -v to see invocation)
	make[2]: *** [/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros/lib/pcl_ros/convert_pcd_to_image] Error 1
	make[2]: *** [/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros/lib/pcl_ros/convert_pointcloud_to_image] Error 1
	make[1]: *** [CMakeFiles/convert_pcd_to_image.dir/all] Error 2
	make[1]: *** Waiting for unfinished jobs....
	make[1]: *** [CMakeFiles/convert_pointcloud_to_image.dir/all] Error 2
	ld: framework not found GLEW
	clang: error: linker command failed with exit code 1 (use -v to see invocation)
	make[2]: *** [/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros/lib/pcl_ros/pcd_to_pointcloud] Error 1
	make[1]: *** [CMakeFiles/pcd_to_pointcloud.dir/all] Error 2
	[ 26%] Linking CXX executable /Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros/lib/pcl_ros/pointcloud_to_pcd
	ld: framework not found GLEW
	clang: error: linker command failed with exit code 1 (use -v to see invocation)
	make[2]: *** [/Users/meppe/ROS/homebrew_catkin_ws/devel_isolated/pcl_ros/lib/pcl_ros/pointcloud_to_pcd] Error 1
	make[1]: *** [CMakeFiles/pointcloud_to_pcd.dir/all] Error 2
	make: *** [all] Error 2
	<== Failed to process package 'pcl_ros': 
	  Command '['/Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh', 'make', '-j4', '-l4']' returned non-zero exit status 2

	Reproduce this error by running:
	==> cd /Users/meppe/ROS/homebrew_catkin_ws/build_isolated/pcl_ros && /Users/meppe/ROS/homebrew_catkin_ws/install_isolated/env.sh make -j4 -l4

	Command failed, exiting.


TBC... stopped at this point. 