#!/bin/bash
DELAY_BETWEEN_CHECKS=15
#HUE_IP=10.0.1.102
HUE_IP=curl https://www.meethue.com/api/nupnp 2> /dev/null | jq -r ".[0].internalipaddress"
HUE_USER=erikvennink

HUE_LIGHT_LIVING_DEATH_STAR=1
HUE_LIGHT_LIVING_LOTEK_LEFT=2
HUE_LIGHT_LIVING_LOTEK_RIGHT=3
HUE_LIGHT_LIVING_FAMILY_DESIGN=4
HUE_LIGHT_LIVING_HUE_IRIS=5
HUE_LIGHT_LIVING_FRISBEE=6
HUE_LIGHT_LIVING_PARACHUTE=7
HUE_LIGHT_KITCHEN_LEFT=8
HUE_LIGHT_KITCHEN_MIDDLE=9
HUE_LIGHT_KITCHEN_RIGHT=10
HUE_LIGHT_KITCHEN_STORAGE=11
HUE_LIGHT_EXTRA_1=12
HUE_LIGHT_HALLWAY_1=13
HUE_LIGHT_HALLWAY_2=14
HUE_LIGHT_HALLWAY_3=15
HUE_LIGHT_BEDROOM_CEILING=16
HUE_LIGHT_BEDROOM_AURA=17
HUE_LIGHT_STUDY_AURA=18
HUE_LIGHT_BEDROOM_CLOSET=19
HUE_LIGHT_STUDY_CEILING=20
HUE_LIGHT_STUDY_TIZIO=21
HUE_LIGHT_TOILET=22
HUE_LIGHT_BATHROOM_CEILING=23
HUE_LIGHT_HUMIDIFIER=24
HUE_LIGHT_KITCHEN_FAN=25
HUE_LIGHT_LIVING_KITCHEN_LEFT=27
HUE_LIGHT_LIVING_KITCHEN_MIDDLE=28
HUE_LIGHT_LIVING_KITCHEN_RIGHT=29
HUE_LIGHT_BATHROOM_MIRROR_LEFT=30
HUE_LIGHT_BATHROOM_MIRROR_MIDDLE=31
HUE_LIGHT_BATHROOM_MIRROR_RIGHT=32
HUE_LIGHT_FAN_NORMAL=33
HUE_LIGHT_FAN_HIGH=34
HUE_LIGHT_LIVING_IPAD=35
HUE_LIGHT_STUDY_BULB=36

HUE_SENSOR_WOONKAMER=2
HUE_SENSOR_KEUKEN=31
HUE_SENSOR_VOORDEUR=32
HUE_SENSOR_SLAAPKAMER_DEUR=33
HUE_SENSOR_SLAAPKAMER_BED=34
HUE_SENSOR_STUDEERKAMER=35
HUE_SENSOR_BADKAMER=36

HUE_MOTION_HAL_TEMP=17
HUE_MOTION_HAL_MOTION=18
HUE_MOTION_HAL_BRIGHTNESS=19
HUE_MOTION_TOILET_TEMP=21
HUE_MOTION_TOILET_MOTION=22
HUE_MOTION_TOILET_BRIGHTNESS=23

PRESENCE_SENSOR=${HUE_LIGHT_FAN_NORMAL}
MOTION_SENSOR=${HUE_MOTION_HAL_MOTION}

#NEST_TOKEN="c.EjHCsPyAdOOpf8HHY163CFKLyuef5vxPm09oXkVa8VTSgoir4A3LvPRMHjHnSfp2sPGruqTiIC7ihSstLfBB5R6FgH8PximvgzuOS59vBCiJyxXCTFO5gvqtLPpJokQRk5BQlBCKR4O1wb8d"
#NEST_DEVICE="lZXSTK36nq9Zwa-HCbEPo3yS1tl_uH1Z"
#NEST_STRUCTURE="Z5_5mUBP7B2A9oW47MiJ2zSh6g5JdtC_5o7sfZPvWogu9I0W0IC21A"

#NEST_SET_TEMP="curl -L -X PUT \"https://developer-api.nest.com/devices/thermostats/${NEST_DEVICE}/target_temperature_f?auth=${NEST_TOKEN}\" -H \"Content-Type: application/json\" -d \"$1\""
#NEST_GET_TEMP="curl -L https://developer-api.nest.com/devices/thermostats/${NEST_DEVICE}/target_temperature_f\?auth\=${NEST_TOKEN}"
#NEST_SET_HOME="curl -L -X PUT \"https://developer-api.nest.com/structures/${NEST_STRUCTURE}/away?auth=${NEST_TOKEN}\" -H \"Content-Type: application/json\" -d '\"home\"'"
#NEST_SET_AWAY="curl -L -X PUT \"https://developer-api.nest.com/structures/${NEST_STRUCTURE}/away?auth=${NEST_TOKEN}\" -H \"Content-Type: application/json\" -d '\"away\"'"
#NEST_GET_AWAY="curl -L https://developer-api.nest.com/structures/${NEST_STRUCTURE}/away?auth=${NEST_TOKEN}"

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

sleep 10

while true; do

#${NEST_GET_AWAY}

HOME_OLD=${HOME_STATE}
MOTION_OLD=${MOTION_STATE}

curl -s -silent -H "Accept: application/json" -X GET http://${HUE_IP}/api/${HUE_USER}/lights/${PRESENCE_SENSOR}/ | grep '{"on":true'

if [ $? -eq 0 ]; then
  HOME_STATE=1
else
  HOME_STATE=0
fi

curl -s -silent -H "Accept: application/json" -X GET http://${HUE_IP}/api/${HUE_USER}/sensors/${MOTION_SENSOR}/ | grep '{"presence":true'

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
        curl -s -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=${PUSHOVER_ALARM_TITLE}" -F "message=${PUSHOVER_ALARM_MESSAGE}" https://api.pushover.net/1/messages.json
      fi
    fi
  fi
elif [[ ${SKIP} = 0 ]]; then
  #echo "Home state changed and not skipping"
  if [[ ${HOME_STATE} = 1 ]]; then
    #echo "Home state now ON"
    curl -s -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=${PUSHOVER_NOTIFICATION_TITLE}" -F "message=${PUSHOVER_NOTIFICATION_MESSAGE_ON}" https://api.pushover.net/1/messages.json
  else
    #echo "HOME state now OFF"
    curl -s -F "token=${PUSHOVER_TOKEN}" -F "user=${PUSHOVER_USER}" -F "title=${PUSHOVER_NOTIFICATION_TITLE}" -F "message=${PUSHOVER_NOTIFICATION_MESSAGE_OFF}" https://api.pushover.net/1/messages.json
  fi
fi

SKIP=0

#echo "NEXT ROUND......"

sleep ${DELAY_BETWEEN_CHECKS}

#echo "...Starting now..."

done # End of perpetual loop
