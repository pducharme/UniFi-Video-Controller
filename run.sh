#!/bin/bash

# depracated
#exec /usr/bin/jsvc -nodetach -cwd /usr/lib/unifi-video -user unifi-video -home /usr/lib/jvm/java-7-openjdk-amd64/jre -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar -pidfile /var/run/unifi-video/unifi-video.pid -procname unifi-video -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Xmx1024M com.ubnt.airvision.Main start
#java -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar -Dav.tempdir=/var/cache/unifi-video -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Xmx1024M com.ubnt.airvision.Main start

#Version 3.2.0 requires more commands to start.
java -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar -Dav.tempdir=/var/cache/unifi-video -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Xmx1024M -Djava.library.path=/usr/lib/unifi-video/lib com.ubnt.airvision.Main start
