#!/bin/bash

# Trap SIGTERM for graceful exit
trap 'echo -n "Stopping unifi-video... " ; /usr/sbin/unifi-video --nodetach stop ; echo "done." ; exit 0' SIGTERM

# Run the unifi-video daemon the unifi-video way
echo -n "Starting unifi-video... "
/usr/sbin/unifi-video start
echo "done."

while true; do
  sleep 5
done
