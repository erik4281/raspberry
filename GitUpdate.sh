#!/bin/sh
VERSION="1701.4"

sleep 5
sudo git reset --hard HEAD
sudo git pull
sudo chmod -R 755 /home/pi/HarmonyHubControl/
sudo chmod -R 755 /home/pi/

echo "$(date): Git Update performed using version ${VERSION}" >> GitLog
