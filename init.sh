#!/bin/bash
set -e

# Change user nobody's UID to custom or match unRAID.
export PUID
PUID=$(echo "${PUID}" | sed -e 's/^[ \t]*//')
if [[ ! -z "${PUID}" ]]; then
  echo "[info] PUID defined as '${PUID}'" | ts '%Y-%m-%d %H:%M:%.S'
else
  echo "[warn] PUID not defined (via -e PUID), defaulting to '99'" | ts '%Y-%m-%d %H:%M:%.S'
  export PUID="99"
fi

# Set user unify-video to specified user id (non unique)
usermod -o -u "${PUID}" unifi-video &>/dev/null

# Change group users to GID to custom or match unRAID.
export PGID
PGID=$(echo "${PGID}" | sed -e 's/^[ \t]*//')
if [[ ! -z "${PGID}" ]]; then
  echo "[info] PGID defined as '${PGID}'" | ts '%Y-%m-%d %H:%M:%.S'
else
  echo "[warn] PGID not defined (via -e PGID), defaulting to '100'" | ts '%Y-%m-%d %H:%M:%.S'
  export PGID="100"
fi

# Set group users to specified group id (non unique)
groupmod -o -g "${PGID}" unifi-video &>/dev/null

# check for presence of perms file, if it exists then skip setting
# permissions, otherwise recursively set on volume mappings for host
if [[ ! -f "/var/lib/unifi-video/perms.txt" ]]; then
  echo "[info] Setting permissions recursively on volume mappings..." | ts '%Y-%m-%d %H:%M:%.S'

  volumes=( "/var/lib/unifi-video" "/var/log/unifi-video" )

  set +e
  chown -R "${PUID}":"${PGID}" "${volumes[@]}"
  exit_code_chown=$?
  chmod -R 775 "${volumes[@]}"
  exit_code_chmod=$?
  set -e

  if (( exit_code_chown != 0 || exit_code_chmod != 0 )); then
    echo "[warn] Unable to chown/chmod ${volumes[*]}, assuming SMB mountpoint"
  fi

  echo "This file prevents permissions from being applied/re-applied to /config, if you want to reset permissions then please delete this file and restart the container." > /var/lib/unifi-video/perms.txt
else
  echo "[info] Permissions already set for volume mappings" | ts '%Y-%m-%d %H:%M:%.S'
fi


exec /run.sh
