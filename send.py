import requests
from datetime import datetime
import sys

post_template = """
FreakyOS <b>{}'s</b> Final Android 10 Release

✅ Build Name: {}

✅ Build date : {}

✅ Device: {}

✅ Maintainer: {}

✅ Changelog: <a href="https://t.me/freakyos/19129"> Here </a>

✅ Downloads: <a href="{}"> Here </a>

ℹ️ Info: <a href = "https://freakyos.me/"> FreakyOS Homepage </a>  || <a href="https://t.me/freakyos"> TownHall </a> || <a href={}> XDA </a> 

ℹ️ Note: 
- Ignore Gapps Warning while flashing Gapps.
- Open gapps recommended

Made with ❤️ In 🇮🇳 
"""

def getDeviceDetails(codename):
    response = requests.get('https://raw.githubusercontent.com/FreakyOS/ota_config/still_alive/devices.json')
    data = response.json()['response']
    details = []
    for device in data:
        if device['codename'] == codename:
            return device
    return None


def preparePost(codename):
    response = requests.get(f'https://raw.githubusercontent.com/FreakyOS/ota_config/still_alive/{codename}/{codename}.json')
    data = response.json()['response'][0]
    date = str(datetime.fromtimestamp(data['datetime'])).split(' ')[0]
    device_details = getDeviceDetails(codename)
    text = post_template.format(codename, data['filename'], date , device_details['name'], device_details['maintainer'], data['url'], "")
    return text

def sendMessage(message):
    r = requests.get(f'https://api.telegram.org/bot<token>/sendMessage?chat_id=-1001427441252&text={message}&parse_mode=HTML&disable_web_page_preview=true')
    return r.content

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Please send device name as command line argument')
        exit
    else:
        print(sendMessage(preparePost(sys.argv[1])))
