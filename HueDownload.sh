#!/bin/bash

VERSION="1708.5"

DELAY_BETWEEN_CHECKS=5

sleep 10

HUE_IP=$(curl https://www.meethue.com/api/nupnp 2> /dev/null | jq -r ".[0].internalipaddress")
HUE_USER=vSuYBJAton1scEhPyDf4ep85GgmRyFvjJfBjYHIC

echo "$(date): Script version ${VERSION} started with IP ${HUE_IP} and user ${HUE_USER}" >> HueDownloadLog

while true; do

curl -s -silent -H "Accept: application/json" -X GET http://${HUE_IP}/api/${HUE_USER}/ > HueState
