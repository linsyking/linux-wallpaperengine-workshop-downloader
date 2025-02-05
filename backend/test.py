import re


with open("a.html", "r") as f:
    mytxt = f.read()

regr = r'workshopItemPreviewImage.*?src="(.*?)"[\s\S]*?filedetails/\?id=(.*?)&[\s\S]*?workshopItemTitle ellipsis">(.*?)</div>[\s\S]*?workshopItemAuthorName ellipsis">.*?>(.*?)</a></div>'

regx = re.compile(regr)
regs = re.findall(regx, mytxt)

for item in regs:
    print("img: ", item[0])
    print("title: ", item[1])
    print("author: ", item[2])
    print("author: ", item[3])
