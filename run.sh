#!/bin/bash
set -e

# Options fed into unifi-video script
unifi_video_opts=""

# Graceful shutdown, used by trapping SIGTERM
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

# Check new certificate and import it to keystore
pushd /var/lib/unifi-video >/dev/null
if [ -f "cert/cert.pem" -a -f "cert/privkey.pem" ]; then
    # convert cert & key
    mkdir certificates
    openssl x509 -outform DER -in cert/cert.pem -out certificates/ufv-server.cert.der
    openssl pkcs8 -topk8 -nocrypt -in cert/privkey.pem -out certificates/ufv-server.key.der
    rm cert/cert.pem cert/privkey.pem

    # insert / replace the config file
    if grep -q '^[^#]*ufv\.custom\.certs\.enable' system.properties; then
        sed '/^[^#]*ufv\.custom\.certs\.enable/cufv.custom.certs.enable = true' -i system.properties
    else
        echo 'ufv.custom.certs.enable = true' >> system.properties
    fi

    # remove old keys, controller will try to re-generate keys
    for i in keystore cam-keystore ufv-truststore; do
        mv $i $i.bak
    done
    cd /usr/lib/unifi-video/conf/evostream/
    for i in server.crt server.key; do
        mv $i $i.bak
    done
fi
popd >/dev/null

set +e

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
