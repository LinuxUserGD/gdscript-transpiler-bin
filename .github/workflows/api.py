import requests
import json
import os
import glob

def upload(filename):
    content = open(filename, "r").read()
    headers = {'Authorization': f'token {token}'}
    requests.patch('https://api.github.com/gists/' + gist_id, data=json.dumps({'files': {filename: {"content": content}}}), headers=headers)

token = os.environ["github_token"]
gist_id = "73d8e030a44eb7f91bdeaea96a321f6d"
path_py = "*.py"

for filename in glob.glob(path_py):
    if filename != "api.py":
        upload(filename)
upload("README.md")