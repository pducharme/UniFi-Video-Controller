#!/bin/bash
set -e

# Change user nobody's UID to custom or match unRAID.
export PUID=$(echo "${PUID}" | sed -e 's/^[ \t]*//')
if [[ ! -z "${PUID}" ]]; then
  echo "[info] PUID defined as '${PUID}'" | ts '%Y-%m-%d %H:%M:%.S'
else
  echo "[warn] PUID not defined (via -e PUID), defaulting to '99'" | ts '%Y-%m-%d %H:%M:%.S'
  export PUID="99"
fi

# Set user unify-video to specified user id (non unique)
usermod -o -u "${PUID}" unifi-video &>/dev/null

# Change group users to GID to custom or match unRAID.
export PGID=$(echo "${PGID}" | sed -e 's/^[ \t]*//')
if [[ ! -z "${PGID}" ]]; then
  echo "[info] PGID defined as '${PGID}'" | ts '%Y-%m-%d %H:%M:%.S'
else
  echo "[warn] PGID not defined (via -e PGID), defaulting to '100'" | ts '%Y-%m-%d %H:%M:%.S'
  export PGID="100"
fi

# Set group users to specified group id (non unique)
groupmod -o -g "${PGID}" unifi-video &>/dev/null

exec /run.sh
