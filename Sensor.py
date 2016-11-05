import urllib2
import time

def SensorState( SensorName ):

  s = "buttonevent\":"
  a = urllib2.urlopen("http://10.0.1.102/api/erikvennink/sensors/" + SensorName ).read()
  b =  a.find(s) + len(s)
  e = a.find(",",b)

  return a[b:e];

while 1 == 1:

 lastState = SensorState("2")
 while (SensorState ("2") == lastState):
   time.sleep(0.5)

 print "State Changed!" + SensorState("2")
