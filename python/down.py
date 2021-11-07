import requests
import sys
import requests
import json
import os
import time

def getuuid():
    headers = {
        'authority': 'node03.steamworkshopdownloader.io',
        'sec-ch-ua': '"Google Chrome";v="95", "Chromium";v="95", ";Not A Brand";v="99"',
        'accept': 'application/json, text/plain, */*',
        'content-type': 'application/x-www-form-urlencoded',
        'sec-ch-ua-mobile': '?0',
        'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36',
        'sec-ch-ua-platform': '"Linux"',
        'origin': 'https://steamworkshopdownloader.io',
        'sec-fetch-site': 'same-site',
        'sec-fetch-mode': 'cors',
        'sec-fetch-dest': 'empty',
        'referer': 'https://steamworkshopdownloader.io/',
        'accept-language': 'en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7,ru;q=0.6',
    }

    data = '{"publishedFileId":'+sys.argv[1]+',"collectionId":null,"extract":false,"hidden":false,"direct":false,"autodownload":false}'

    response = requests.post('https://node03.steamworkshopdownloader.io/prod/api/download/request', headers=headers, data=data).content.decode(encoding='utf-8',errors='ignore')
    uuid=json.loads(response)['uuid']
    return uuid

myu=getuuid()   #Presend
mycom='wget -q "https://node03.steamworkshopdownloader.io/prod/api/download/transmit?uuid='+myu+'" -O '+sys.argv[1]+'.zip &'
os.system(mycom)

