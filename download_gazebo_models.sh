# File is from http://machineawakening.blogspot.com/2015/05/how-to-download-all-gazebo-models.html

#!/bin/sh

# Download all model archive files
wget -l 2 -nc -r "http://models.gazebosim.org/" --accept gz

# This is the folder into which wget downloads the model archives
cd "models.gazebosim.org"

# Extract all model archives
for i in *
do
  tar -zvxf "$i/model.tar.gz"
done

# Copy extracted files to the local model folder
mkdir -p "$HOME/.gazebo/models/"
cp -vfR * "$HOME/.gazebo/models/"