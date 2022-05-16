#!/bin/bash
# https://github.com/microsoft/Azure-Kinect-Sensor-SDK/issues/1263#issuecomment-983804473

hash lsb_release 2>/dev/null || { echo "ERROR: tool lsb_release needed for analysis"; exit 1; }
os=$(lsb_release -cs)
arch=$(uname -m)
echo "--------- $arch detected"

if [[ $os = "focal" ]]; then
  echo "--------- Ubuntu 20.04 detected"
  
  if [[ $arch = "x86_64" ]]; then
    # Special hack for Azure Kinect Framework not available on Ubuntu 20.04
    # Install k4a SDK from their repository.
    # Bit of a hack, see https://github.com/microsoft/Azure-Kinect-Sensor-SDK/issues/1263
    # The simple solution by @vinesmsuic does not seem to work. This uses the manual 
    # solution by @atinfinity
    # Also, https://github.com/microsoft/Azure-Kinect-Sensor-SDK/issues/1190 is part of this solution (needed to non-interactively accept EULA)
    if [[ "$(dpkg -s libk4a1.4-dev | grep Status | awk '{ print $4 }')" != "installed" ]]; then
      echo "Retrieving azure kinect packages for architecture $arch. Be patient..."
      curl -sSL https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4a1.4/libk4a1.4_1.4.1_amd64.deb > /tmp/libk4a1.4_1.4.1_amd64.deb
      curl -sSL https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4a1.4-dev/libk4a1.4-dev_1.4.1_amd64.deb > /tmp/libk4a1.4-dev_1.4.1_amd64.deb
      echo 'libk4a1.4 libk4a1.4/accepted-eula-hash string 0f5d5c5de396e4fee4c0753a21fee0c1ed726cf0316204edda484f08cb266d76' | sudo debconf-set-selections
      echo 'libk4a1.4 libk4a1.4/accept-eula select true' | sudo debconf-set-selections
      sudo dpkg -i /tmp/libk4a1.4_1.4.1_amd64.deb
      sudo dpkg -i /tmp/libk4a1.4-dev_1.4.1_amd64.deb
    fi
  
  elif [[ $arch = "aarch64" ]]; then
    if [[ "$(dpkg -s libk4a1.4-dev | grep Status | awk '{ print $4 }')" != "installed" ]]; then
      echo "Retrieving azure kinect packages for architecture $arch. Be patient..."
      curl -sSL https://packages.microsoft.com/ubuntu/18.04/multiarch/prod/pool/main/libk/libk4a1.4/libk4a1.4_1.4.1_arm64.deb > /tmp/libk4a1.4_1.4.1_arm64.deb
      curl -sSL https://packages.microsoft.com/ubuntu/18.04/multiarch/prod/pool/main/libk/libk4a1.4-dev/libk4a1.4-dev_1.4.1_arm64.deb > /tmp/libk4a1.4-dev_1.4.1_arm64.deb
      echo 'libk4a1.4 libk4a1.4/accepted-eula-hash string 0f5d5c5de396e4fee4c0753a21fee0c1ed726cf0316204edda484f08cb266d76' | sudo debconf-set-selections
      echo 'libk4a1.4 libk4a1.4/accept-eula select true' | sudo debconf-set-selections
      sudo dpkg -i /tmp/libk4a1.4_1.4.1_arm64.deb
      sudo dpkg -i /tmp/libk4a1.4-dev_1.4.1_arm64.deb
    fi
  
  else
    echo "--------- $arch not recognized"
  fi

else
  echo "--------- Ubuntu 18.04 detected"
  # lib kinect
  curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  sudo apt-get install -y software-properties-common
  sudo apt-add-repository https://packages.microsoft.com/ubuntu/18.04/prod
  sudo apt-get update
  echo 'libk4a1.4 libk4a1.4/accepted-eula-hash string 0f5d5c5de396e4fee4c0753a21fee0c1ed726cf0316204edda484f08cb266d76' | sudo debconf-set-selections
  echo 'libk4a1.4 libk4a1.4/accept-eula select true' | sudo debconf-set-selections
  sudo apt-get install -y --no-install-recommends libk4a1.4-dev
fi

echo "Done"