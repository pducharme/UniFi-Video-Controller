## Version 3.9.2

- Upgraded to Unifi-Video 3.9.2
- Upgraded to Mongo 3.4
- Started using tags for Docker builds, i.e. `pducharme/unifi-video-controller:3.9.2`
- Added a `--verbose` option to `unifi_video_opts`
- Switched to `ENTRYPOINT` rather than `CMD` for Dockerfile start option
- Added support for providing TLS certificates

