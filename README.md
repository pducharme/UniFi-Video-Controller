# Docker image for UniFi Video 

UniFi Video is end-of-life and not supported anymore by Ubiquiti. But if you really have to you still can run the latest UniFi Video v3.10.13 using Docker on AMD64-based systems. This image contains a patch for log4j vulnerability [CVE-2021-44228](https://www.cvedetails.com/cve/CVE-2021-44228/). Consider using a VPN if you want to access the NVR remotely. Do not expose UniFi Video directly to the internet.

This is a fork of [pducharme/UniFi-Video-Controller](https://github.com/pducharme/UniFi-Video-Controller).

- Changed base image from `phusion/baseimage:0.11` to `ghcr.io/linuxserver/baseimage-ubuntu:bionic`.
- Changed the mitigation method from disguising log4j v2.17.0 as v2.1.0 to [removing the JndiLookup class from the classpath](https://logging.apache.org/log4j/2.x/security.html#log4j-2-x-mitigation-3) of the included log4j v2.1.0 in UniFi Video.
- Various other small fixes and optimizations.
- Maybe someday I'll update the Dockerfile for S6 overlay support and better permission and ownership control.

Grab a copy of the [UniFi Video v3.10.13 Debian installer package](https://dl.ubnt.com/firmwares/ufv/v3.10.13/unifi-video.Ubuntu18.04_amd64.v3.10.13.deb) if you want to archive it. The Dockerfile used to build the image depends on the availability of this package.

## Camera compatibility

The latest supported G3 camera firmware for UniFi Video is v4.23.8. Firmware v4.30.0 is for Protect and is not compatible with UniFi Video. To downgrade, use the Web UI of your camera (not UniFi video). You don't need to upgrade if your cameras are running an older firmware. UniFi Video will do this for you.

- [UVC-G3](https://dl.ui.com/firmwares/uvc/v4.23.8/UVC.S2L_4.23.8.bin)
- [UVC-G3-AF](https://dl.ui.com/firmwares/uvc/v4.23.8/UVC.S2L_4.23.8.bin)
- [UVC-G3-BULLET](https://dl.ui.com/firmwares/uvc/v4.23.8/UVC.S2L_4.23.8.bin)
- [UVC-G3-DOME](https://dl.ui.com/firmwares/uvc/v4.23.8/UVC.S2L_4.23.8.bin)
- [UVC-G3-FLEX](https://dl.ui.com/firmwares/uvc/v4.23.8/UVC.S2L_4.23.8.bin)
- [UVC-G3-MICRO](https://dl.ui.com/firmwares/uvc/v4.23.8/UVC.S2L_4.23.8.bin)
- [UVC-G3-PRO](https://dl.ui.com/firmwares/uvc/v4.23.8/UVC.S2L_4.23.8.bin)

## Usage

Starting with UniFi Video 3.10, in-place upgrades are not fully supported. It is recommended to generate a backup of your existing configuration using the web UI and start with a clean data folder when you have the image up and running. Restore the backup from the web UI setup wizard.

1. Adjust and use the `docker run` command or Docker Compose file below.
2. Make sure the ownership and permissions of the attached volumes are set correctly.
3. Start the container and visit http://localhost:7080 to start the UniFi Video wizard.

### Building image from scratch

The example `docker run` command and Docker Compose file will pull the latest released prebuilt image from Docker Hub. However, you can build your own image using the `docker build https://github.com/vuhuy/docker-unifi-video.git -t snoopdoge90/unifi-video:latest` command. Check the [Docker documentation](https://docs.docker.com/engine/reference/commandline/build/) to build a specific tag or branch.

### Environment variables

| Name | Default | Description |
| ---- | ------- | ----------- |
| DEBUG | `0` | Verbose output from container and UniFi Video. Set to `0` to disable and `1` to enable. |
| USE_UNIFI_TMPFS | `no` | Set to `yes` if you want the UniFi Video application to create a TMPFS memory cache for video recordings. |
| USE_HOST_TMPFS | `no` | Set to `yes` if you want to use a host TMPFS mount as a memory cache for video recordings. |
| PUID | `1000` | The user identifier used to run the daemon. |
| PGID | `1000` | The group identifier used to run the daemon. |
| UMASK | `002` | Umask for writing files. |
| UNIFI_VIDEO_VERSION | `3.10.13` | UniFi Video version to fetch from the Ubiquiti repositories. |
| MONGODB_VERSION | `4.0.28` | MongoDB 4.x version to fetch from the MongoDB repositories. |

UniFi Video needs a cache for storing recordings. Using a disk cache can degrade the expected lifespan and performance of your storage. It is recommended to use a TMPFS memory cache. Docker can mount a TMPFS for you. Set USE_UNIFI_TMPFS to `no`, USE_HOST_TMPFS to `yes` and define a TMPFS mount on `/var/cache/unifi-video` in your Docker run command or Compose file.

### Run example

Adjust and/or create the local paths (`local-path:container-path`) to their desired values. Do not forget to set the correct permissions and ownership (should be the same as the specified `PUID` and `PGID`).

```shell
docker run -d \
  --name=unifi-video \
  -p 6666:6666 \
  -p 7080:7080 \
  -p 7442:7442 \
  -p 7443:7443 \
  -p 7445:7445 \
  -p 7446:7446 \
  -p 7447:7447 \
  -v /opt/unifi-video/data:/var/lib/unifi-video \
  -v /srv/unifi-video/videos:/var/lib/unifi-video/videos \
  -e TZ=Europe/Amsterdam \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USE_UNIFI_TMPFS=no \
  -e USE_HOST_TMPFS=yes \
  --tmpfs /var/cache/unifi-video \
  --cap-add DAC_READ_SEARCH \
  --restart unless-stopped \
  snoopdoge90/unifi-video:latest
```

### Compose example

Adjust and/or create the local paths (`local-path:container-path`) to their desired values. Do not forget to set the correct permissions and ownership (should be the same as the specified `PUID` and `PGID`).

```yaml
version: '3'
services:
  unifi-video:
    image: snoopdoge90/unifi-video:latest
    container_name: unifi-video
    ports:
      - 6666:6666
      - 7080:7080
      - 7442:7442
      - 7443:7443
      - 7445:7445
      - 7446:7446
      - 7447:7447
    volumes:
      - /opt/unifi-video/data:/var/lib/unifi-video
      - /srv/unifi-video/videos:/var/lib/unifi-video/videos
    environment:
      - TZ=Europe/Amsterdam
      - PUID=1000
      - PGID=1000
      - USE_UNIFI_TMPFS=no
      - USE_HOST_TMPFS=yes
    tmpfs:
      - /var/cache/unifi-video
    cap_add:
      - DAC_READ_SEARCH
    restart: unless-stopped
```
```shell
docker compose up -d
```

## Troubleshooting

Enabling debugging makes the container and UniFi Video more verbose to help with troubleshooting. Add `-e DEBUG=1` to your Docker run command or add `- DEBUG=1` the `environment` section of your Docker Compose file. Run your container in the foreground, omitting the `-d` flag in your `docker run` command or `docker compose up` command.

### Expected errors

When starting with a new fresh setup, you are greeted with a few errors. This is not Docker-related and expected behavior of UniFi Video v3.10.13 when there is no configuration present. Everything should work just fine and the errors will disappear once everything is configured.

From the Docker output:

```
Exception in thread "EmsInitTask" java.lang.NullPointerException
 at com.ubnt.airvision.service.ems.C.void.new(Unknown Source)
 at com.ubnt.airvision.service.ems.C$1.run(Unknown Source)
 at java.lang.Thread.run(Thread.java:748)
```

From the UniFi Video logs:

```
1678707143.638 2023-03-13 12:32:23.638/CET: ERROR  [uv.db.svc] Failed to acquire client connection null in MongoDb-Connecting
```

This error will unfortunately persist:

```
2023-03-13 12:32:22,234 ERROR Unable to locate appender ConsoleAppender for logger
```

### No recordings

Check the permissions and ownership of the folder or volume mounted to the container's `/var/lib/unifi-video/videos` path.

### Cannot view live camera streams

The SSL certificate used by UniFi Video must be trusted by your browser if you want to watch live camera streams. There are three options available to achieve this. You can either trust the default certificate served by UniFi Video, create an SSL exception for both `https://<url to unifi video>:7443` and `https://<url-to-docker-host>:7446`, or load your own trusted SSL certificate for UniFi Video.

Below is an example to change the default SSL certificate with a PEM formatted server certificate, an unencrypted PEM formatted private key, OpenSSL, and [KeyStore Explorer](https://keystore-explorer.org).

1. Stop the UniFi Video container.
2. If you use a self-signed certificate without any (intermediate) certificate authorities you can skip this step. Otherwise, create a PEM-formatted certificate chain starting with your server certificate while working down to the root certificate authority.
   ```
   -----BEGIN CERTIFICATE-----
   <contents of your server certificate>
   -----END CERTIFICATE-----
   -----BEGIN CERTIFICATE-----
   <contents of your intermediate CA>
   -----END CERTIFICATE-----
   -----BEGIN CERTIFICATE-----
   <contents of your root CA>
   -----END CERTIFICATE-----
   ```
3. Use OpenSSL to create a PCKS#12 formatted file containing your server certificate/certificate chain and private key.
   ```
   openssl pkcs12 -export -in <your-certificate-or-certificate-chain.crt> -inkey <your-private-key.key> -out <the-output-file.pfx>
   ```
4. Create a copy of the UniFi Video keystore. The keystore is saved as file called `keystore` located in `/var/lib/unifi-video`. This path should be a Docker volume or a path on your host mounted to the container.
5. Open your copy of the keystore in KeyStore Explorer. Use the password `ubiquiti` when asked.
6. Delete the existing entry `airvision` from the keystore.
7. Navigate to *Tools* > *Import Key Pair* and import the PKCS12 file from step 2. The new alias of the entry should be `airvision` and protected with the password `ubiquiti`.
8. Save the keystore and exit KeyStore Explorer.
9. Replace the original `keystore` file with your copy. Make sure you set the same owner and permissions as the original file.
10. Restart your container.

### Playback controls not working on Firefox

The UniFi Video web UI uses certain browser functionalities for video playback that are not supported by Firefox. Use Chrome or another supported browser instead.

### Stuck at upgrading screen with Docker on Windows

UniFi Video can hang on the "upgrading" screen on startup on Windows. You must create a volume (e.g. `docker volume create UnifiVideoDataVolume`) and use that volume for `/var/lib/unifi-video` by changing the `docker run` command or Composer file (e.g. `UnifiVideoDataVolume:/var/lib/unifi-video`). After upgrading, you can change it back to any directory outside the Docker volume (e.g. `D:\Recordings:/var/lib/unifi-video/videos`).