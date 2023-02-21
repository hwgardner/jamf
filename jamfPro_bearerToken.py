#!/usr/bin/env python3

### Import library dependencies.
import requests
import json

### Set variables for URL, USERNAME, and PASSWORD
url=" "
username = " "
password = " "
### Set PAYLOAD variable.
payload={}
## Set HEADERS
headers = {
	'Accept': 'application/json'
}
### Build the call and assign the output to variable RESPONSE
response = requests.request("POST", url + "/api/v1/auth/token", auth=(username, password), headers=headers, data=payload)
### Extract value of "token" key and assign to variable.
token = (response.json()["token"])
print(token)
### Reset HEADERS to include bearer auth.
headers = {
	'Accept': 'application/json',
	'Authorization': 'Bearer ' + token
}
categories = requests.request("GET", url + "/JSSResource/categories", headers=headers, data=payload)
print(categories.text)



### Invalidate bearer token.
invalid_token = requests.request("POST", url + "/api/v1/auth/invalidate-token", headers=headers, data=payload)
### Check token is invalid. <401> UNAUTHORIZED, INVALID_TOKEN
categories = requests.request("GET", url + "/JSSResource/categories", headers=headers, data=payload)
print(categories.text)
