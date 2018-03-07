# Important
Starting with Unifi Video 3.8.0, port 7442 is required for secure communication between the nvr and camera. Cameras that update their firmware will *not* be able to connect until `-p 7442:7442` is added to the run command.

# unifi-video-controller

This docker image runs the unifi-video controller on Ubuntu. Originally intended for Unraid 6.x, it should run fine anywhere.

Set your local data and videos directories in the `docker run` command. You can also specify a UID and GID for the daemon to run as.

Restart the docker, visit http://localhost:7080 or http://<ip.address>:7080/ to start the Unifi Video wizard.

# Run it
```
docker run \
        --name unifi-video \
        --cap-add SYS_ADMIN \
        --cap-add DAC_READ_SEARCH \
        -p 1935:1935 \
        -p 6666:6666 \
        -p 7080:7080 \
        -p 7442:7442 \
        -p 7443:7443 \
        -p 7444:7444 \
        -p 7445:7445 \
        -p 7446:7446 \
        -p 7447:7447 \
        -v <data dir>:/var/lib/unifi-video \
        -v <videos dir>:/var/lib/unifi-video/videos \
        -e TZ=America/Los_Angeles \
        -e PUID=99 \
        -e PGID=100 \
        -e DEBUG=1 \
        pducharme/unifi-video-controller
```

# Changing versions

Starting with 3.9.0, releases are tagged. Using `pducharme/unifi-video-controller` or `pducharme/unifi-video-controller:latest` will get you the latest version. You can get a different version by using a specific tag, like `:3.9.0`, `:3.9.2` or `3.9.3`. If you update and have issues, you can quickly switch back to the previously working version.

#  tmpfs mount error

```
mount: tmpfs is write-protected, mounting read-only
mount: cannot mount tmpfs read-only
```

If you get this tmpfs mount error, add `--security-opt apparmor:unconfined \` to your list of run options. This error has been seen on Ubuntu, but may occur on other platforms as well.
