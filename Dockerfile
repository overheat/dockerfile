FROM ubuntu:19.10

# Env
ENV USER aaron
ENV PASSWD xk3124919
ENV TZ  Asia/Shanghai
ENV SDK_VERSION 0.10.3
# Update
## Install dependencies
### Install these tools
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY sources.list /etc/apt/
RUN apt-get update && apt-get -y upgrade && \
apt-get -y install \
gcc-7-multilib perl liberror-perl \
git cmake ninja-build gperf \
ccache device-tree-compiler dfu-util wget vim python \
pkg-config cmake libcap2 libcap-dev \
python3-pip python3-setuptools python3-tk python3-wheel file \
make gcc gcc-multilib

### Get an updated version of cmake
#RUN apt-get install -y gnupg software-properties-common && \
#wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - && \
#apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
#apt-get update && apt-get install -y cmake

### Get an updated version of devices-tree-compiler
#RUN wget https://launchpad.net/ubuntu/+archive/primary/+files/device-tree-compiler_1.4.7-3ubuntu2_amd64.deb && \
#apt install ./device-tree-compiler_1.4.7-3ubuntu2_amd64.deb

# Uncomment to add user
RUN apt-get install -y sudo && \
useradd -rm -d /home/${USER} -s /bin/bash -g root -G sudo -u 1000 ${USER} && \
echo "${USER}:${PASSWD}" | chpasswd
USER ${USER}
WORKDIR /home/${USER}

### Install west
RUN pip3 install --user -U west && \
echo 'export PATH=~/.local/bin:"$PATH"' >> ~/.bashrc && \
/bin/bash -c "source ~/.bashrc"


## Get the source code
#RUN ~/.local/bin/west init zephyrproject
#WORKDIR /home/${USER}/zephyrproject
#RUN ~/.local/bin/west update

## Install needed Python packages
COPY requirements.txt ./
RUN pip3 install --user -r ./requirements.txt

## Install Software Development Toolchain
#RUN wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${SDK_VERSION}/zephyr-sdk-${SDK_VERSION}-setup.run && \
#chmod +x zephyr-sdk-${SDK_VERSION}-setup.run && \
#./zephyr-sdk-${SDK_VERSION}-setup.run -- -d ~/zephyr-sdk-${SDK_VERSION} && \
## Set environment variables to let the build system know where to find the toolchain programs
#echo 'export ZEPHYR_TOOLCHAIN_VARIANT=zephyr' >> ~/.bashrc && \
#echo 'export ZEPHYR_SDK_INSTALL_DIR=~/work/zephyrproject/zephyr-sdk-${SDK_VERSION}' >> ~/.bashrc


# install aws CLI version 1
RUN pip3 install awscli --upgrade --user

# Amazon FreeRTOS

# git config

# Uncomment to add git config
RUN git config --global user.name "Aaron Tsui" && \
git config --global user.email "aaron.tsui@outlook.com" && \
git config --global alias.co checkout && \
git config --global alias.br branch && \
git config --global alias.ci commit && \
git config --global alias.st status

WORKDIR /home/${USER}
