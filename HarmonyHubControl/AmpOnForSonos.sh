#!/bin/bash
SONOS_IP=10.0.1.121
HARMONY_EMAIL=erikvennink@gmail.com
HARMONY_PASSWORD=ecokey4281
HARMONY_IP=10.0.1.131
DELAY_BETWEEN_PLAYING_CHECKS=2
DELAY_BETWEEN_STOPPED_CHECKS=30
AMP_POWER_STATE=0 # Assumes Amp is on when script starts. Will correct itself
SONOS_DEVICE_ID=19617412
AMPLIFIER_DEVICE_ID=14771446
SONOS_ACTIVITY_ID=9276052
HARMONYHUB="./HarmonyHubControl ${HARMONY_EMAIL} ${HARMONY_PASSWORD} ${HARMONY_IP}" # All HarmonyHubControl commands start with this
 
while true; do # Perpetual loop
 
if [[ ${AMP_POWER_STATE} = 0 ]]; then # Amp off. Check if play started...
 
  sleep ${DELAY_BETWEEN_PLAYING_CHECKS} # Creates delay between checks
 
  if [[ $(curl -s http://${SONOS_IP}:1400/status/perf | grep currently) = *PLAYING* ]]; then # Sonos is playing
    # Power on amp
    ${HARMONYHUB} issue_device_command ${AMPLIFIER_DEVICE_ID} PowerOn; AMP_POWER_STATE=1
    # If no Harmony Activity, start Sonos activity
    if [[ $(${HARMONYHUB} get_current_activity_id | grep Current) = *-1* ]]; then
      ${HARMONYHUB} start_activity ${SONOS_ACTIVITY_ID}
    fi
  fi
 
elif [[ ${AMP_POWER_STATE} = 1 ]]; then # Amp on. Check if play stopped...
 
  sleep ${DELAY_BETWEEN_STOPPED_CHECKS} # Creates delay between checks
 
  if ! [[ $(curl -s http://${SONOS_IP}:1400/status/perf | grep currently) = *PLAYING* ]]; then # Sonos is paused/stopped
    # Power down amp
    ${HARMONYHUB} issue_device_command ${AMPLIFIER_DEVICE_ID} PowerOff; AMP_POWER_STATE=0
    # End Harmony Sonos Activity (if was running)
    if [[ $(${HARMONYHUB} get_current_activity_id | grep Current) = *${SONOS_ACTIVITY_ID}* ]]; then
      ${HARMONYHUB} start_activity -1 # Sonos activity still on - turn off
    fi
  fi
 
fi
 
done # End of perpetual loop
