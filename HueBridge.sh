#!/bin/bash

sleep 10

HUE_IP=$(curl https://www.meethue.com/api/nupnp 2> /dev/null | jq -r ".[0].internalipaddress")
#HUE_IP=192.168.1.11
HUE_USER=erikvennink

PUSHOVER_TOKEN=azw2c2dw29x8o96ae2m2cp5gtx7mr4
PUSHOVER_USER=uPnTmp5puvngjiUYpGMGQ3AgUKjhgZ
PUSHOVER_NOTIFICATION_TITLE="Hue"
PUSHOVER_NOTIFICATION_MESSAGE_OK="Hue bridge settings updated!"
PUSHOVER_NOTIFICATION_MESSAGE_NOK="Hue bridge settings update failed!!!"

#GROUPS
GRP_WOONKAMER=1
GRP_KEUKEN=2
GRP_HAL=3
GRP_SLAAPKAMER=4
GRP_KANTOOR=5
GRP_TOILET=6
GRP_BADKAMER=7
GRP_FANNORMAAL=8
GRP_FANHOOG=9
GRP_BEVOCHTIGER=10
GRP_DAGVERLICHTING=11

#SENSORS
TAP_WOONKAMER="2"
TAP_KEUKEN="31"
TAP_VOORDEUR="32"
TAP_SLAAPKAMERDEUR="33"
TAP_SLAAPKAMERBED="34"
TAP_KANTOOR="35"
TAP_BADKAMER="36"
MOT_WOONKAMER_MOT="7"
MOT_WOONKAMER_EXTRA="8"
MOT_WOONKAMER_TEMP="6"
MOT_

echo "$(date): Script started with IP ${HUE_IP} and used ${HUE_USER}" >> HueBridgeLog

curl -s -H "Accept: application/json" -X PUT --data '{"on":true,"bri": 150,"sat": 150,"hue":15000,"transitiontime":50}' http://${HUE_IP}/api/${HUE_USER}/groups/${GRP_KEUKEN}/action

#curl -s -silent -H "Accept: application/json" -X PUT --data '{"on":true}' http://${HUE_IP}/api/${HUE_USER}/sensors/41/config
