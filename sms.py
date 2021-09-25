import os
import sys
import time
import netifaces as ni
import requests

SERVICE_PLAN_ID = os.environ['SERVICE_PLAN_ID']
API_TOKEN = os.environ['API_TOKEN']
SENDER_SMS_NUMBER = os.environ['SENDER_SMS_NUMBER']
INTERFACE_NAME = os.environ['INTERFACE_NAME']
TARGET_SMS_NUMBER = os.environ['TARGET_SMS_NUMBER']

MESSAGE_PREFIX = 'Your Hofbox has powered up! Use your favorite web browser to connect to: http://'
ipv4 = ni.ifaddresses(INTERFACE_NAME)[ni.AF_INET][0]['addr']
message = '%s%s' % (MESSAGE_PREFIX, ipv4)

url = 'https://us.sms.api.sinch.com/xms/v1/' + SERVICE_PLAN_ID + '/batches'
headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer ' + API_TOKEN
}
j = {
  "from": SENDER_SMS_NUMBER,
  "to": [ TARGET_SMS_NUMBER ],
  "body": message
}

def debug(s):
  print(s)
  sys.stdout.flush()
  pass
  
response = requests.post(url, json=j, headers=headers)
data = response.json()
debug(data)

while True:
  debug('.')
  time.sleep(5)
