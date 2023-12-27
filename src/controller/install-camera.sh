#!/bin/bash
### untested ###


sudo apt-get update
#sudo apt-get upgrade

# install mjpg-streamer dependencies
sudo apt-get install cmake libjpeg8-dev
sudo apt-get update


# install aarch64 gcc and g++ for userland
sudo apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
sudo apt-get update

# install libraspberry package
sudo apt-get install libraspberrypi0 libraspberrypi-dev libraspberrypi-doc
sudo apt-get update

# install userland
touch userland_build_out.txt
git clone https://github.com/raspberrypi/userland
cd userland
git revert f97b1af1b3e653f9da2c1a3643479bfd469e3b74
git revert e31da99739927e87707b2e1bc978e75653706b9c


# mmal fix for raspberry pi 4: https://github.com/waveform80/picamera/issues/540#issuecomment-881645216
sed '/^target_link_libraries(mmal mmal_core mmal_util mmal_vc_client vcos mmal_components)*/i SET(CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-as-needed")' ./interface/mmal/CMakeLists.txt > ./interface/mmal/CMakeLists-temp.txt
mv ./interface/mmal/CMakeLists-temp.txt ./interface/mmal/CMakeLists.txt

# build userland
printf "===== Starting userland build =====\n"
sudo ./buildme --aarch64 &>../userland_build_out.txt

# copy userland libraries
sudo cp /opt/vc/lib/*.so /usr/lib/aarch64-linux-gnu/
cd ..

# check userland install
printf "#################### check userland files ####################\n\n"
USERLAND_FILES="libdebug_sym.so
libmmal.so
libmmal_util.so
libvchostif.a
libbcm_host.so
libdebug_sym_static.a
libmmal_components.so
libmmal_vc_client.so
libvcos.so
libcontainers.so
libdtovl.so
libmmal_core.so
libvchiq_arm.so
libvcsm.so"
OPT_VC_LIB_COUNT=0
OPT_VC_LIB_EXISTS=$(shopt -s nullglob dotglob; echo /opt/vc/lib/*)
if (( ${#OPT_VC_LIB_EXISTS} ))
then
        printf "========== /opt/vc/lib/ exists and contains files ==========\n\n"
        printf "========== checking /opt/vc/lib/ files ==========\n"
        for f in $USERLAND_FILES
        do
                if [[ -e /opt/vc/lib/$f && ! -L /opt/vc/lib/$f ]]; then
                        printf "$f exists and not a symbolic link\n"
                        let "OPT_VC_LIB_COUNT=OPT_VC_LIB_COUNT+1"
                else
                        printf "\n$f does not exist\n"
                fi
		
        done
else
        echo "ERROR: /opt/vc/lib/ is empty (or does not exist or is a file)"
        exit 1
fi
if [[ $OPT_VC_LIB_COUNT == 14 ]]; then
        printf "\n========== /opt/vc/lib/ is valid ===========\n\n"
else
        echo "ERROR: /opt/vc/lib/ is missing files or doesn't exist"
        exit 1
fi
USR_LIB_AARCH64_count=0
USR_LIB_AARCH64_EXISTS==$(shopt -s nullglob dotglob; echo /usr/lib/aarch64-linux-gnu/*)
if (( ${#USR_LIB_AARCH64_EXISTS} ))
then
        printf "========== /usr/lib/aarch64-linux-gnu/ exists and contains files ==========\n\n"
        printf "========== checking /usr/lib/aarch64-linux-gnu/ files ==========\n"
        for f in $USERLAND_FILES
        do
                if [[ -e /usr/lib/aarch64-linux-gnu/$f && ! -L /usr/lib/aarch64-linux-gnu/$f ]]; then
                        printf "$f exists and not a symbolic link\n"
                        let "USR_LIB_AARCH64_COUNT=USR_LIB_AARCH64_COUNT+1"
                else
                        printf "\n$f does not exist\n"
                fi

        done
else
        echo "ERROR: /usr/lib/aarch64-linux-gnu/ is empty (or does not exist or is a file)"
        exit 1
fi
if [[ $USR_LIB_AARCH64_COUNT == 14 ]]; then
        printf "\n========== /usr/lib/aarch64-linux-gnu/ is valid ===========\n\n"
else
        echo "ERROR: /usr/lib/aarch64-linux-gnu/ is missing files or doesn't exist"
        exit 1
fi
printf "#################### check for mmal files ####################\n\n"
MMAL_EXISTS=$(shopt -s nullglob dotglob; echo /opt/vc/include/interface/mmal/*)
if (( ${#MMAL_EXISTS} ))
then
        printf "========== /opt/vc/include/interface/mmal/ contains files ==========\n\n"
else
        printf "========== /opt/vc/include/interface/mmal/ is empty (or does not exist or is a file) ==========\n\n"
        exit 1
fi


# build and install mjpg-streamer
touch mjpg-streamer_make_out.txt
touch mjpg-streamer_make_install_out.txt
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd mjpg-streamer
cd mjpg-streamer-experimental
printf "===== Starting mjpg-streamer make =====\n"
make distclean
make CMAKE_BUILD_TYPE=Debug &>../../mjpg-streamer_make_out.txt
printf "===== Starting mjpg-streamer make install =====\n"
sudo make install &>../../mjpg-streamer_make_install_out.txt
#export LD_LIBRARY_PATH=../mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so"
cd ..
cd ..

# check mjpg-streamer install 
printf "#################### check mjpg files ####################\n\n"
MJPG_STREAMER="/usr/local/lib/mjpg-streamer/"
MJPG_FILES="input_file.so
input_raspicam.so
output_file.so
output_rtsp.so
input_http.so
input_uvc.so
output_http.so
output_udp.so"
MJPG_LIB_COUNT=0
MJPG_LIB_EXISTS=$(shopt -s nullglob dotglob; echo /usr/local/lib/mjpg-streamer/*)
if (( ${#OPT_VC_LIB_EXISTS} ))
then
        printf "========== /usr/local/lib/mjpg-streamer/ exists and contains files ==========\n\n"
        printf "========== checking /usr/local/lib/mjpg-streamer/ files ==========\n"
        for f in $MJPG_FILES
        do
                if [[ -e /usr/local/lib/mjpg-streamer/$f && ! -L /usr/local/lib/mjpg-streamer/$f ]]; then
                        printf "$f exists and not a symbolic link\n"
                        let "MJPG_LIB_COUNT=MJPG_LIB_COUNT+1"
                else
                        printf "\n$f does not exist\n"
                fi
        done
else
        echo "ERROR: /usr/local/lib/mjpg-streamer/ is empty (or does not exist or is a file)"
        exit 1
fi
if [[ $MJPG_LIB_COUNT == 8 ]]; then
        printf "\n========== /usr/local/lib/mjpg-streamer/ is valid ===========\n\n"
else
        echo "ERROR: /usr/local/lib/mjpg-streamer/ is missing files or doesn't exist"
        exit 1
fi


# enable camera: add start_x=1 to /boot/firmware/config.txt
#mkdir /boot_backup/
#sudo cp /boot/firmware/config.txt ./boot_backup/config.txt
#if grep -q "start_x=1" /boot/firmware/config.txt; then
#        echo "start_x=1 found in /boot/firmware/config.txt, not adding"
#else
#        echo "\nstart_x=1" >> /boot/firmware/config.txt
#fi
