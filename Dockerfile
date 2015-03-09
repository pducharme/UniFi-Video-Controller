FROM phusion/baseimage:0.9.16
MAINTAINER pducharme@me.com
# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ADD ./apt/ubuntu-sources.list /etc/apt/sources.list

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /home nobody && \
 chown -R nobody:users /home


#Update APT-GET list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 16126D3A3E5C1192
RUN 	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
RUN 	wget -q -O -  http://www.ubnt.com/downloads/unifi-video/apt/unifi-video.gpg.key | apt-key add - && \
  echo "deb [arch=amd64] http://www.ubnt.com/downloads/unifi-video/apt trusty ubiquiti" | tee /etc/apt/sources.list.d/ubiquity-video.list
 
RUN \
  apt-get update -q && \
  apt-get upgrade -y && \
  apt-get dist-upgrade -y

# Install Common Dependencies
RUN apt-get -y install curl software-properties-common
RUN apt-get install -q -y unifi-video

VOLUME /var/lib/unifi-video
VOLUME /var/log/unifi-video

# Wipe out auto-generated data
RUN rm -rf /var/lib/unifi-video/*

EXPOSE  7447 1935 7443 7080 6666 80 443 554

WORKDIR /usr/lib/unifi-video

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD ["/run.sh"]
