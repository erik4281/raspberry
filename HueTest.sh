#!/bin/bash

HUE_IP=$(curl https://www.meethue.com/api/nupnp 2> /dev/null | jq -r ".[0].internalipaddress")
HUE_USER=erikvennink

#TIMESLOTS
DAYTIME="address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"
NIGHTTIME='{"address":"/config/localtime","operator":"in","value":"T00:00:00/T06:00:00"}'

#GROUPS + SCENES
GRP_WOONKAMER=1
SCN_WOONKAMER_AVOND="lY5rBuP7YPzNSxR"
SCN_WOONKAMER_NACHT="kbwTjMUg7yd-fCn"
SCN_WOONKAMER_OFF="Y1efqVouGJOT-Rt"
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
TAP_WOONKAMER=2
TAP_KEUKEN=31
TAP_VOORDEUR=32
TAP_SLAAPKAMERDEUR=33
TAP_SLAAPKAMERBED=34
TAP_KANTOOR=35
TAP_BADKAMER=36
MOT_WOONKAMER_MOT=7
MOT_WOONKAMER_EXTRA=8
MOT_WOONKAMER_TEMP=6
MOT_EETKAMER_MOT=41
MOT_EETKAMER_EXTRA=42
MOT_EETKAMER_TEMP=40
MOT_KEUKEN_MOT=12
MOT_KEUKEN_EXTRA=13
MOT_KEUKEN_TEMP=11
MOT_HAL_MOT=18
MOT_HAL_EXTRA=19
MOT_HAL_TEMP=17
MOT_SLAAPKAMER_MOT=16
MOT_SLAAPKAMER_EXTRA=20
MOT_SLAAPKAMER_TEMP=15
MOT_KANTOOR_MOT=26
MOT_KANTOOR_MOT=27
MOT_KANTOOR_TEMP=25
MOT_TOILET_MOT=22
MOT_TOILET_EXTRA=23
MOT_TOILET_TEMP=21
MOT_BADKAMER_MOT=30
MOT_BADKAMER_EXTRA=37
MOT_BADKAMER_TEMP=39
REMOTE=9
TRG_WOONKAMER=4

echo ${DAYTIME}

echo "$(date): TESTScript started with IP ${HUE_IP} and used ${HUE_USER}" >> HueBridgeLog

curl -s -H "Accept: application/json" -X PUT --data '{"name":"MotionSensor 41.day-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"},{"address":"/sensors/57/state/presence","operator":"eq","value":"true"},{"address":"/sensors/57/state/presence","operator":"dx"},{"address":"/sensors/55/state/status","operator":"lt","value":"1"},{"address":"/sensors/42/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/1/action","method":"PUT","body":{     "scene": "lY5rBuP7YPzNSxR"    }},{"address":"/groups/11/action","method":"PUT","body":{     "scene": "JpsE2311TGWeCc4"    }},{"address":"/sensors/55/state","method":"PUT","body":{     "status": 1    }}]}' http://${HUE_IP}/api/${HUE_USER}/rules/1/

echo "$(date): TESTScript finished succesfully" >> HueBridgeLog
