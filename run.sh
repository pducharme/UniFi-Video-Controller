#!/bin/bash
unifi_video_opts=""

function graceful_shutdown {
  echo -n "Stopping unifi-video... " 
  if /usr/sbin/unifi-video --nodetach stop; then
    echo "done."
    exit 0
  else
    echo "failed."
    exit 1
  fi
}

# Trap SIGTERM for graceful exit
trap graceful_shutdown SIGTERM

# No debug mode set via env, default to off
if [[ -z ${DEBUG} ]]; then
  DEBUG=0
fi

# Run with --debug if DEBUG=1
if [[ ${DEBUG} -eq 1 ]]; then
  echo "[debug] Running unifi-video service with --debug."
  unifi_video_opts="--debug"
fi

# Run the unifi-video daemon the unifi-video way
echo -n "Starting unifi-video... "
if /usr/sbin/unifi-video "${unifi_video_opts}" start; then
  echo "done."
else
  echo "failed."
  exit 1
fi

while true; do
  sleep 1
done
