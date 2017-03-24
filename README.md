# unifi-video-controller

This is a docker for use on Unraid 6.x for the UniFi-Video controller.

Please note that on first run, it will create a system.properties that you will need to edit to add on the first line: is_default=true

After that, restart the docker and you'll be great by the Unifi-Video wizard that will let you set a User/Pass for your Unifi-Video controller.

## Run it
```
docker run \
        --name unifi-video \
        -p 7443:7443 \
        -p 7445:7445 \
        -p 7446:7446 \
        -p 7447:7447 \
        -p 7080:7080 \
        -p 6666:6666 \
	-v <data dir>:/var/lib/unifi-video \
        -v <videos dir>:/usr/lib/unifi-video/data/videos \
        -v <logs dir>:/var/log/unifi-video  \
        pducharme/unifi-video-controller
```
