FROM phusion/baseimage:0.9.19
# FROM zittix/docker-baseimage-java8:latest (Test to use Java8 instead of 7)
MAINTAINER pducharme@me.com
# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ADD ./apt/ubuntu-sources.list /etc/apt/sources.list
RUN apt-get update -q
RUN apt-get -y install curl software-properties-common wget

  
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
#RUN 	wget -q -O -  http://www.ubnt.com/downloads/unifi-video/apt/unifi-video.gpg.key | apt-key add - && \
# echo "deb [arch=amd64] http://www.ubnt.com/downloads/unifi-video/apt trusty ubiquiti" | tee /etc/apt/sources.list.d/ubiquity-video.list
 
RUN \
  apt-get update -q && \
  apt-get upgrade -y && \
  apt-get dist-upgrade -y

# Installing Depedencies
RUN apt-get install -y ca-certificates-java fontconfig-config fonts-dejavu-core java-common jsvc libasyncns0 libavahi-client3 libavahi-common-data libavahi-common3 libcommons-daemon-java libcups2 libflac8 libfontconfig1 libfreetype6 libjpeg-turbo8 libjpeg8 liblcms2-2 libnspr4 libnss3 libnss3-nssdb libogg0 libpcsclite1 libpulse0 libsctp1 libsndfile1 libvorbis0a libvorbisenc2 libxau6 libxcb1 libxdmcp6 lksctp-tools mongodb-10gen openjdk-8-jre-headless tzdata-java --force-yes
RUN wget http://dl.ubnt.com/firmwares/unifi-video/3.6.0/unifi-video_3.6.0~Ubuntu16.04_amd64.deb
RUN sudo dpkg -i unifi-video_3.6.0~Ubuntu16.04_amd64.deb

VOLUME /var/lib/unifi-video
VOLUME /var/log/unifi-video

EXPOSE  7443 7445 7446 7447 7080 6666

WORKDIR /usr/lib/unifi-video

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD ["/run.sh"]
