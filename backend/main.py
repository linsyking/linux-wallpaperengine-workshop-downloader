import json
import requests
import sys
import os
import re
import time
import shutil
import html

TIME_OUT=8
curtime=0
regs=[]

def checkfull():
    global curtime,regs
    #Check if the download finished
    if(curtime>TIME_OUT):
        return 0
    for i in regs:
        thisid=json.loads(i[1])['id']
        if(not os.path.exists('./img/'+thisid+'.jpg')) or os.path.getsize('./img/'+thisid+'.jpg')==0:
            curtime=curtime+0.1
            os.system('wget -q "'+i[0]+'" -O ./img/'+thisid+'.jpg &')
            os.system('./')
            time.sleep(0.1)
            return 1
    return 0;

def getuuid(wpid):
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

    data = '{"publishedFileId":'+wpid+',"collectionId":null,"extract":false,"hidden":false,"direct":false,"autodownload":false}'
    response = requests.post('https://node03.steamworkshopdownloader.io/prod/api/download/request', headers=headers, data=data).content.decode(encoding='utf-8',errors='ignore')
    uuid=json.loads(response)['uuid']
    return uuid
#START

if(not os.path.exists('./img')):
    os.mkdir('img')

if(sys.argv[1]=='-d'):
    shutil.rmtree('./img')
    os.mkdir('img')
    exit(0)

if(sys.argv[1]=='-D'):
    myu=getuuid(sys.argv[2])
    mycom='python3 downfile.py "https://node03.steamworkshopdownloader.io/prod/api/download/transmit?uuid='+myu+'" '+sys.argv[2]+'.zip &'
    os.system(mycom)
    exit(0)

ssid=""
for i in range(1,len(sys.argv)-1):
    ssid+=sys.argv[i]+' '
ssid+=sys.argv[len(sys.argv)-1]

trytime=0
while(trytime>=0 and trytime<3):
    try:
        response=requests.get('https://steamcommunity.com/workshop/browse/?appid=431960&searchtext='+ssid+'&browsesort=trend&section=readytouseitems&created_date_range_filter_start=0&created_date_range_filter_end=0&updated_date_range_filter_start=0&updated_date_range_filter_end=0&actualsort=trend&p=1&days=-1',timeout=1)
        trytime=-1
    except Exception as e:
        trytime=trytime+1
if(trytime==3):
    print("-1")
    exit(0)
mytxt=response.content.decode(encoding='utf-8',errors='ignore')
regr=r'workshopItemPreviewImage.*?src="(.*?)"[\s\S]*?SharedFileBindMouseHover.*?(\{.*?\})'
regx=re.compile(regr)
regs=re.findall(regx,mytxt)

if(checkfull()==0):
    #Finished
    mylist=[]
    for item in regs:
        myreq=json.loads(item[1])
        myreq['title']=html.unescape(myreq['title'])    #May have potential risk
        if(len(myreq['title'])>20):
            myreq['title']=myreq['title'][0:19]+'...'
        mylist.append({'name':myreq['title'],'imgpath':'img/'+myreq['id']+'.jpg','id':myreq['id']})
    print(json.dumps(mylist))
    exit(0)


mylist=[]
for item in regs:
    myreq=json.loads(item[1])
    myreq['title']=html.unescape(myreq['title'])
    if(len(myreq['title'])>20):
        myreq['title']=myreq['title'][0:19]+'...'
    os.system('wget -q "'+item[0]+'" -O ./img/'+myreq['id']+'.jpg &')
    mylist.append({'name':myreq['title'],'imgpath':'img/'+myreq['id']+'.jpg','id':myreq['id']})
os.system('./')

while(checkfull()):
    pass

print(json.dumps(mylist))