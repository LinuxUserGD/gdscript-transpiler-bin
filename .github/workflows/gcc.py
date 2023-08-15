import json
from sys import stdout

def pp_json(json_thing, sort=True, indents=4):
    if type(json_thing) is str:
        return(json.dumps(json.loads(json_thing), sort_keys=sort, indent=indents))
    else:
        return(json.dumps(json_thing, sort_keys=sort, indent=indents))
    return None

def download_file(url):
    r = requests.get(url, stream=True)
    chunks = 0
    raw = bytearray()
    for chunk in r.iter_content(chunk_size=1024):
        if chunk:
            raw += chunk
            chunks += 1
            stdout.write('\x1b[1A')
            stdout.write('\x1b[2K')
            print(str(chunks//1024) + "." + str(((chunks*1000)//1024)%1000) + " MiB")
    print("Extracting...")
    return raw

import requests, zipfile, io
url = 'https://api.github.com/repos/gcc-mirror/gcc/tags'
response = requests.get(url)
for zipball_url in pp_json(response.content.decode()).split("\n"):
        if "zipball_url" in zipball_url and "releases/gcc" in zipball_url:
                zipball_url = zipball_url.split("\"")[3]
                print("Downloading GCC...")
                print("")
                break
raw = download_file(zipball_url)


with zipfile.ZipFile(io.BytesIO(bytes(raw))) as zf:
        for name in zf.namelist():
            localFilePath = zf.extract(name, '.')
            print(localFilePath)
print("Extracted to " + localFilePath.split("/")[0])