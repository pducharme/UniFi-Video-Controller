#!/bin/bash

# Run unifi-video controller
echo "[info] Running unifi-video..." | ts '%Y-%m-%d %H:%M:%.S'
java -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar -Dav.tempdir=/var/cache/unifi-video -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Xmx1024M -Djava.library.path=/usr/lib/unifi-video/lib com.ubnt.airvision.Main start
