#! /usr/bin/env bash
set -e

if ! adduser "${USERNAME}" --disabled-password --force-badname --gecos "" ; then
  echo "failed to add user ${USERNAME}"
  exit 1
fi

if ! chown --recursive "${USERNAME}:${USERNAME}" /scans ; then
  echo "failed to chown /scans"
  exit 1
fi

if ! chown --recursive "${USERNAME}:${USERNAME}" /opt/brother ; then
  echo "failed to chown /opt/brother"
  exit 1
fi

env > /opt/brother/scanner/env.txt

if ! su - "${USERNAME}" -c "brsaneconfig4 -a name=${NAME} model=${MODEL} ip=${IPADDRESS}" ; then
  echo "adding scanner failed"
  brsaneconfig4 -q
  exit 1
fi

if ! su - "${USERNAME}" -c brscan-skey ; then
  echo "brscan-skey failed"
  exit 1
fi

while true;
  do
    echo "listing scanners"
    brscan-skey -l
    sleep 1m
  done
exit 0
