FROM phusion/baseimage:0.11
MAINTAINER pducharme@me.com

# Version
ENV version 3.10.7

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Add needed patches and scripts
ADD unifi-video.patch /unifi-video.patch
ADD run.sh /run.sh

# Add mongodb repo, key, update and install needed packages
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
  echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list && \
  apt-get update && \
  apt-get install -y apt-utils && \
  apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
  apt-get install -y  \
    jsvc \
    jq \
    moreutils \
    openjdk-8-jre-headless \
    patch \
    sudo \
    tzdata \
    mongodb-org-server \
    mongodb-org-shell \
    moreutils \
    wget

# Get, install and patch unifi-video
RUN wget -q -O unifi-video.deb https://dl.ubnt.com/firmwares/ufv/v${version}/unifi-video.Ubuntu18.04_amd64.v${version}.deb && \
  dpkg -i unifi-video.deb && \
  patch -N /usr/sbin/unifi-video /unifi-video.patch && \
  rm /unifi-video.deb && \
  rm /unifi-video.patch && \
  chmod 755 /run.sh

# Configuration and database volume
VOLUME ["/var/lib/unifi-video"]

# Video storage volume
VOLUME ["/var/lib/unifi-video/videos"]

# RTMP, RTMPS & RTSP via the controller
EXPOSE 1935/tcp 7444/tcp 7447/tcp

# Inbound Camera Streams & Camera Management (NVR Side)
EXPOSE 6666/tcp 7442/tcp

# UVC-Micro Talkback (Camera Side)
EXPOSE 7004/udp

# HTTP & HTTPS Web UI + API
EXPOSE 7080/tcp 7443/tcp

# Video over HTTP & HTTPS
EXPOSE 7445/tcp 7446/tcp

# Run this potato
CMD ["/run.sh"]
