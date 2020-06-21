import glob, os, hashlib, re, calendar, json, sys, shutil
from datetime import datetime

# Constants
official_json_path = 'vendor/syberia/official_devices.json'
official_repo_path = 'official_devices'
folder = 'out/target/product/'
url = r'https://sourceforge.net/projects/syberiaos/files/'

def getSize(filename):
    st = os.stat(filename)
    return st.st_size

def fileWalk(folder):
    return filenames

def getZip(folder):
    filenames = [f for f in os.listdir(folder) if f.endswith(".zip")]
    return folder + max(filenames)

def sha256sum(filename):
    h  = hashlib.sha256()
    b  = bytearray(128*1024)
    mv = memoryview(b)
    with open(filename, 'rb', buffering=0) as f:
        for n in iter(lambda : f.readinto(mv), 0):
            h.update(mv[:n])
    return h.hexdigest()

def generate_json(folder, device_json):
    ota_data = {}
    filename = getZip(folder)
    fn = os.path.split(filename)[1]
    epoch_timestamp = calendar.timegm(datetime.strptime(re.search(r"\b\d{8}.\d{4}\b", filename).group(0), "%Y%m%d-%H%M").utctimetuple())
    version = re.search(r"v\d{1}.\d{1}", filename).group(0)
    ota_data = {'response':[]}
    ota_d = {}
    ota_d['datetime'] = epoch_timestamp
    ota_d['filename'] = fn
    ota_d['id'] = str(sha256sum(filename))
    ota_d['romtype'] = "OFFICIAL"
    ota_d['size'] = str(getSize(filename))
    ota_d['url'] = url + device_json["device_codename"] + "/" +fn + "/download"
    ota_d['version'] = version
	ota_d['device_brand'] = device_json["device_brand"]
    ota_d['device_model'] = device_json["device_model"]
    ota_d['device_codename'] = device_json["device_codename"]
    ota_d['developer'] = device_json["maintainer"]
    ota_data.get ('response').append(ota_d)
    with open(official_repo_path + "/a-only/" + device+'.json', 'w') as f:
         json.dump(ota_data, f, indent=2)

# Main
if len(sys.argv) < 2:
    print("Not enough arguments!")
    sys.exit()

f = open(official_json_path)
data = json.load(f)
f.close()
type(data)
# Search for official device

for dev, value in data.items():
    if sys.argv[1] == dev.lower() or sys.argv[1] == dev:
        device = dev

device_json_data = data[device]
type(device_json_data)
generate_json(folder + device.lower() +"/", device_json_data)
shutil.copy2(folder + device.lower() + "/system/etc/Changelog.txt", official_repo_path + "/a-only/" + device+".changelog")

