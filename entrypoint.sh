#!/bin/bash

set -meuo pipefail

AURORACOIN_DIR=/aurora/.auroracoin/
AURORACOIN_CONF=/aurora/.auroracoin/auroracoin.conf

if [ -z "${AURORACOIN_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  AURORACOIN_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c AURORACOINho '')
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
  /aurora/auroracoin/src/auroracoind -rpcbind=:12341 -rpcallowip=* -printtoconsole=1
else
  exec "$@"
fi
