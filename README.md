# Important
Unifi Video 3.8.0 and + requires a *new* port, 7442. Cameras that update their firmware will *not* be able to connect until `-p 7442:7442` is added to the run command.

# unifi-video-controller

This docker image runs the unifi-video controller on Ubuntu. Originally intended for Unraid 6.x, it should run fine anywhere.

Set your local data, videos and logs directories in the `docker run` command. You can also specify a custom user and group for the daemon to run as.

The first run should create the file `system.properties` in your data directory. If it doesn't, create it yourself. *You* must add `is_default=true` as the first line in order to force the wizard to run.

Restart the docker, visit http://localhost:7080 or http://<ip.address>:7080/ to start the Unifi Video wizard.

## Run it

This example `docker run` command needs some values filled in, but is otherwise ready to use.

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

## tmpfs mount error

```
mount: tmpfs is write-protected, mounting read-only
mount: cannot mount tmpfs read-only
```

If you get this tmpfs mount error, add `--security-opt apparmor:unconfined \` to your list of run options. This error has been seen on Ubuntu, but may occur on other platforms as well.

## Changelog

### 3.9.2-2
* Use MongoDB 3.4 repo from MongoDB.
* Update `beta` github branch to `master`.
* Add `release` branch to github and switch Docker Hub's `latest` tag to `release` branch.
* Setup tagging in Docker Hub and created tag for 3.9.0 and 3.9.2.
* Switch videos volume location from `/usr/lib/unifi-video/data/videos` to `/var/lib/unifi-video/videos`.
* Use Docker's `ENTRYPOINT` instead of `CMD`.

### 3.9.2-1
* Update Unifi Video to 3.9.2
* Add `tzdata` package to fix issue #56 w/ 3.9.2
* Remove logs volume.
* Improve permissions fixing in `run.sh`.
