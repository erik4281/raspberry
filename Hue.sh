#!/bin/bash

VERSION="1701.4"

DELAY_BETWEEN_CHECKS=15

sleep 10

HUE_IP=$(curl https://www.meethue.com/api/nupnp 2> /dev/null | jq -r ".[0].internalipaddress")
HUE_USER=vSuYBJAton1scEhPyDf4ep85GgmRyFvjJfBjYHIC

PUSHOVER_TOKEN=azw2c2dw29x8o96ae2m2cp5gtx7mr4
PUSHOVER_USER=uPnTmp5puvngjiUYpGMGQ3AgUKjhgZ
PUSHOVER_NOTIFICATION_TITLE="Hue"
PUSHOVER_NOTIFICATION_MESSAGE_ON="Home ON"
PUSHOVER_NOTIFICATION_MESSAGE_OFF="Home OFF"

HOME_STATE=0 # Assumes home is off when script starts. Will correct itself

SKIP=1

echo "$(date): Script version ${VERSION} started with IP ${HUE_IP} and user ${HUE_USER}" >> HueLog

while true; do

HOME_OLD=${HOME_STATE}

CHECK_LIGHTS=$(curl -s -silent -H "Accept: application/json" -X GET http://${HUE_IP}/api/${HUE_USER}/sensors/43/ | grep '{"state":{"presence":true')

if [ "${CHECK_LIGHTS}" ]; then
  HOME_STATE=1
else
  HOME_STATE=0
fi

if [[ ${HOME_STATE} = ${HOME_OLD} ]]; then
  HOME_STATE=${HOME_OLD}
elif [[ ${SKIP} = 0 ]]; then
  if [[ ${HOME_STATE} = 1 ]]; then
    echo "$(date): Home state changed to ON" >> HueLog
    curl -s -silent -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=${PUSHOVER_NOTIFICATION_TITLE}" -F "message=${PUSHOVER_NOTIFICATION_MESSAGE_ON}" https://api.pushover.net/1/messages.json
  else
    echo "$(date): Home state changed to OFF" >> HueLog
    curl -s -silent -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=${PUSHOVER_NOTIFICATION_TITLE}" -F "message=${PUSHOVER_NOTIFICATION_MESSAGE_OFF}" https://api.pushover.net/1/messages.json
  fi
  
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/11/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/12/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/13/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/15/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/16/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/17/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/19/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/20/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/21/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/23/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/24/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/25/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/27/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/28/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/29/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/31/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/32/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/33/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/35/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/36/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/37/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/39/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/40/config
  curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/41/config
fi

SKIP=0

sleep ${DELAY_BETWEEN_CHECKS}

done # End of perpetual loop
