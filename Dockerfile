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

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /home nobody && \
 chown -R nobody:users /home

#Update APT-GET list
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
#RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"&& apt-get dist-upgrade -y

# Installing Depedencies & UniFi Video
RUN apt-get install -y mongodb-server openjdk-8-jre-headless jsvc sudo
RUN curl -sS http://dl.ubnt.com/firmwares/unifi-video/3.6.0/unifi-video_3.6.0~Ubuntu16.04_amd64.deb > unifi-video.deb
RUN sudo dpkg -i unifi-video.deb
RUN apt-get update && apt-get -f install

#RUN apt-get install -y ca-certificates-java fontconfig-config fonts-dejavu-core java-common jsvc libasyncns0 libavahi-client3 libavahi-common-data libavahi-common3 libcommons-daemon-java libcups2 libflac8 libfontconfig1 libfreetype6 libjpeg-turbo8 libjpeg8 liblcms2-2 libnspr4 libnss3 libnss3-nssdb libogg0 libpcsclite1 libpulse0 libsctp1 libsndfile1 libvorbis0a libvorbisenc2 libxau6 libxcb1 libxdmcp6 lksctp-tools mongodb-10gen openjdk-8-jre-headless tzdata-java --force-yes


VOLUME /var/lib/unifi-video
VOLUME /var/log/unifi-video

EXPOSE  7443 7445 7446 7447 7080 6666

WORKDIR /usr/lib/unifi-video

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD ["/run.sh"]
