import requests
import json
import os

token = os.environ["github_token"]
filename = "main.py"
gist_id = "73d8e030a44eb7f91bdeaea96a321f6d"

content=open(filename, 'r').read()
headers = {'Authorization': f'token {token}'}
r = requests.patch('https://api.github.com/gists/' + gist_id, data=json.dumps({'files':{filename:{"content":content}}}),headers=headers) 