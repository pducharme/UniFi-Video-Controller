# unifi-video-controller

This is a docker for use on Unraid 6.x for the UniFi-Video controller.

Please note that on first run, it will create a system.properties that you will need to edit to add on the first line: is_default=true

After that, restart the docker and you'll be great by the Unifi-Video wizard that will let you set a User/Pass for your Unifi-Video controller.

## Run it
```
docker run \
        -p 7443:7443 -p 7445:7445 -p 7446:7446 -p 7447:7447 -p 7080:7080 -p 6666:6666 \
	-v unifi_data:/var/lib/unifi-video -v unifi_videos:/usr/lib/unifi-video/data/videos -v unifi_logs:/var/log/unifi-video  \
        --name unifi \
        pducharme/UniFi-Video-Controller \
```
