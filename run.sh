#!/bin/bash

function graceful_shutdown {
  echo -n "Stopping unifi-video... " 
  /usr/sbin/unifi-video --nodetach stop
  if [[ $? -eq 0 ]]; then
    echo "done."
    exit 0
  else
    echo "failed."
    exit 1
  fi
}

# Trap SIGTERM for graceful exit
trap graceful_shutdown SIGTERM

# Run the unifi-video daemon the unifi-video way
echo -n "Starting unifi-video... "
/usr/sbin/unifi-video start
echo "done."

while true; do
  sleep 1
done
