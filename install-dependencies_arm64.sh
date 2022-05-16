#!/bin/bash

# add microsoft repositories
echo "----- add microsoft repositories -----"
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-add-repository https://packages.microsoft.com/ubuntu/18.04/multiarch/prod
curl -sSL https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list | sudo tee /etc/apt/sources.list.d/microsoft-prod.list
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# install packages
echo "----- update package database -----"
sudo apt-get update
echo "----- install packages -----"
sudo apt install -y libk4a1.3-dev libk4abt1.0-dev k4a-tools=1.3.0 
# sudo apt install -y ros-foxy-joint-state-publisher
pip3 install xacro

# set udev rules
echo "----- set udev rules -----"
curl https://raw.githubusercontent.com/microsoft/Azure-Kinect-Sensor-SDK/develop/scripts/99-k4a.rules >> ~/99-k4a.rules
sudo mv ~/99-k4a.rules /etc/udev/rules.d/