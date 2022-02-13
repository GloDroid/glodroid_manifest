FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="Roman Marchenko <roman.marchenko@globallogic.com>"

ENV PATH="/home/user/bin:${PATH}"

# Taking into account layer structure, everything should be done within one layer.
RUN apt-get update && apt-get upgrade -y && \
    # Install Google recommended packages ( https://source.android.com/setup/build/initializing#installing-required-packages-ubuntu-1804 )
    apt-get install -y git-core gnupg flex bison build-essential zip \
    curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev \
    x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
    libxml2-utils xsltproc unzip fontconfig \
    # Install additional packages
    swig libssl-dev flex bison device-tree-compiler mtools git \
    gettext libncurses5 libgmp-dev libmpc-dev cpio rsync dosfstools kmod gdisk wget \
    # Install additional packages (for building mesa3d, libcamera and other meson-based components)
    python3-pip pkg-config python3-dev ninja-build \
    # Install additional packages (required by repo utility)
    python-is-python3 \
    # Add extra tools
    sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install additional packages (for building mesa3d, libcamera and other meson-based components)
RUN pip3 install mako meson jinja2 ply

ENV RUN_USER user
ENV RUN_UID 1000

ENV USER_HOME /home/${RUN_USER}

RUN mkdir -pv ${USER_HOME}
# Create new user
RUN adduser \
    --gecos 'Build User' \
    --shell '/usr/bin/bash' \
    --uid ${RUN_UID} \
    --disabled-login \
    --disabled-password ${RUN_USER}

# Create project path
RUN mkdir -pv ${USER_HOME}/aosp
WORKDIR ${USER_HOME}/aosp

RUN chown -R ${RUN_USER}:${RUN_USER} ${USER_HOME}
RUN chmod -R 775 ${USER_HOME}

#  Add new user docker to sudo group
RUN adduser ${RUN_USER} sudo

# Ensure sudo group users are not
# asked for a password when using
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers

# Pass control to a newly created user
USER ${RUN_USER}

# Install repo
RUN wget -P ${USER_HOME}/bin http://commondatastorage.googleapis.com/git-repo-downloads/repo
RUN chmod a+x ${USER_HOME}/bin/repo