FROM ubuntu:18.04

# Env
ENV USER aaron
ENV PASSWD xk3124919
ENV TZ  Asia/Shanghai
ENV SDK_VERSION 0.10.3
# Update
RUN apt-get update
#RUN apt update && apt upgrade

# Zephyr OS

## Install dependencies
### Install these tools
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y git ninja-build gperf \
ccache dfu-util device-tree-compiler wget \
python3-pip python3-setuptools python3-tk python3-wheel file \
make gcc gcc-multilib

### Get an updated version of cmake
RUN apt-get install -y gnupg software-properties-common
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
RUN apt-get update && apt-get install -y cmake

# Uncomment to add user
RUN apt-get install -y sudo
RUN useradd -rm -d /home/${USER} -s /bin/bash -g root -G sudo -u 1000 ${USER}
RUN echo "${USER}:${PASSWD}" | chpasswd
USER ${USER}
WORKDIR /home/${USER}

### Install west
RUN pip3 install --user -U west
RUN echo 'export PATH=~/.local/bin:"$PATH"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"


## Get the source code
RUN ~/.local/bin/west init zephyrproject
WORKDIR /home/${USER}/zephyrproject
RUN ~/.local/bin/west update

## Install needed Python packages
RUN pip3 install --user -r ~/zephyrproject/zephyr/scripts/requirements.txt

## Install Software Development Toolchain
RUN wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${SDK_VERSION}/zephyr-sdk-${SDK_VERSION}-setup.run
RUN chmod +x zephyr-sdk-${SDK_VERSION}-setup.run
RUN ./zephyr-sdk-${SDK_VERSION}-setup.run -- -d ~/zephyr-sdk-${SDK_VERSION}
## Set environment variables to let the build system know where to find the toolchain programs
RUN export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
RUN export ZEPHYR_SDK_INSTALL_DIR=~/zephy${SDK_VERSION}


# aws iot C sdk

# Amazon FreeRTOS

# git config

