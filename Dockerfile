FROM ubuntu:16.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
     uidmap gawk wget git-core diffstat unzip texinfo gcc-multilib g++-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm tar locales pxz zip \
     mtools dosfstools parted udev curl \
  && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
  && DEBIAN_FRONTEND=noninteractive apt-get -y install git-lfs

RUN rm /bin/sh && ln -s bash /bin/sh

WORKDIR /tmp
RUN curl -s https://storage.googleapis.com/git-repo-downloads/repo | \
     sed 's|#!/usr/bin/env python|/#!/usr/bin/env python3|g' > /usr/bin/repo \
     && chmod a+x /usr/bin/repo

RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# limit number of open files to 1024, increases the do_rootfs speed
RUN echo 'ulimit -n 1024' >> /etc/profile

ENV USER_NAME jenkins

ARG host_uid=1000
ARG host_gid=1000
RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

USER $USER_NAME

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["cat"]