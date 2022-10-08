import requests
import json
import os

token = os.environ["github_token"]
gist_id = "73d8e030a44eb7f91bdeaea96a321f6d"

filename = "main.py"
content=open(filename, 'r').read()
headers = {'Authorization': f'token {token}'}
r = requests.patch('https://api.github.com/gists/' + gist_id, data=json.dumps({'files':{filename:{"content":content}}}),headers=headers)
print(r.json())

filename = "transpiler.py"
content=open(filename, 'r').read()
headers = {'Authorization': f'token {token}'}
r = requests.patch('https://api.github.com/gists/' + gist_id, data=json.dumps({'files':{filename:{"content":content}}}),headers=headers)
print(r.json())

filename = "props.py"
content=open(filename, 'r').read()
headers = {'Authorization': f'token {token}'}
r = requests.patch('https://api.github.com/gists/' + gist_id, data=json.dumps({'files':{filename:{"content":content}}}),headers=headers)
print(r.json())