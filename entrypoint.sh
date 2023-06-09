#!/bin/bash

set -meuo pipefail

AURORACOIN_DIR=/aurora/.auroracoin/
AURORACOIN_CONF=/aurora/.auroracoin/auroracoin.conf

if [ -z "${AURORACOIN_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  AURORACOIN_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')
fi

if [ ! -e "${AURORACOIN_CONF}" ]; then
  tee -a >${AURORACOIN_CONF} <<EOF
server=1
rpcuser=${AURORACOIN_RPCUSER:-aurorarpc}
rpcpassword=${AURORACOIN_RPCPASSWORD}
rpcclienttimeout=${AURORACOIN_RPCCLIENTTIMEOUT:-30}
EOF
echo "Created new configuration at ${AURORACOIN_CONF}"
fi

if [ $# -eq 0 ]; then
  /usr/local/bin/auroracoind -rpcbind=0.0.0.0 -rpcport=12341 -rpcallowip=0.0.0.0/0 -printtoconsole=1
else
  exec "$@"
fi
