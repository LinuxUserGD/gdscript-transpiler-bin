# https://stackoverflow.com/a/53153505
import os,requests
def download(url):
    get_response = requests.get(url,stream=True)
    file_name  = url.split("/")[-1]
    with open(file_name, 'wb') as f:
        for chunk in get_response.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)

download("https://gist.githubusercontent.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d/raw/archive.tar.xz")
download("https://gist.githubusercontent.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d/raw/requirements.txt")