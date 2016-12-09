#!/bin/bash
DELAY_BETWEEN_CHECKS=15

sleep 10

HUE_IP=$(curl https://www.meethue.com/api/nupnp 2> /dev/null | jq -r ".[0].internalipaddress")
HUE_USER=erikvennink

PUSHOVER_TOKEN=azw2c2dw29x8o96ae2m2cp5gtx7mr4
PUSHOVER_USER=uPnTmp5puvngjiUYpGMGQ3AgUKjhgZ
PUSHOVER_ALARM_TITLE="ALARM"
PUSHOVER_ALARM_MESSAGE="MOTION ON!!!"
PUSHOVER_NOTIFICATION_TITLE="Hue"
PUSHOVER_NOTIFICATION_MESSAGE_ON="Home ON"
PUSHOVER_NOTIFICATION_MESSAGE_OFF="Home OFF"

HOME_STATE=0 # Assumes home is off when script starts. Will correct itself
MOTION_STATE=0 # Assumes home is off when script starts. Will correct itself

SKIP=1

echo "Script started on $(date) with IP ${HUE_IP} and used ${HUE_USER}" >> log

while true; do

HOME_OLD=${HOME_STATE}
MOTION_OLD=${MOTION_STATE}

CHECK_LIGHTS=$(curl -s -silent -H "Accept: application/json" -X GET http://${HUE_IP}/api/${HUE_USER}/lights/33/ | grep '{"state":{"on":true')
CHECK_MOTION=$(curl -s -silent -H "Accept: application/json" -X GET http://${HUE_IP}/api/${HUE_USER}/sensors/ | grep '{"state":{"presence":true')

if [ "${CHECK_LIGHTS}" ]; then
  HOME_STATE=1
else
  HOME_STATE=0
fi

if [ "${CHECK_MOTION}" ]; then
  MOTION_STATE=1
else
  MOTION_STATE=0
fi

#echo "$(date): Home State was ${HOME_OLD}, is now ${HOME_STATE}. Motion State was ${MOTION_OLD}, is now ${MOTION_STATE}." >> log

if [[ ${HOME_STATE} = ${HOME_OLD} ]]; then
  HOME_STATE=${HOME_OLD}
  #echo "Home state not changed"
  if [[ ${HOME_STATE} = 0 ]]; then
    if [[ ${MOTION_STATE} = ${MOTION_OLD} ]]; then
      #echo "Motion not changed"
      MOTION_STATE=${MOTION_OLD}
    elif [[ ${SKIP} = 0 ]]; then
      #echo "Motion changed and not skipping"
      if [[ ${MOTION_STATE} = 1 ]]; then
        echo "$(date): ALARM: Motion is ON" >> log
        curl -s -silent -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=${PUSHOVER_ALARM_TITLE}" -F "message=${PUSHOVER_ALARM_MESSAGE}" https://api.pushover.net/1/messages.json
      fi
    fi
  fi
elif [[ ${SKIP} = 0 ]]; then
  #echo "Home state changed and not skipping"
  if [[ ${HOME_STATE} = 1 ]]; then
    echo "$(date): Home state changed to ON" >> log
    curl -s -silent -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=${PUSHOVER_NOTIFICATION_TITLE}" -F "message=${PUSHOVER_NOTIFICATION_MESSAGE_ON}" https://api.pushover.net/1/messages.json
  else
    echo "$(date): Home state changed to OFF" >> log
    curl -s -silent -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=${PUSHOVER_NOTIFICATION_TITLE}" -F "message=${PUSHOVER_NOTIFICATION_MESSAGE_OFF}" https://api.pushover.net/1/messages.json
    curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/7/state
  fi
fi

SKIP=0

#echo "$(date): NEXT ROUND......in ${DELAY_BETWEEN_CHECKS} seconds" >> log

sleep ${DELAY_BETWEEN_CHECKS}

#echo "$(date): Starting now..." >> log

done # End of perpetual loop
