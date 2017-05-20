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
  wget -q http://dl.ubnt.com/firmwares/unifi-video/3.7.0/unifi-video_3.7.0~Ubuntu16.04_amd64.deb && \
  dpkg -i unifi-video_3.7.0~Ubuntu16.04_amd64.deb && \
  patch -N /usr/sbin/unifi-video /unifi-video.patch && \
  chmod 755 /run.sh

# Volumes
VOLUME /var/lib/unifi-video /var/log/unifi-video

# Ports
EXPOSE 7443 7445 7446 7447 7080 6666

# Run this potato
CMD ["/run.sh"]
