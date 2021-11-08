import requests
import sys
import time
import os
import config
if(config.DOWNLOAD_PATH[-1:]!='/'):
    config.DOWNLOAD_PATH+='/'
CHUNK_SIZE=1024*1024
url=sys.argv[1]
fname=sys.argv[2]
purefname=fname.split(".")[0]
while(1):
    response=requests.get(url,stream=True)
    if response.status_code==404:
        with open(config.DOWNLOAD_PATH+purefname+'.sta',"w") as mf:
            mf.write("NOTREADY")
        time.sleep(1)
        continue
    f=open(config.DOWNLOAD_PATH+fname,"wb")
    with open(config.DOWNLOAD_PATH+purefname+'.sta',"w") as mf:
        mf.write("STARTED")
    for chunk in response.iter_content(chunk_size=CHUNK_SIZE):
        if chunk:
            f.write(chunk)
            
    os.remove(config.DOWNLOAD_PATH+purefname+'.sta')
    os.system('unzip -o '+config.DOWNLOAD_PATH+fname+' -d '+config.DOWNLOAD_PATH+purefname)
    os.remove(config.DOWNLOAD_PATH+fname)
    exit(0)