import requests
import json
import os

token = os.environ["github_token"]
gist_id = "73d8e030a44eb7f91bdeaea96a321f6d"

for filename in ["__main__.py", "transpiler.py", "props.py", "vector2.py", "audio.py", "version.py"]:
    content = open(filename, "r").read()
    headers = {'Authorization': f'token {token}'}
    requests.patch('https://api.github.com/gists/' + gist_id, data=json.dumps({'files': {filename: {"content": content}}}), headers=headers)
