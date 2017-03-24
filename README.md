# unifi-video-controller

This is a docker for use on Unraid 6.x for the UniFi-Video controller.

On first run, the file `system.properties` will be created in your data directory, *you* must add `is_default=true` as the first line in order to force the wizard to run. If the file isn't created automatically, create it yourself.

Restart the docker, visit http://localhost:7080 and you'll start the Unifi Video wizard.

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
