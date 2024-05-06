# This container is used to build and run Yocto Warrior
#
# To build:
# docker build --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag ubuntu_gumstix_image ./firechip-gumstix-build/
#
# To run:
# docker run -it --rm -v $PWD:/Work ubuntu_gumstix_image

FROM ubuntu:16.04

# Packages needed by Yocto
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
    xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
    pylint3 xterm

# Packages needed to set up environment
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    locales sudo

# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up Yocto build environments. Use bash as an alias for sh.
RUN which dash &> /dev/null && (\
    echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash) || \
    echo "Skipping dash reconfigure (not applicable)"

# Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Add user "embeddeduse" to sudoers
ENV USER_NAME embeddeduse
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME}

# The running container writes all the build artefacts to a host directory (outside the container).
# The container can only write files to host directories, if it uses the same user ID and
# group ID owning the host directories. The host_uid and group_uid are passed to the docker build
# command with the --build-arg option. By default, they are both 1001. The docker image creates
# a group with host_gid and a user with host_uid and adds the user to the group. The symbolic
# name of the group and user is embeddeduse.
ARG host_uid=1001
ARG host_gid=1001
RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

# Bitbake shouldn't be run by root. Switch to the newly created user embeddeduse.
USER $USER_NAME

WORKDIR /Work
