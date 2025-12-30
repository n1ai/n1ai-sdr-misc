#!/bin/bash 

# Builds the soapy sdr infrastructure and many soapy capable apps for sbitx.
# TODO:
#  - build linhpsdr
#  - build the dl1ycf fork of pihpsdr intead of the g0orx one
#  - build quisk and set it up to do sbitx either directly or via soapy

# Set the TOP variable to where you want most of this code to be built
# and export it to the environment
TOP=${HOME}/code/soapy-sbitx 
export TOP

echo "Attention"
printf "This script will do a bunch of things you may or may not want:
  • It will update all the core Debian packages on the system \n\
  • it will make a new build directory at:\n\
      \t${TOP}\n\
  • It will build and/or install several new SDR libraries and apps\n\
    • These may or may not conflict with ones already on your system\n\
  • It will make your system run slowly for a long time while it runs\n\
  • It may crash or hang your system\n\
    • Especially if you have any major sdr apps or browsers running\n\
  • It may wait asking you to accept SdrPlay licenses\n\
"
read -rp "Do you want to continue? (y/n): " a && [[ "$a" == "y" ]] || exit 1

set -x

# get up to date
# this takes a long time if you haven't done it before
echo "OS Updates"
sudo apt update && sudo apt -y upgrade

# install initial dependencies/tools
# this also takes a long time since gqrx has a lot of dependencies
echo "Pre-Reqs"
sudo apt install -y libi2c-dev soapysdr-tools libsoapysdr-dev \
  gqrx-sdr libgnuradio-hpsdr1.0.0 libgnuradio-limesdr3.0.1 \
  pavucontrol sysvbanner  || true

# remove xtrx-dkms since it's broken, then clean up
sudo apt remove -y xtrx-dkms || true
sudo apt autoremove -y || true

# fail on error from here on
set -ex

# make a new place to put this stuff and go there
mkdir -p ${TOP}
pushd ${TOP}

# build sbitx_ctrl
banner "SbitxCtrl"
[ ! -d sbitx-core ] && git clone https://github.com/n1ai/sbitx-core
pushd sbitx-core
git switch sbitx_ctrl
git pull
make sbitx_ctrl
sudo make install_sbitx_ctrl
popd

# build SoapySBITX from the sbitx-ham-apps repo
banner "SoapySbitx"
[ ! -d sbitx-ham-apps ] && git clone https://github.com/n1ai/sbitx-ham-apps
pushd sbitx-ham-apps
git switch level3_1227
git pull
pushd soapy2sbitx
mkdir -p build
cd build
cmake ..
make -j2
sudo make install
sudo ldconfig
banner "SoapyInfo"
SoapySDRUtil --info
banner "SoapyFind"
SoapySDRUtil --find
cd ..
popd  ## soapy2sbitx
popd  ## sbitx-ham-apps

# install cubicsdr using the script from the sbitx-ham-apps repo
# banner "CubicSDR"
pushd sbitx-ham-apps
bash -x ./install-cubicsdr.sh
popd

# build pihpdr using my version of jj's build script
pushd ${TOP}/sbitx-ham-apps/
banner "PiHPSDR"
bash -x ./install-pihpsdr.sh
popd

banner "Done!"
