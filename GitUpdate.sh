#!/bin/sh
sleep 5
sudo git reset --hard HEAD
sudo git pull
sudo chmod -R 755 /home/pi/HarmonyHubControl/
sudo chmod -R 755 /home/pi/
