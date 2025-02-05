import json
import requests
import sys
import os
import re
import time
import shutil
import html

TIME_OUT = 8
regs = []
getPnum = "1"
argstart = 1


def downloadall(regs):
    # Check if the download finished
    curtime = 0
    if curtime > TIME_OUT:
        print("-1")
        exit(0)
    for i in regs:
        thisid = i[1]
        if (not os.path.exists(f"./img/{thisid}.jpg")) or os.path.getsize(
            f"./img/{thisid}.jpg"
        ) == 0:
            curtime = curtime + 1
            # os.system('wget -q "' + i[0] + '" -O ./img/' + thisid + ".jpg &")
            response = requests.get(i[0], stream=True)
            with open(f"img/{thisid}.jpg", "wb") as handle:
                for data in response.iter_content(chunk_size=1024):
                    handle.write(data)
            time.sleep(1)


# START

if not os.path.exists("./img"):
    os.mkdir("img")

if sys.argv[1] == "-d":
    shutil.rmtree("./img")
    os.mkdir("img")
    exit(0)

if sys.argv[1] == "-D":
    mycom = (
        'steamcmd "+login xlmns" "+workshop_download_item 431960 {sys.argv[2]}" +quit'
    )
    os.system(mycom)
    exit(0)

if sys.argv[1] == "-p":  # Define specific page
    getPnum = sys.argv[2]
    argstart = 3


ssid = ""
for i in range(argstart, len(sys.argv) - 1):
    ssid += sys.argv[i] + " "
ssid += sys.argv[len(sys.argv) - 1]
trytime = 0
while trytime >= 0 and trytime < 3:
    try:
        response = requests.get(
            "https://steamcommunity.com/workshop/browse/?appid=431960&searchtext="
            + ssid
            + "&browsesort=trend&section=readytouseitems&created_date_range_filter_start=0&created_date_range_filter_end=0&updated_date_range_filter_start=0&updated_date_range_filter_end=0&actualsort=trend&p="
            + getPnum
            + "&days=-1",
            timeout=1,
        )
        trytime = -1
    except Exception as e:
        trytime = trytime + 1

if trytime == 3:
    print("-1")
    exit(0)

mytxt = response.content.decode(encoding="utf-8", errors="ignore")
regr = r'workshopItemPreviewImage.*?src="(.*?)"[\s\S]*?filedetails/\?id=(.*?)&[\s\S]*?workshopItemTitle ellipsis">(.*?)</div>[\s\S]*?workshopItemAuthorName ellipsis">.*?>(.*?)</a></div>'
regx = re.compile(regr)
regs = re.findall(regx, mytxt)

downloadall(regs)

mylist = []
for item in regs:
    tit = html.unescape(item[2])
    if len(tit) > 20:
        tit = tit[0:19] + "..."
    mylist.append(
        {
            "name": tit,
            "imgpath": f"img/{item[1]}.jpg",
            "author": html.unescape(item[3]),
            "id": item[1],
        }
    )

print(json.dumps(mylist))
