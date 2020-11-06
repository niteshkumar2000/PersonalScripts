import requests
from datetime import datetime

post_template = """
FreakyOS <b>{}'s</b> Final Android 10 Release

✅ Build Name: {}

✅ Build date : {}

✅ Device: {}

✅ Maintainer: {}

✅ Changelog: <a href="https://t.me/freakyos/19129"> Here </a>

✅ Downloads: <a href="{}"> Here </a>

ℹ️ Info: <a href = "https://freakyos.me/"> FreakyOS Homepage </a>  || <a href="https://t.me/freakyos"> TownHall </a> || <a href="https://forum.xda-developers.com/redmi-note-6-pro/development/rom-freaky-os-t4151451"> XDA </a> 

ℹ️ Note: 
- Ignore Gapps Warning while flashing Gapps.
- Open gapps recommended

Made with ❤️ In 🇮🇳 
"""

def getDeviceDetails(codename):
    response = requests.get("https://raw.githubusercontent.com/FreakyOS/ota_config/still_alive/devices.json")
    data = response.json()['response']
    details = []
    for device in data:
        if device["codename"] == codename:
            details.append(device["name"])
            details.append(device["maintainer"])
    return details


def preparePost():
    response = requests.get("https://raw.githubusercontent.com/FreakyOS/ota_config/still_alive/tulip/tulip.json")
    data = response.json()['response'][0]
    date = str(datetime.fromtimestamp(data["datetime"])).split(' ')[0]
    codename = data["filename"].split('-')[1]
    device_details = getDeviceDetails(codename)
    devicename = device_details[0]
    maintainer = device_details[1]
    text = post_template.format(codename, data['filename'], date , devicename, maintainer, data["url"])
    return text

def sendMessage(message):
    r = requests.get("https://api.telegram.org/bot<token>/sendMessage?chat_id=-1001427441252&text={}&parse_mode=HTML&disable_web_page_preview=true".format(message))
    return r

if __name__ == "__main__":
    print(sendMessage(preparePost()))