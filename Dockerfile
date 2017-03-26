FROM phusion/baseimage:latest
MAINTAINER pducharme@me.com

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

#Update APT-GET list
RUN apt-get update 
RUN apt-get install -y apt-utils
RUN apt-get upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get install -y apt-utils wget sudo moreutils patch

# Installing Depedencies & UniFi Video
RUN apt-get install -y mongodb-server
RUN apt-get install -y openjdk-8-jre-headless
RUN apt-get install -y jsvc
RUN wget -q http://dl.ubnt.com/firmwares/unifi-video/3.6.2/unifi-video_3.6.2~Ubuntu16.04_amd64.deb
RUN dpkg -i unifi-video_3.6.2~Ubuntu16.04_amd64.deb

# Patch unifi-video to remove ulimit and change hostname -option
ADD unifi-video.patch /unifi-video.patch
RUN patch -N /usr/sbin/unifi-video /unifi-video.patch

VOLUME /var/lib/unifi-video
VOLUME /var/log/unifi-video

# Ports
EXPOSE 7443
EXPOSE 7445
EXPOSE 7446
EXPOSE 7447
EXPOSE 7080
EXPOSE 6666

WORKDIR /usr/lib/unifi-video

# This is run by init.sh, starts unifi-video and traps for graceful shutdown.
ADD run.sh /run.sh
RUN chmod 755 /run.sh

# Initialize user nobody and group users
ADD init.sh /init.sh
RUN chmod 755 /init.sh
CMD ["/init.sh"]
