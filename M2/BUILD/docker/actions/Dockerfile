# Time usage: <15min
# Net usage:  ~255MB
# Disk usage: <1GB docker image + 650MB Macaulay2 build

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common apt-transport-https build-essential curl git gnupg && \
    curl https://apt.kitware.com/keys/kitware-archive-latest.asc -s --output - | apt-key add - && \
    echo 'deb https://apt.kitware.com/ubuntu/ noble main' > \
      /etc/apt/sources.list.d/cmake.list && \
    add-apt-repository -y ppa:macaulay2/macaulay2 && \
    apt-get update && apt-get install -y autoconf bison ccache cmake flex libtool ninja-build yasm && apt-get clean

# Programs and libraries we require to build
RUN apt-get install -y -q --no-install-recommends libboost-stacktrace-dev \
	libncurses-dev libncurses5-dev libreadline-dev libeigen3-dev liblapack-dev libxml2-dev \
	libgc-dev libgdbm-dev libglpk-dev libgmp3-dev libgtest-dev libmpfr-dev libmpfi-dev libntl-dev gfan \
	libgivaro-dev libboost-regex-dev fflas-ffpack libflint-dev libmps-dev libfrobby-dev \
	libnauty-dev libnormaliz-dev libsingular-dev singular-data libcdd-dev \
	cohomcalg topcom 4ti2 normaliz coinor-csdp nauty lrslib libtbb-dev

# Testing with clang-11 compiler
#RUN apt-get install -y clang-16 llvm-16 libomp-16-dev && apt-get clean

# For testing optional programs
#RUN apt-get install -y polymake phcpack qepcad && apt-get clean

RUN apt-get install -y -q --no-install-recommends locate bash-completion && apt-get clean && updatedb

RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update

# Needed for building with autotools
# RUN apt-get install -y -q liblzma-dev w3c-markup-validator

# Add non-root user for building and running Macaulay2
RUN useradd -G sudo -g root -u 1000 -m macaulay
USER 1000:0

ENV PKG_CONFIG_PATH /usr/lib/x86_64-linux-gnu/pkgconfig
ENV LDFLAGS         -L/usr/lib/x86_64-linux-gnu
ENV PATH            /home/macaulay/M2/M2/BUILD/build-actions:${PATH}

WORKDIR /home/macaulay
ENTRYPOINT M2
