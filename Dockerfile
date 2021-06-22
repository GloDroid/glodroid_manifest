FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="Roman Marchenko <roman.marchenko@globallogic.com>"

ENV PATH="/home/user/bin:${PATH}"
RUN apt-get clean && apt-get update && apt-get upgrade -y

# Install Google recommended packages ( https://source.android.com/setup/build/initializing#installing-required-packages-ubuntu-1804 )
RUN apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig

# Install additional packages
RUN apt-get install -y swig libssl-dev flex bison device-tree-compiler mtools git gettext libncurses5 libgmp-dev libmpc-dev cpio rsync dosfstools kmod gdisk wget

# Install additional packages (for building mesa3d, libcamera and other meson-based components)
RUN apt-get install -y python3-pip pkg-config python3-dev ninja-build
RUN pip3 install mako meson jinja2 ply

# Install additional packages (required by repo utility)
RUN apt-get install -y python-is-python3

# Create new user
RUN useradd -m user
USER user

# Install repo
RUN wget -P ~/bin http://commondatastorage.googleapis.com/git-repo-downloads/repo
RUN chmod a+x ~/bin/repo

# Prepare workdir
RUN mkdir ~/aosp
WORKDIR /home/user/aosp