#!/bin/bash
VERSION="1716.1"

HUE_IP=$(curl https://www.meethue.com/api/nupnp 2> /dev/null | jq -r ".[0].internalipaddress")
HUE_USER=vSuYBJAton1scEhPyDf4ep85GgmRyFvjJfBjYHIC

echo "$(date): Script version ${VERSION} started with IP ${HUE_IP} and user ${HUE_USER}" >> HueBridgeLog

echo 'Sleeping for 3 seconds, then updating sensors'
sleep 3

curl -s -H "Accept: application/json" -X PUT --data '{"config":{"tholddark": 17500}}' http://${HUE_IP}/api/${HUE_USER}\
/sensors/13; echo

curl -s -H "Accept: application/json" -X PUT --data '{"config":{"tholddark": 17500}}' http://${HUE_IP}/api/${HUE_USER}\
/sensors/17; echo

curl -s -H "Accept: application/json" -X PUT --data '{"config":{"tholddark": 25000}}' http://${HUE_IP}/api/${HUE_USER}\
/sensors/21; echo

curl -s -H "Accept: application/json" -X PUT --data '{"config":{"tholddark": 60000}}' http://${HUE_IP}/api/${HUE_USER}\
/sensors/25; echo

curl -s -H "Accept: application/json" -X PUT --data '{"config":{"tholddark": 17500}}' http://${HUE_IP}/api/${HUE_USER}\
/sensors/29; echo

curl -s -H "Accept: application/json" -X PUT --data '{"config":{"tholddark": 25000}}' http://${HUE_IP}/api/${HUE_USER}\
/sensors/33; echo

curl -s -H "Accept: application/json" -X PUT --data '{"config":{"tholddark": 60000}}' http://${HUE_IP}/api/${HUE_USER}\
/sensors/37; echo

curl -s -H "Accept: application/json" -X PUT --data '{"config":{"tholddark": 60000}}' http://${HUE_IP}/api/${HUE_USER}\
/sensors/41; echo


echo "$(date): Script updated sensors" >> HueBridgeLog

echo 'Sleeping for 3 seconds, then deleting rules'
sleep 3

i="1"

while [ $i -lt 140 ]
do
curl -s -H "Accept: application/json" -X DELETE http://${HUE_IP}/api/${HUE_USER}/rules/$i; echo
i=$[$i+1]
done

echo "$(date): Script deleted rules" >> HueBridgeLog

echo 'Sleeping for 3 seconds, then creating new rules'
sleep 3


#Living room lights based on Living TAP
curl -s -H "Accept: application/json" -X POST --data '{\
"name":"TapWoonkamer.1.1",\
"conditions":[\
{"address":"/sensors/2/state/lastupdated","operator":"dx"},\
{"address":"/sensors/2/state/buttonevent","operator":"eq","value":"34"},\
{"address":"/groups/2/state/any_on","operator":"eq","value":"true"}\
],\
"actions":[\
{"address":"/groups/2/action","method":"PUT","body":{"on":false,"transitiontime":50}},\
{"address":"/groups/3/action","method":"PUT","body":{"on":false,"transitiontime":50}},\
{"address":"/sensors/12/config","method":"PUT","body":{"on":true}},\
{"address":"/sensors/20/config","method":"PUT","body":{"on":true}}\
]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

curl -s -H "Accept: application/json" -X POST --data '{\
"name":"TapWoonkamer.1.2",\
"conditions":[{"address":"/sensors/2/state/lastupdated","operator":"dx"},\
{"address":"/sensors/2/state/buttonevent","operator":"eq","value":"34"},\
{"address":"/groups/2/state/any_on","operator":"eq","value":"false"}\
],\
"actions":[\
{"address":"/groups/1/action","method":"PUT","body":{"on":false,"transitiontime":30}},\
{"address":"/groups/2/action","method":"PUT","body":{"on":false,"transitiontime":50}},\
{"address":"/groups/3/action","method":"PUT","body":{"on":false,"transitiontime":50}},\
{"address":"/sensors/12/config","method":"PUT","body":{"on":true}},\
{"address":"/sensors/20/config","method":"PUT","body":{"on":true}}\
]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

curl -s -H "Accept: application/json" -X POST --data '{\
"name":"TapWoonkamer.2",\
"conditions":[\
{"address":"/sensors/2/state/lastupdated","operator":"dx"},\
{"address":"/sensors/2/state/buttonevent","operator":"eq","value":"16"}\
],\
"actions":[\
{"address":"/groups/1/action","method":"PUT","body":{"scene":"2X7964HVeAruuQY"}},\
{"address":"/groups/2/action","method":"PUT","body":{"scene":"GFhk2PPK-24Ztpc"}},\
{"address":"/groups/3/action","method":"PUT","body":{"scene":"EVf24QboVUqvcbW"}},\
{"address":"/sensors/12/config","method":"PUT","body":{"on":false}},\
{"address":"/sensors/20/config","method":"PUT","body":{"on":false}}\
]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

curl -s -H "Accept: application/json" -X POST --data '{\
"name":"TapWoonkamer.3",\
"conditions":[\
{"address":"/sensors/2/state/lastupdated","operator":"dx"},\
{"address":"/sensors/2/state/buttonevent","operator":"eq","value":"17"}\
],\
"actions":[\
{"address":"/groups/1/action","method":"PUT","body":{"scene":"2X7964HVeAruuQY"}},\
{"address":"/groups/2/action","method":"PUT","body":{"on":false}},\
{"address":"/groups/3/action","method":"PUT","body":{"scene":"EVf24QboVUqvcbW"}},\
{"address":"/sensors/12/config","method":"PUT","body":{"on":false}},\
{"address":"/sensors/20/config","method":"PUT","body":{"on":false}}\
]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

curl -s -H "Accept: application/json" -X POST --data '{\
"name":"TapWoonkamer.4",\
"conditions":[\
{"address":"/sensors/2/state/lastupdated","operator":"dx"},\
{"address":"/sensors/2/state/buttonevent","operator":"eq","value":"18"}\
],\
"actions":[\
{"address":"/groups/1/action","method":"PUT","body":{"scene":"S3om3C2hhjyymAW"}},\
{"address":"/groups/2/action","method":"PUT","body":{"scene":"6hLiqYWJ3Xnor8s"}},\
{"address":"/groups/3/action","method":"PUT","body":{"scene":"Ya1-SihTfsUFXeH"}},\
{"address":"/sensors/12/config","method":"PUT","body":{"on":false}},\
{"address":"/sensors/20/config","method":"PUT","body":{"on":false}}\
]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo


#Kitchen lights based on Kitchen TAP
curl -s -H "Accept: application/json" -X POST --data '{\
"name":"TapKeuken.1",\
"conditions":[\
{"address":"/sensors/3/state/lastupdated","operator":"dx"},\
{"address":"/sensors/3/state/buttonevent","operator":"eq","value":"34"}\
],\
"actions":[\
{"address":"/groups/3/action","method":"PUT","body":{"on":false,"transitiontime":30}},\
{"address":"/lights/17/state","method":"PUT","body":{"on":false}}\
]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

curl -s -H "Accept: application/json" -X POST --data '{\
"name":"TapKeuken.2",\
"conditions":[\
{"address":"/sensors/3/state/lastupdated","operator":"dx"},\
{"address":"/sensors/3/state/buttonevent","operator":"eq","value":"16"}\
],\
"actions":[\
{"address":"/groups/3/action","method":"PUT","body":{"scene":"EVf24QboVUqvcbW"}},\
{"address":"/lights/17/state","method":"PUT","body":{"on":true}}\
]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

curl -s -H "Accept: application/json" -X POST --data '{\
"name":"TapKeuken.3",\
"conditions":[\
{"address":"/sensors/3/state/lastupdated","operator":"dx"},\
{"address":"/sensors/3/state/buttonevent","operator":"eq","value":"17"}\
],\
"actions":[\
{"address":"/groups/3/action","method":"PUT","body":{"scene":"EVf24QboVUqvcbW"}},\
{"address":"/lights/17/state","method":"PUT","body":{"on":false}}\
]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

curl -s -H "Accept: application/json" -X POST --data '{\
"name":"TapKeuken.4",\
"conditions":[\
{"address":"/sensors/3/state/lastupdated","operator":"dx"},\
{"address":"/sensors/3/state/buttonevent","operator":"eq","value":"18"}\
],\
"actions":[\
{"address":"/groups/3/action","method":"PUT","body":{"scene":"Ya1-SihTfsUFXeH"}},\
{"address":"/lights/17/state","method":"PUT","body":{"on":false}}\
]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo


#Hallway lights based on Front Door TAP
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapVoordeur.1","conditions":[{"address":"/sensors/4/state/lastupdated","operator":"dx"},{"address":"/sensors/4/state/buttonevent","operator":"eq","value":"34"}],"actions":[{"address":"/groups/0/action","method":"PUT","body":{"on":false}},{"address":"/sensors/43/state","method":"PUT","body":{"presence":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapVoordeur.2","conditions":[{"address":"/sensors/4/state/lastupdated","operator":"dx"},{"address":"/sensors/4/state/buttonevent","operator":"eq","value":"16"}],"actions":[{"address":"/groups/4/action","method":"PUT","body":{"scene":"7FQopiTlilmk49E"}},{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapVoordeur.3","conditions":[{"address":"/sensors/4/state/lastupdated","operator":"dx"},{"address":"/sensors/4/state/buttonevent","operator":"eq","value":"17"}],"actions":[{"address":"/groups/4/action","method":"PUT","body":{"scene":"7FQopiTlilmk49E"}},{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapVoordeur.4","conditions":[{"address":"/sensors/4/state/lastupdated","operator":"dx"},{"address":"/sensors/4/state/buttonevent","operator":"eq","value":"18"}],"actions":[{"address":"/groups/4/action","method":"PUT","body":{"scene":"7FQopiTlilmk49E"}},{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Bedroom lights based on Bedroom Door TAP
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapSlaapkamerDeur.1","conditions":[{"address":"/sensors/5/state/lastupdated","operator":"dx"},{"address":"/sensors/5/state/buttonevent","operator":"eq","value":"34"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"on":false,"transitiontime":30}},{"address":"/lights/26/state","method":"PUT","body":{"on":false}},{"address":"/sensors/28/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapSlaapkamerDeur.2","conditions":[{"address":"/sensors/5/state/lastupdated","operator":"dx"},{"address":"/sensors/5/state/buttonevent","operator":"eq","value":"16"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"73xHhbNX9vlFAaa"}},{"address":"/lights/26/state","method":"PUT","body":{"on":true}},{"address":"/sensors/28/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapSlaapkamerDeur.3","conditions":[{"address":"/sensors/5/state/lastupdated","operator":"dx"},{"address":"/sensors/5/state/buttonevent","operator":"eq","value":"17"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"2xv3l07HSDikudx"}},{"address":"/lights/26/state","method":"PUT","body":{"on":true}},{"address":"/sensors/28/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapSlaapkamerDeur.4","conditions":[{"address":"/sensors/5/state/lastupdated","operator":"dx"},{"address":"/sensors/5/state/buttonevent","operator":"eq","value":"18"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"cnhvtkwlJz3hx6Z"}},{"address":"/lights/26/state","method":"PUT","body":{"on":true}},{"address":"/sensors/28/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Bedroom lights based on Bedroom Bed TAP
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapSlaapkamerBed.1.1","conditions":[{"address":"/sensors/6/state/lastupdated","operator":"dx"},{"address":"/sensors/6/state/buttonevent","operator":"eq","value":"34"},{"address":"/groups/5/state/any_on","operator":"eq","value":"true"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"on":false,"transitiontime":50}},{"address":"/lights/26/state","method":"PUT","body":{"on":true}},{"address":"/sensors/28/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapSlaapkamerBed.1.2","conditions":[{"address":"/sensors/6/state/lastupdated","operator":"dx"},{"address":"/sensors/6/state/buttonevent","operator":"eq","value":"34"},{"address":"/groups/5/state/any_on","operator":"eq","value":"false"}],"actions":[{"address":"/groups/1/action","method":"PUT","body":{"on":false,"transitiontime":50}},{"address":"/groups/2/action","method":"PUT","body":{"on":false,"transitiontime":50}},{"address":"/groups/3/action","method":"PUT","body":{"on":false,"transitiontime":50}},{"address":"/groups/4/action","method":"PUT","body":{"on":false,"transitiontime":50}},{"address":"/groups/5/action","method":"PUT","body":{"on":false,"transitiontime":50}},{"address":"/sensors/12/config","method":"PUT","body":{"on":true}},{"address":"/sensors/28/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapSlaapkamerBed.2","conditions":[{"address":"/sensors/6/state/lastupdated","operator":"dx"},{"address":"/sensors/6/state/buttonevent","operator":"eq","value":"16"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"2xv3l07HSDikudx"}},{"address":"/lights/26/state","method":"PUT","body":{"on":true}},{"address":"/sensors/28/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapSlaapkamerBed.3","conditions":[{"address":"/sensors/6/state/lastupdated","operator":"dx"},{"address":"/sensors/6/state/buttonevent","operator":"eq","value":"17"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"cnhvtkwlJz3hx6Z"}},{"address":"/lights/26/state","method":"PUT","body":{"on":true}},{"address":"/sensors/28/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapSlaapkamerBed.4","conditions":[{"address":"/sensors/6/state/lastupdated","operator":"dx"},{"address":"/sensors/6/state/buttonevent","operator":"eq","value":"18"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"HNl1MWdt6UjOeRT"}},{"address":"/lights/26/state","method":"PUT","body":{"on":true}},{"address":"/sensors/28/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Office lights based on Office TAP
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapKantoor.1","conditions":[{"address":"/sensors/7/state/lastupdated","operator":"dx"},{"address":"/sensors/7/state/buttonevent","operator":"eq","value":"34"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"on":false,"transitiontime":30}},{"address":"/sensors/32/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapKantoor.2","conditions":[{"address":"/sensors/7/state/lastupdated","operator":"dx"},{"address":"/sensors/7/state/buttonevent","operator":"eq","value":"16"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"scene":"iiVzpp-yUvKHArQ"}},{"address":"/sensors/32/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapKantoor.3","conditions":[{"address":"/sensors/7/state/lastupdated","operator":"dx"},{"address":"/sensors/7/state/buttonevent","operator":"eq","value":"17"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"scene":"iiVzpp-yUvKHArQ"}},{"address":"/sensors/32/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapKantoor.4","conditions":[{"address":"/sensors/7/state/lastupdated","operator":"dx"},{"address":"/sensors/7/state/buttonevent","operator":"eq","value":"18"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"scene":"cijBAzra8zmkz9q"}},{"address":"/sensors/32/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Bathroom lights based on Bathroom TAP
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapBadkamer.1","conditions":[{"address":"/sensors/8/state/lastupdated","operator":"dx"},{"address":"/sensors/8/state/buttonevent","operator":"eq","value":"34"}],"actions":[{"address":"/groups/8/action","method":"PUT","body":{"on":false,"transitiontime":30}},{"address":"/sensors/40/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapBadkamer.2","conditions":[{"address":"/sensors/8/state/lastupdated","operator":"dx"},{"address":"/sensors/8/state/buttonevent","operator":"eq","value":"16"}],"actions":[{"address":"/groups/8/action","method":"PUT","body":{"scene":"WaVINOgexfreb3i"}},{"address":"/sensors/40/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapBadkamer.3","conditions":[{"address":"/sensors/8/state/lastupdated","operator":"dx"},{"address":"/sensors/8/state/buttonevent","operator":"eq","value":"17"}],"actions":[{"address":"/groups/8/action","method":"PUT","body":{"scene":"WaVINOgexfreb3i"}},{"address":"/sensors/40/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TapBadkamer.4","conditions":[{"address":"/sensors/8/state/lastupdated","operator":"dx"},{"address":"/sensors/8/state/buttonevent","operator":"eq","value":"18"}],"actions":[{"address":"/groups/8/action","method":"PUT","body":{"scene":"GsZkt5FTywul8aA"}},{"address":"/sensors/40/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Dimmer Switches
#curl -s -H "Accept: application/json" -X POST --data '{"name":"Dimmer.1 Lights","conditions":[{"address":"/sensors/9/state/buttonevent","operator":"eq","value":"1000"},{"address":"/sensors/9/state/lastupdated","operator":"dx"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"scene":"GFhk2PPK-24Ztpc"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
#curl -s -H "Accept: application/json" -X POST --data '{"name":"Dimmer.3 Lights","conditions":[{"address":"/sensors/9/state/lastupdated","operator":"dx"},{"address":"/sensors/9/state/buttonevent","operator":"eq","value":"3000"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"transitiontime":9,"bri_inc":-30}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
#curl -s -H "Accept: application/json" -X POST --data '{"name":"Dimmer.3 Lights","conditions":[{"address":"/sensors/9/state/lastupdated","operator":"dx"},{"address":"/sensors/9/state/buttonevent","operator":"eq","value":"3001"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"transitiontime":9,"bri_inc":-56}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
#curl -s -H "Accept: application/json" -X POST --data '{"name":"Dimmer.3 Lights","conditions":[{"address":"/sensors/9/state/lastupdated","operator":"dx"},{"address":"/sensors/9/state/buttonevent","operator":"eq","value":"3003"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"bri_inc":0}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
#curl -s -H "Accept: application/json" -X POST --data '{"name":"Dimmer.2 Lights","conditions":[{"address":"/sensors/9/state/lastupdated","operator":"dx"},{"address":"/sensors/9/state/buttonevent","operator":"eq","value":"2000"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"transitiontime":9,"bri_inc":30}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
#curl -s -H "Accept: application/json" -X POST --data '{"name":"Dimmer.2 Lights","conditions":[{"address":"/sensors/9/state/lastupdated","operator":"dx"},{"address":"/sensors/9/state/buttonevent","operator":"eq","value":"2001"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"transitiontime":9,"bri_inc":56}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
#curl -s -H "Accept: application/json" -X POST --data '{"name":"Dimmer.2 Lights","conditions":[{"address":"/sensors/9/state/lastupdated","operator":"dx"},{"address":"/sensors/9/state/buttonevent","operator":"eq","value":"2003"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"bri_inc":0}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
#curl -s -H "Accept: application/json" -X POST --data '{"name":"Dimmer.4 Lights","conditions":[{"address":"/sensors/9/state/lastupdated","operator":"dx"},{"address":"/sensors/9/state/buttonevent","operator":"eq","value":"4000"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
#curl -s -H "Accept: application/json" -X POST --data '{"name":"Dimmer Switch 9 reset timer","conditions":[{"address":"/sensors/9/state/lastupdated","operator":"dx"}],"actions":[{"address":"/schedules/1","method":"PUT","body":{"status":"enabled"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Combined rules for motion in the living room, dining room, kitchen and hallway
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionWoonkamer.always-on","conditions":[{"address":"/sensors/12/config/on","operator":"eq","value":"true"},{"address":"/sensors/12/state/presence","operator":"eq","value":"true"},{"address":"/sensors/12/state/presence","operator":"dx"}],"actions":[{"address":"/groups/1/action","method":"PUT","body":{"scene":"2X7964HVeAruuQY"}},{"address":"/sensors/44/state","method":"PUT","body":{"presence":true}},{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionEetkamer.always-on","conditions":[{"address":"/sensors/12/config/on","operator":"eq","value":"true"},{"address":"/sensors/16/state/presence","operator":"eq","value":"true"},{"address":"/sensors/16/state/presence","operator":"dx"}],"actions":[{"address":"/groups/1/action","method":"PUT","body":{"scene": "2X7964HVeAruuQY"}},{"address":"/sensors/44/state","method":"PUT","body":{"presence":true}},{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKeuken.always-on","conditions":[{"address":"/sensors/12/config/on","operator":"eq","value":"true"},{"address":"/sensors/20/state/presence","operator":"eq","value":"true"},{"address":"/sensors/20/state/presence","operator":"dx"}],"actions":[{"address":"/groups/1/action","method":"PUT","body":{"scene":"2X7964HVeAruuQY"}},{"address":"/sensors/44/state","method":"PUT","body":{"presence":true}},{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHal.always-on","conditions":[{"address":"/sensors/12/config/on","operator":"eq","value":"true"},{"address":"/sensors/24/state/presence","operator":"eq","value":"true"},{"address":"/sensors/24/state/presence","operator":"dx"},{"address":"/config/localtime","operator":"in","value":"T06:00:00/T21:00:00"},{"address":"/groups/1/state/any_on","operator":"eq","value":"false"}],"actions":[{"address":"/groups/1/action","method":"PUT","body":{"scene": "2X7964HVeAruuQY"}},{"address":"/sensors/44/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionSlaapkamer.always-on","conditions":[{"address":"/sensors/28/config/on","operator":"eq","value":"true"},{"address":"/sensors/28/state/presence","operator":"eq","value":"true"},{"address":"/sensors/16/state/presence","operator":"dx"}],"actions":[{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKantoor.always-on","conditions":[{"address":"/sensors/32/config/on","operator":"eq","value":"true"},{"address":"/sensors/32/state/presence","operator":"eq","value":"true"},{"address":"/sensors/32/state/presence","operator":"dx"}],"actions":[{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionToilet.always-on","conditions":[{"address":"/sensors/36/config/on","operator":"eq","value":"true"},{"address":"/sensors/36/state/presence","operator":"eq","value":"true"},{"address":"/sensors/36/state/presence","operator":"dx"}],"actions":[{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionBadkamer.always-on","conditions":[{"address":"/sensors/40/config/on","operator":"eq","value":"true"},{"address":"/sensors/40/state/presence","operator":"eq","value":"true"},{"address":"/sensors/40/state/presence","operator":"dx"}],"actions":[{"address":"/sensors/43/state","method":"PUT","body":{"presence":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionWoonkamer.always-off","conditions":[{"address":"/sensors/12/config/on","operator":"eq","value":"true"},{"address":"/sensors/12/state/presence","operator":"eq","value":"false"},{"address":"/sensors/12/state/presence","operator":"dx"}],"actions":[{"address":"/sensors/44/state","method":"PUT","body":{"presence":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionEetkamer.always-off","conditions":[{"address":"/sensors/12/config/on","operator":"eq","value":"true"},{"address":"/sensors/16/state/presence","operator":"eq","value":"false"},{"address":"/sensors/16/state/presence","operator":"dx"}],"actions":[{"address":"/sensors/44/state","method":"PUT","body":{"presence":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKeuken.always-off","conditions":[{"address":"/sensors/12/config/on","operator":"eq","value":"true"},{"address":"/sensors/20/state/presence","operator":"eq","value":"false"},{"address":"/sensors/20/state/presence","operator":"dx"}],"actions":[{"address":"/sensors/44/state","method":"PUT","body":{"presence":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHal.always-off","conditions":[{"address":"/sensors/12/config/on","operator":"eq","value":"true"},{"address":"/sensors/24/state/presence","operator":"eq","value":"false"},{"address":"/sensors/24/state/presence","operator":"dx"}],"actions":[{"address":"/sensors/44/state","method":"PUT","body":{"presence": false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Living room lights based on combined rules
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionCombined.day-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"},{"address":"/sensors/44/state/presence","operator":"eq","value":"true"},{"address":"/sensors/44/state/presence","operator":"dx"},{"address":"/sensors/13/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"scene":"GFhk2PPK-24Ztpc","transitiontime":300}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionCombined.day-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"},{"address":"/sensors/44/state/presence","operator":"eq","value":"true"},{"address":"/sensors/13/state/dark","operator":"eq","value":"true"},{"address":"/sensors/13/state/dark","operator":"dx"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"scene": "GFhk2PPK-24Ztpc"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionCombined.night-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T00:00:00/T06:00:00"},{"address":"/sensors/44/state/presence","operator":"eq","value":"true"},{"address":"/sensors/44/state/presence","operator":"dx"},{"address":"/sensors/13/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"scene":"6hLiqYWJ3Xnor8s","transitiontime":300}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionCombined.night-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T00:00:00/T06:00:00"},{"address":"/sensors/44/state/presence","operator":"eq","value":"true"},{"address":"/sensors/13/state/dark","operator":"eq","value":"true"},{"address":"/sensors/13/state/dark","operator":"dx"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"scene":"6hLiqYWJ3Xnor8s"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionCombined.off","conditions":[{"address":"/sensors/44/state/presence","operator":"eq","value":"false"},{"address":"/sensors/44/state/presence","operator":"ddx","value":"PT00:15:00"},{"address":"/groups/1/state/any_on","operator":"eq","value":"true"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"on":false,"transitiontime":100}},{"address":"/groups/1/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionCombined.dark-off","conditions":[{"address":"/sensors/13/state/lightlevel","operator":"gt","value":"22500"},{"address":"/sensors/13/state/lightlevel","operator":"dx"}],"actions":[{"address":"/groups/2/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Kitchen lights based on Kitchen motion
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKeuken.day-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"},{"address":"/sensors/20/state/presence","operator":"eq","value":"true"},{"address":"/sensors/20/state/presence","operator":"dx"},{"address":"/sensors/21/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/3/action","method":"PUT","body":{"scene":"EVf24QboVUqvcbW"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKeuken.day-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"},{"address":"/sensors/20/state/presence","operator":"eq","value":"true"},{"address":"/sensors/21/state/dark","operator":"eq","value":"true"},{"address":"/sensors/21/state/dark","operator":"dx"}],"actions":[{"address":"/groups/3/action","method":"PUT","body":{"scene":"EVf24QboVUqvcbW"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKeuken.night-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T00:00:00/T06:00:00"},{"address":"/sensors/20/state/presence","operator":"eq","value":"true"},{"address":"/sensors/20/state/presence","operator":"dx"},{"address":"/sensors/21/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/3/action","method":"PUT","body":{"scene":"Ya1-SihTfsUFXeH"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKeuken.night-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T00:00:00/T06:00:00"},{"address":"/sensors/20/state/presence","operator":"eq","value":"true"},{"address":"/sensors/21/state/dark","operator":"eq","value":"true"},{"address":"/sensors/21/state/dark","operator":"dx"}],"actions":[{"address":"/groups/3/action","method":"PUT","body":{"scene":"Ya1-SihTfsUFXeH"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKeuken.off","conditions":[{"address":"/sensors/20/state/presence","operator":"eq","value":"false"},{"address":"/sensors/20/state/presence","operator":"ddx","value":"PT00:10:00"},{"address":"/groups/3/state/any_on","operator":"eq","value":"true"}],"actions":[{"address":"/groups/3/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKeuken.dark-off","conditions":[{"address":"/sensors/17/state/lightlevel","operator":"gt","value":"35000"},{"address":"/sensors/17/state/lightlevel","operator":"dx"}],"actions":[{"address":"/groups/3/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKeuken.fan-off","conditions":[{"address":"/sensors/20/state/presence","operator":"eq","value":"false"},{"address":"/sensors/20/state/presence","operator":"ddx","value":"PT00:25:00"}],"actions":[{"address":"/lights/17/state","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Hallway lights based on Hallway motion
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHal.day-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"},{"address":"/sensors/24/state/presence","operator":"eq","value":"true"},{"address":"/sensors/24/state/presence","operator":"dx"},{"address":"/sensors/25/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/4/action","method":"PUT","body":{"scene":"7FQopiTlilmk49E"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHal.day-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"},{"address":"/sensors/24/state/presence","operator":"eq","value":"true"},{"address":"/sensors/25/state/dark","operator":"eq","value":"true"},{"address":"/sensors/25/state/dark","operator":"dx"}],"actions":[{"address":"/groups/4/action","method":"PUT","body":{"scene":"7FQopiTlilmk49E"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHal.night-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T00:00:00/T06:00:00"},{"address":"/sensors/24/state/presence","operator":"eq","value":"true"},{"address":"/sensors/24/state/presence","operator":"dx"},{"address":"/sensors/25/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/4/action","method":"PUT","body":{"scene":"v86iiKffcv0BtMm"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHal.night-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T00:00:00/T06:00:00"},{"address":"/sensors/24/state/presence","operator":"eq","value":"true"},{"address":"/sensors/25/state/dark","operator":"eq","value":"true"},{"address":"/sensors/25/state/dark","operator":"dx"}],"actions":[{"address":"/groups/4/action","method":"PUT","body":{"scene":"v86iiKffcv0BtMm"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHal.off","conditions":[{"address":"/sensors/24/state/presence","operator":"eq","value":"false"},{"address":"/sensors/24/state/presence","operator":"ddx","value":"PT00:05:00"},{"address":"/groups/4/state/any_on","operator":"eq","value":"true"}],"actions":[{"address":"/groups/4/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Bedroom lights based on Bedroom motion
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionSlaapkamer.day-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T07:00:00/T20:00:00"},{"address":"/sensors/28/state/presence","operator":"eq","value":"true"},{"address":"/sensors/28/state/presence","operator":"dx"},{"address":"/sensors/29/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"73xHhbNX9vlFAaa"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionSlaapkamer.day-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T07:00:00/T20:00:00"},{"address":"/sensors/28/state/presence","operator":"eq","value":"true"},{"address":"/sensors/29/state/dark","operator":"eq","value":"true"},{"address":"/sensors/29/state/dark","operator":"dx"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"73xHhbNX9vlFAaa"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionSlaapkamer.evening-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T20:00:00/T22:00:00"},{"address":"/sensors/28/state/presence","operator":"eq","value":"true"},{"address":"/sensors/28/state/presence","operator":"dx"},{"address":"/sensors/29/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"2xv3l07HSDikudx"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionSlaapkamer.evening-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T20:00:00/T22:00:00"},{"address":"/sensors/28/state/presence","operator":"eq","value":"true"},{"address":"/sensors/29/state/dark","operator":"eq","value":"true"},{"address":"/sensors/29/state/dark","operator":"dx"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"2xv3l07HSDikudx"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionSlaapkamer.night-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T22:00:00/T07:00:00"},{"address":"/sensors/28/state/presence","operator":"eq","value":"true"},{"address":"/sensors/28/state/presence","operator":"dx"},{"address":"/sensors/29/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"HNl1MWdt6UjOeRT"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionSlaapkamer.night-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T22:00:00/T07:00:00"},{"address":"/sensors/28/state/presence","operator":"eq","value":"true"},{"address":"/sensors/29/state/dark","operator":"eq","value":"true"},{"address":"/sensors/29/state/dark","operator":"dx"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"scene":"HNl1MWdt6UjOeRT"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionSlaapkamer.off","conditions":[{"address":"/sensors/28/state/presence","operator":"eq","value":"false"},{"address":"/sensors/28/state/presence","operator":"ddx","value":"PT00:05:00"},{"address":"/groups/5/state/any_on","operator":"eq","value":"true"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionSlaapkamer.dark-off","conditions":[{"address":"/sensors/29/state/lightlevel","operator":"gt","value":"25000"},{"address":"/sensors/29/state/lightlevel","operator":"dx"}],"actions":[{"address":"/groups/5/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHumidifier.on","conditions":[{"address":"/sensors/28/state/presence","operator":"eq","value":"true"},{"address":"/sensors/28/state/presence","operator":"dx"}],"actions":[{"address":"/lights/26/state","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHumidifier.night-off","conditions":[{"address":"/config/localtime","operator":"in","value":"T20:00:00/T06:00:00"},{"address":"/sensors/28/state/presence","operator":"eq","value":"false"},{"address":"/sensors/28/state/presence","operator":"ddx","value":"PT08:00:00"},{"address":"/lights/26/state/on","operator":"eq","value":"true"}],"actions":[{"address":"/lights/26/state","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionHumidifier.day-off","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T20:00:00"},{"address":"/sensors/28/state/presence","operator":"eq","value":"false"},{"address":"/sensors/28/state/presence","operator":"ddx","value":"PT00:01:00"},{"address":"/lights/26/state/on","operator":"eq","value":"true"}],"actions":[{"address":"/lights/26/state","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Office lights based on Office motion
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKantoor.day-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T08:00:00/T23:00:00"},{"address":"/sensors/32/state/presence","operator":"eq","value":"true"},{"address":"/sensors/32/state/presence","operator":"dx"},{"address":"/sensors/33/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"scene":"iiVzpp-yUvKHArQ"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKantoor.day-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T08:00:00/T23:00:00"},{"address":"/sensors/32/state/presence","operator":"eq","value":"true"},{"address":"/sensors/33/state/dark","operator":"eq","value":"true"},{"address":"/sensors/33/state/dark","operator":"dx"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"scene":"iiVzpp-yUvKHArQ"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKantoor.night-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T23:00:00/T08:00:00"},{"address":"/sensors/32/state/presence","operator":"eq","value":"true"},{"address":"/sensors/32/state/presence","operator":"dx"},{"address":"/sensors/33/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"scene":"cijBAzra8zmkz9q"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKantoor.night-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T23:00:00/T08:00:00"},{"address":"/sensors/32/state/presence","operator":"eq","value":"true"},{"address":"/sensors/33/state/dark","operator":"eq","value":"true"},{"address":"/sensors/33/state/dark","operator":"dx"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"scene":"cijBAzra8zmkz9q"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKantoor.off","conditions":[{"address":"/sensors/32/state/presence","operator":"eq","value":"false"},{"address":"/sensors/32/state/presence","operator":"ddx","value":"PT00:10:00"},{"address":"/groups/6/state/any_on","operator":"eq","value":"true"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionKantoor.dark-off","conditions":[{"address":"/sensors/33/state/lightlevel","operator":"gt","value":"35000"},{"address":"/sensors/33/state/lightlevel","operator":"dx"}],"actions":[{"address":"/groups/6/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Toilet lights based on Toilets motion
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionToilet.day-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"},{"address":"/sensors/36/state/presence","operator":"eq","value":"true"},{"address":"/sensors/36/state/presence","operator":"dx"},{"address":"/sensors/37/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/7/action","method":"PUT","body":{"scene":"Hjdaqbqu41eqXoh"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionToilet.day-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T06:00:00/T00:00:00"},{"address":"/sensors/36/state/presence","operator":"eq","value":"true"},{"address":"/sensors/37/state/dark","operator":"eq","value":"true"},{"address":"/sensors/37/state/dark","operator":"dx"}],"actions":[{"address":"/groups/7/action","method":"PUT","body":{"scene":"Hjdaqbqu41eqXoh"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionToilet.night-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T00:00:00/T06:00:00"},{"address":"/sensors/36/state/presence","operator":"eq","value":"true"},{"address":"/sensors/36/state/presence","operator":"dx"},{"address":"/sensors/37/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/7/action","method":"PUT","body":{"scene":"JhuEeooC16tNGt3"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionToilet.night-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T00:00:00/T06:00:00"},{"address":"/sensors/36/state/presence","operator":"eq","value":"true"},{"address":"/sensors/37/state/dark","operator":"eq","value":"true"},{"address":"/sensors/37/state/dark","operator":"dx"}],"actions":[{"address":"/groups/7/action","method":"PUT","body":{"scene":"JhuEeooC16tNGt3"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionToilet.off","conditions":[{"address":"/sensors/36/state/presence","operator":"eq","value":"false"},{"address":"/sensors/36/state/presence","operator":"ddx","value":"PT00:05:00"},{"address":"/groups/7/state/any_on","operator":"eq","value":"true"}],"actions":[{"address":"/groups/7/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Bathroom lights based on Bathroom motion
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionBadkamer.day-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T05:00:00/T17:00:00"},{"address":"/sensors/40/state/presence","operator":"eq","value":"true"},{"address":"/sensors/40/state/presence","operator":"dx"},{"address":"/sensors/41/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/8/action","method":"PUT","body":{"scene":"WaVINOgexfreb3i"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionBadkamer.day-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T05:00:00/T17:00:00"},{"address":"/sensors/40/state/presence","operator":"eq","value":"true"},{"address":"/sensors/41/state/dark","operator":"eq","value":"true"},{"address":"/sensors/41/state/dark","operator":"dx"}],"actions":[{"address":"/groups/8/action","method":"PUT","body":{"scene":"WaVINOgexfreb3i"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionBadkamer.night-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T17:00:00/T05:00:00"},{"address":"/sensors/40/state/presence","operator":"eq","value":"true"},{"address":"/sensors/40/state/presence","operator":"dx"},{"address":"/sensors/41/state/dark","operator":"eq","value":"true"}],"actions":[{"address":"/groups/8/action","method":"PUT","body":{"scene":"GsZkt5FTywul8aA"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionBadkamer.night-dark-on","conditions":[{"address":"/config/localtime","operator":"in","value":"T17:00:00/T05:00:00"},{"address":"/sensors/40/state/presence","operator":"eq","value":"true"},{"address":"/sensors/41/state/dark","operator":"eq","value":"true"},{"address":"/sensors/41/state/dark","operator":"dx"}],"actions":[{"address":"/groups/8/action","method":"PUT","body":{"scene":"GsZkt5FTywul8aA"}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"MotionBadkamer.off","conditions":[{"address":"/sensors/40/state/presence","operator":"eq","value":"false"},{"address":"/sensors/40/state/presence","operator":"ddx","value":"PT00:10:00"},{"address":"/groups/8/state/any_on","operator":"eq","value":"true"}],"actions":[{"address":"/groups/8/action","method":"PUT","body":{"on":false,"transitiontime":100}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Rules for switchting all motion sensors based on 1
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorWoonkamer.on","conditions":[{"address":"/sensors/12/config/on","operator":"dx"},{"address":"/sensors/12/config/on","operator":"eq","value":"true"}],"actions":[{"address":"/sensors/11/config","method":"PUT","body":{"on":true}},{"address":"/sensors/13/config","method":"PUT","body":{"on":true}},{"address":"/sensors/15/config","method":"PUT","body":{"on":true}},{"address":"/sensors/16/config","method":"PUT","body":{"on":true}},{"address":"/sensors/17/config","method":"PUT","body":{"on":true}},{"address":"/sensors/19/config","method":"PUT","body":{"on":true}},{"address":"/sensors/20/config","method":"PUT","body":{"on":true}},{"address":"/sensors/21/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorWoonkamer.off","conditions":[{"address":"/sensors/12/config/on","operator":"dx"},{"address":"/sensors/12/config/on","operator":"eq","value":"false"}],"actions":[{"address":"/sensors/11/config","method":"PUT","body":{"on":false}},{"address":"/sensors/13/config","method":"PUT","body":{"on":false}},{"address":"/sensors/15/config","method":"PUT","body":{"on":false}},{"address":"/sensors/16/config","method":"PUT","body":{"on":false}},{"address":"/sensors/17/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorKeuken.on","conditions":[{"address":"/sensors/20/config/on","operator":"dx"},{"address":"/sensors/20/config/on","operator":"eq","value":"true"}],"actions":[{"address":"/sensors/19/config","method":"PUT","body":{"on":true}},{"address":"/sensors/21/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorKeuken.off","conditions":[{"address":"/sensors/20/config/on","operator":"dx"},{"address":"/sensors/20/config/on","operator":"eq","value":"false"}],"actions":[{"address":"/sensors/19/config","method":"PUT","body":{"on":false}},{"address":"/sensors/21/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorSlaapkamer.on","conditions":[{"address":"/sensors/28/config/on","operator":"dx"},{"address":"/sensors/28/config/on","operator":"eq","value":"true"}],"actions":[{"address":"/sensors/27/config","method":"PUT","body":{"on":true}},{"address":"/sensors/29/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorSlaapkamer.off","conditions":[{"address":"/sensors/28/config/on","operator":"dx"},{"address":"/sensors/28/config/on","operator":"eq","value":"false"}],"actions":[{"address":"/sensors/27/config","method":"PUT","body":{"on":false}},{"address":"/sensors/29/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorKantoor.on","conditions":[{"address":"/sensors/32/config/on","operator":"dx"},{"address":"/sensors/32/config/on","operator":"eq","value":"true"}],"actions":[{"address":"/sensors/31/config","method":"PUT","body":{"on":true}},{"address":"/sensors/33/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorKantoor.off","conditions":[{"address":"/sensors/32/config/on","operator":"dx"},{"address":"/sensors/32/config/on","operator":"eq","value":"false"}],"actions":[{"address":"/sensors/31/config","method":"PUT","body":{"on":false}},{"address":"/sensors/33/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorBadkamer.on","conditions":[{"address":"/sensors/40/config/on","operator":"dx"},{"address":"/sensors/40/config/on","operator":"eq","value":"true"}],"actions":[{"address":"/sensors/39/config","method":"PUT","body":{"on":true}},{"address":"/sensors/41/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorBadkamer.off","conditions":[{"address":"/sensors/40/config/on","operator":"dx"},{"address":"/sensors/40/config/on","operator":"eq","value":"false"}],"actions":[{"address":"/sensors/39/config","method":"PUT","body":{"on":false}},{"address":"/sensors/41/config","method":"PUT","body":{"on":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

#Presence triggers
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorPresence.on","conditions":[{"address":"/sensors/43/state/presence","operator":"dx"},{"address":"/sensors/43/state/presence","operator":"eq","value":"true"}],"actions":[{"address":"/lights/18/state","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"SensorPresence.off","conditions":[{"address":"/sensors/43/state/presence","operator":"dx"},{"address":"/sensors/43/state/presence","operator":"eq","value":"false"}],"actions":[{"address":"/sensors/12/config","method":"PUT","body":{"on":true}},{"address":"/sensors/16/config","method":"PUT","body":{"on":true}},{"address":"/sensors/20/config","method":"PUT","body":{"on":true}},{"address":"/sensors/32/config","method":"PUT","body":{"on":true}},{"address":"/sensors/36/config","method":"PUT","body":{"on":true}},{"address":"/sensors/40/config","method":"PUT","body":{"on":true}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo
curl -s -H "Accept: application/json" -X POST --data '{"name":"TriggerPresence.off","conditions":[{"address":"/lights/18/state/on","operator":"dx"},{"address":"/lights/18/state/on","operator":"eq","value":"false"}],"actions":[{"address":"/sensors/43/state","method":"PUT","body":{"presence":false}}]}' http://${HUE_IP}/api/${HUE_USER}/rules/; echo

echo "$(date): Script created new short-rules" >> HueBridgeLog

echo "$(date): Script finished succesfully" >> HueBridgeLog