import requests
import sys
import time
import os

CHUNK_SIZE=1024*1024
url=sys.argv[1]
fname=sys.argv[2]
purefname=fname.split(".")[0]
while(1):
    response=requests.get(url,stream=True)
    if response.status_code==404:
        with open(purefname+'.sta',"w") as mf:
            mf.write("NOTREADY")
        time.sleep(1)
        continue
    f=open(fname,"wb")
    with open(purefname+'.sta',"w") as mf:
        mf.write("STARTED")
    for chunk in response.iter_content(chunk_size=CHUNK_SIZE):
        if chunk:
            f.write(chunk)
            
    os.remove(purefname+'.sta')
    exit(0)