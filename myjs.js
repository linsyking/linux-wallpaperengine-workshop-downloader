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
