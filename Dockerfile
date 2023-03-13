FROM phusion/baseimage:bionic-1.0.0-amd64
MAINTAINER vuhuy@shibe.nl

# Set environment variables
ENV UNIFI_VIDEO_VERSION="3.10.13"
ENV MONGODB_VERSION="4.0.28"
ENV DEBIAN_FRONTEND="noninteractive"
ENV PUID="1000"
ENV PGID="1000"
ENV UMASK="002"
ENV USE_UNIFI_TMPFS="no"
ENV USE_HOST_TMPFS="yes"

# Add patches and scripts
ADD unifi-video.patch /unifi-video.patch
ADD run.sh /run.sh

# Install general packages
RUN apt-get update && \
  apt-get install -y \
    jsvc \
    jq \
    libcap2 \
    logrotate \
    lsb-release \
    moreutils \
    openjdk-8-jre-headless=8u162-b12-1 \
    patch \
    psmisc \
    sudo \
    tzdata \
    wget \
    zip

# Install MongoDB server and shell
RUN wget -q -O mongodb-server.deb https://repo.mongodb.org/apt/ubuntu/dists/bionic/mongodb-org/4.0/multiverse/binary-amd64/mongodb-org-server_${MONGODB_VERSION}_amd64.deb && \
  dpkg -i mongodb-server.deb && \
  wget -q -O mongodb-shell.deb https://repo.mongodb.org/apt/ubuntu/dists/bionic/mongodb-org/4.0/multiverse/binary-amd64/mongodb-org-shell_${MONGODB_VERSION}_amd64.deb && \
  dpkg -i mongodb-shell.deb

# Install and patch UniFi Video
RUN wget -q -O unifi-video.deb https://dl.ubnt.com/firmwares/ufv/v${UNIFI_VIDEO_VERSION}/unifi-video.Ubuntu18.04_amd64.v${UNIFI_VIDEO_VERSION}.deb && \
  dpkg -i unifi-video.deb && \
  patch -lN /usr/sbin/unifi-video /unifi-video.patch && \
  chmod 755 /run.sh

# Mitigate log4j CVE-2021-44228
RUN zip -q -d /usr/lib/unifi-video/lib/log4j-core-2.1.jar org/apache/logging/log4j/core/lookup/JndiLookup.class && \
  chown unifi-video:unifi-video /usr/lib/unifi-video/lib/log4j-core-2.1.jar

# Cleanup
RUN  apt-get clean && \
  rm -rf \
    /mongodb-server.deb \
    /mongodb-shell.deb \
    /tmp/* \
    /unifi-video.deb \
    /unifi-video.patch \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Expose listening ports
EXPOSE 6666/tcp 7080/tcp 7442/tcp 7443/tcp 7445/tcp 7446/tcp 7447/tcp

# Run this potato
CMD ["/run.sh"]