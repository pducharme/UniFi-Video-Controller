# unifi-video-controller

This docker image runs the unifi-video controller on Ubuntu. Originally intended for Unraid 6.x, it should run fine anywhere.

Set your local data, videos and logs directories in the `docker run` command. You can also specify a custom user and group for the daemon to run as.

The first run should create the file `system.properties` in your data directory. If it doesn't, create it yourself. *You* must add `is_default=true` as the first line in order to force the wizard to run.

Restart the docker, visit http://localhost:7080 or http://<ip.address>:7080/ to start the Unifi Video wizard.

## Run it
```
docker run \
        --name unifi-video \
        --cap-add SYS_ADMIN \
        --cap-add DAC_READ_SEARCH \
        -p 7443:7443 \
        -p 7445:7445 \
        -p 7446:7446 \
        -p 7447:7447 \
        -p 7080:7080 \
        -p 6666:6666 \
        -v <data dir>:/var/lib/unifi-video \
        -v <videos dir>:/usr/lib/unifi-video/data/videos \
        -v <logs dir>:/var/log/unifi-video \
        -e TZ=America/Los_Angeles \
        -e PUID=99 \
        -e PGID=100 \
        pducharme/unifi-video-controller
```
