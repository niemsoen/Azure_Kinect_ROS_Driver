# Install Azure Kinect Driver
Tested on **Ubuntu 20.04 with ROS2 Galactic**

## Prerequisites

- Install xacro

        pip3 install xacro
- Joint state publisher

        sudo apt install ros-galactic-joint-state-publisher

- Azure Kinect SDK  
    Run auto install script that detects your OS and processore architecture and installs the driver using dpkg.

        cd /Azure_Kinect_ROS_Driver
        ./install-dependencies_auto-dist.sh

    sources:
    - how to https://github.com/microsoft/Azure-Kinect-Sensor-SDK/issues/1263#issuecomment-758810804
    - .deb files here https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/k/k4a-tools/

    <details>
    <summary><b>Install Azure Kinect SDK using apt (unstable, not recommended)</b></summary>
    as seen [here](https://github.com/microsoft/Azure-Kinect-Sensor-SDK/issues/1263#issuecomment-710698591)

    - add microsoft package repository
            
            curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

            sudo apt-add-repository https://packages.microsoft.com/ubuntu/18.04/prod

            curl -sSL https://packages.microsoft.com/config/ubuntu/18.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft-prod.list

            curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

    - install Azure SDK

            sudo apt-get update
            sudo apt install libk4a1.3-dev
            sudo apt install libk4abt1.0-dev
            sudo apt install k4a-tools=1.3.0
    - set udev rules

            curl https://raw.githubusercontent.com/microsoft/Azure-Kinect-Sensor-SDK/develop/scripts/99-k4a.rules >> 99-k4a.rules

            sudo mv 99-k4a.rules /etc/udev/rules.d/
    - Connect Kinect Camera and test camera output stream

            k4aviewer
        *Open Device -> Start*  
        you can ignore the MPEG decoding error message, see [here](https://github.com/microsoft/Azure-Kinect-Sensor-SDK/issues/672) for further informationt
    </details>
  



## Download Source
```bash
git clone https://github.com/microsoft/Azure_Kinect_ROS_Driver.git -b foxy-devel
```


## Build
````bash
source /opt/ros/galactic/setup.bash
cd Azure_Kinect_ROS_Driver
rosdep install -i --from-path src --rosdistro galactic -y
colcon build
````

## Run Driver
### Driver only
````bash
source install/setup.bash
ros2 launch azure_kinect_ros_driver driver.launch.py
````
### Driver with RViz Display
````bash
source install/setup.bash
ros2 launch azure_kinect_ros_driver rviz_driver.launch.py
````

# Further Resources
- install Azure Kinect Sensor SDK (https://docs.microsoft.com/en-us/azure/Kinect-dk/sensor-sdk-download#linux-installation-instructions)