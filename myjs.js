var currentjson;
var mylist=[];
var pysu='# About \n\
**Wallpaper Engine Workshop Downloader**    \n\
**By linsyking** 2021\n\
';

function trans(fromString) {
    //console.log(fromString);
    return JSON.parse(fromString);
}

function loadPreview(data){
    //Delete objects
    for(var j in previewLayout.children){
        previewLayout.children[j].destroy();
    }
    //Create new objects
    var myjson=trans(data);
    currentjson=myjson;
    for(var i in myjson){
        myjson[i].imgpath=mpath+'/'+myjson[i].imgpath;
        previewLayout.createobj(myjson[i]);
    }
}

function deletePreview(){
    for(var j in previewLayout.children){
        previewLayout.children[j].destroy();
    }
}

function findname(id){
    //console.log(id);
    //Use id to find name
    for(var i in currentjson){
        if(currentjson[i].id===id){
            //console.log(currentjson[i].name);
            return currentjson[i].name;
        }
    }
}

function loaddownload(){
    for(var j in myddlist.children){
        myddlist.children[j].destroy();
    }
    for(var i in downloaditems){
        myddlist.createobj(downloaditems[i]);
    }
}
