FROM phusion/baseimage:latest
MAINTAINER pducharme@me.com

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Add needed patches and scripts
ADD unifi-video.patch /unifi-video.patch
ADD run.sh /run.sh

# Run all commands
RUN apt-get update && \
  apt-get install -y apt-utils && \
  apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
  apt-get install -y wget sudo moreutils patch && \
  apt-get install -y mongodb-server openjdk-8-jre-headless jsvc && \
  wget -q -O unifi-video.deb https://dl.ubnt.com/firmwares/ufv/v3.9.2/unifi-video.Ubuntu16.04_amd64.v3.9.2.deb && \
  dpkg -i unifi-video.deb && \
  patch -N /usr/sbin/unifi-video /unifi-video.patch && \
  rm /unifi-video.deb && \
  rm /unifi-video.patch && \
  chmod 755 /run.sh

# Base volume, will store db and configuration
VOLUME ["/var/lib/unifi-video"]

# Video storage, for seperation of data
VOLUME ["/usr/lib/unifi-video/data/videos"]

# Inbound Camera Streams (NVR Side)
EXPOSE 6666

# UVC-Micro Talkback (Camera Side)
EXPOSE 7004

# HTTP Web UI & API
EXPOSE 7080

# Camera Management (NVR Side)
EXPOSE 7442

# HTTPS Web UI & API
EXPOSE 7443

# Video over HTTP
EXPOSE 7445

# Video over HTTPS
EXPOSE 7446 

# RTSP via the controller
EXPOSE 7447

# RTMP via the controller
EXPOSE 1935

# RTMPS via the controller
EXPOSE 7447

# Run this potato
CMD ["/run.sh"]
