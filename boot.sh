#!/bin/bash

# Unofficial bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -eu
set -o pipefail
IFS=$'\n\t'


cat /config/couchpotato.ini \
  > /tmp/couchpotato.ini

exec ${*:1}
