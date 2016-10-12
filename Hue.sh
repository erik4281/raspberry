#!/bin/bash
DELAY_BETWEEN_CHECKS=15
PRESENCE_SENSOR=33
MOTION_SENSOR=18
HUE_IP=10.0.1.102
PUSHOVER_TOKEN=azw2c2dw29x8o96ae2m2cp5gtx7mr4
PUSHOVER_USER=uPnTmp5puvngjiUYpGMGQ3AgUKjhgZ
PUSHOVER_ALARM_TITLE=ALARM
PUSHOVER_ALARM_MESSAGE=MOTION ON!!!
PUSHOVER_NOTIFICATION_TITLE=Hue
PUSHOVER_NOTIFICATION_MESSAGE_ON=Home ON
PUSHOVER_NOTIFICATION_MESSAGE_OFF=Home ON
HOME_STATE=0 # Assumes home is off when script starts. Will correct itself
MOTION_STATE=0 # Assumes home is off when script starts. Will correct itself
SKIP=1

sleep 10

while true; do

HOME_OLD=${HOME_STATE}
MOTION_OLD=${MOTION_STATE}

curl -s -silent -H "Accept: application/json" -X GET http://${HUE_IP}/api/erikvennink/lights/${PRESENCE_SENSOR}/ | grep '{"on":true'

if [ $? -eq 0 ]; then
  HOME_STATE=1
else
  HOME_STATE=0
fi

curl -s -silent -H "Accept: application/json" -X GET http://${HUE_IP}/api/erikvennink/sensors/${MOTION_SENSOR}/ | grep '{"presence":true'

if [ $? -eq 0 ]; then
  MOTION_STATE=1
else
  MOTION_STATE=0
fi

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
        #echo "Motion is ON"
        curl -s -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=ALARM" -F "message=MOTION ON!!!" https://api.pushover.net/1/messages.json
      fi
    fi
  fi
elif [[ ${SKIP} = 0 ]]; then
  #echo "Home state changed and not skipping"
  if [[ ${HOME_STATE} = 1 ]]; then
    #echo "Home state now ON"
    curl -s -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=Hue" -F "message=Home ON" https://api.pushover.net/1/messages.json
  else
    #echo "HOME state now OFF"
    curl -s -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=Hue" -F "message=Home OFF" https://api.pushover.net/1/messages.json
  fi
fi

SKIP=0

#echo "NEXT ROUND......"

sleep ${DELAY_BETWEEN_CHECKS}

#echo "...Starting now..."

done # End of perpetual loop
