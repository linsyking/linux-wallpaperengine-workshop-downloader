import json
import requests
import sys
import os
import re
import time
TIME_OUT=3
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

trytime=0
while(trytime>=0 and trytime<3):
    try:
        response=requests.get('https://steamcommunity.com/workshop/browse/?appid=431960&searchtext='+sys.argv[1]+'&browsesort=trend&section=readytouseitems&created_date_range_filter_start=0&created_date_range_filter_end=0&updated_date_range_filter_start=0&updated_date_range_filter_end=0&actualsort=trend&p=1&days=-1',timeout=1)
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
        if(len(myreq['title'])>20):
            myreq['title']=myreq['title'][0:19]+'...'
        mylist.append({'name':myreq['title'],'imgpath':'img/'+myreq['id']+'.jpg','id':myreq['id']})
    print(json.dumps(mylist))
    exit(0)


mylist=[]
for item in regs:
    myreq=json.loads(item[1])
    if(len(myreq['title'])>20):
        myreq['title']=myreq['title'][0:19]+'...'
    os.system('wget -q "'+item[0]+'" -O ./img/'+myreq['id']+'.jpg &')
    mylist.append({'name':myreq['title'],'imgpath':'img/'+myreq['id']+'.jpg','id':myreq['id']})
os.system('./')

while(checkfull()):
    pass

print(json.dumps(mylist))