import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.1
import Laucher 1.0
import './myjs.js' as Myjs


Window {
    property int mht: 600
    property int mwt: 1075
    property string mpath: "file:///" + applicationDirPath
    property int downloadnum:0
    property var downloaditems: []
    id: mainwindow
//    maximumHeight: mht
//    maximumWidth: mwt
//    minimumHeight: mht
//    minimumWidth: mwt
    width: mwt
    height: mht
    visible: true
    title: "Wallpaper Engine Workshop Downloader"


    Timer{
        id: checkme
        interval: 10
        running: false
        repeat: false
        onTriggered: {
            let msg=qprocess.launch("python3 main.py "+searchbox.text);
            messagetext.text=msg;
            if(msg==='-1\n'){
                messagetext.text='Cannot connect to steam Wallpaper Engine workshop, please check your internet connection';
                Myjs.deletePreview();
            }else{
                messagetext.text='';
                Myjs.loadPreview(msg);
            }
            running=false;
            busyIndicator.running=false;
        }
    }

    Rectangle{
        id: modemenu
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 150
        Column{
            anchors.fill: parent
            spacing: 2
            Rectangle{
                id: c1
                height: 50
                width: parent.width
                color: '#E0E0E0'
                Text {
                    anchors.centerIn: parent
                    text: 'Browsing'
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        c2.color='#F0F0F0'
                        c3.color='#F0F0F0'
                        parent.color='#E0E0E0'
                        mylayout.currentIndex=0;
                    }
                }
            }
            Rectangle{
                id: c2
                height: 50
                width: parent.width
                color: '#F0F0F0'
                Text {
                    anchors.centerIn: parent
                    text: 'Downloading'
                }
                Text{
                    id:ddnum
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    color: 'grey'
                    text: downloadnum
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        c1.color='#F0F0F0'
                        c3.color='#F0F0F0'
                        parent.color='#E0E0E0'
                        Myjs.loaddownload();
                        mylayout.currentIndex=1;
                    }
                }
            }
            Rectangle{
                id: c3
                height: 50
                width: parent.width
                color: '#F0F0F0'
                Text {
                    anchors.centerIn: parent
                    text: 'Settings'
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        c2.color='#F0F0F0'
                        c1.color='#F0F0F0'
                        parent.color='#E0E0E0'
                        mylayout.currentIndex=2;
                    }
                }
            }
        }
    }
    Rectangle{
        id:seprator
        anchors.left: modemenu.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: 'grey'
    }

    StackLayout{
        id: mylayout
        anchors.right: parent.right
        anchors.left: seprator.right
        currentIndex: 0
        ColumnLayout{
            anchors.fill: parent
            Rectangle{
                id: mainmenu
                Layout.alignment: Qt.AlignCenter
                Layout.preferredHeight: 50
                Layout.preferredWidth: parent.width
                Button{
                    id: search
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    width: 100
                    text: "Search"
                    onClicked: {
                        if(searchbox.text!=""){
                            busyIndicator.running=true;
                            checkme.running=true;
                        }
                    }
                }

                TextField{
                    id: searchbox
                    anchors.right: search.left
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    width: 200
                    selectByMouse: true
                    placeholderText: "Please enter search name"
                    Keys.onReturnPressed: {
                        searchbox.focus=false;
                        search.clicked();
                    }
                }
            }

            Rectangle{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredHeight: 2
                Layout.preferredWidth: parent.width
                color: 'grey'
            }

            Launcher{
                id: qprocess
            }

            Rectangle{
                Layout.preferredHeight: mainwindow.height-mainmenu.height-10
                Layout.preferredWidth: parent.width
                Layout.margins: 5
                Flickable{
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.DragOverBounds
                    clip: true
                    contentHeight: previewLayout.height+15
                    contentWidth: parent.width
                    Grid{
                        id: previewLayout
                        columnSpacing: 30
                        rowSpacing: 20
                        columns : 4
                        Layout.margins: 10

                        function createobj(myjson){
                            let obj=previewunit.createObject(previewLayout);
                            obj.init(myjson);
                        }

                    }

                    ScrollBar.vertical: ScrollBar {}
                }
                Text {
                    anchors.centerIn: parent
                    id: messagetext
                    color: 'grey'
                    font.bold: true
                    font.italic: true
                    font.pointSize: 14
                    text: ""
                }
            }


            Component{
                id: previewunit
                Rectangle{
                    id: myrect
                    width: 200
                    height: 200
                    color: '#E0E0E0'
                    radius: 5
                    property var wpid;
                    function init(myjson){
                        mylabel.text=myjson.name;
                        myimg.source=myjson.imgpath;
                        wpid=myjson.id;
                    }

                    Image {
                        id: myimg
                        anchors.fill: parent
                        anchors.margins: 5
                        anchors.bottomMargin: 30
                        source: ''
                        cache: false
                        fillMode: Image.PreserveAspectCrop
                    }
                    Text {
                        id: mylabel
                        text: ''
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 7
                    }

                    MouseArea{
                        //property bool isclicked:false
                        anchors.fill: myrect
                        hoverEnabled: true
                        onEntered: {
                            if(!focus) myrect.color='#F0F0F0'
                        }
                        onExited: {
                            if(!focus) myrect.color='#E0E0E0';
                        }
                        onDoubleClicked: {
                            //Start to download
                            //If the file has been downloaded TO-DO
                            downloadnum++;
                            downloaditems.push(wpid);
                            qprocess.launch("./control.sh main.py -D "+wpid);
                        }
                        onClicked: {
                            myrect.color='#2ECCFA'
                            mylabel.font.bold=true
                            focus=true;
                        }
                        onFocusChanged: {
                            if(!focus){
                                myrect.color='#E0E0E0'
                                mylabel.font.bold=false

                            }

                        }
                    }
                }

            }

        }

        Rectangle{  //Downloading
            anchors.fill: parent
            Flickable{
                id: downloadview
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.DragOverBounds
                ScrollBar.vertical: ScrollBar {}
                clip: true
                contentHeight: parent.height
                contentWidth: parent.width
                Grid{
                    id: myddlist
                    anchors.fill: parent
                    spacing: 2
                    columns: 1

                    function createobj(data){
                        let obj=downloadunit.createObject(myddlist);
                        obj.init(data);
                    }
                }
                Component{
                    id:downloadunit
                    Rectangle{
                        height: 70
                        width: parent.width
                        property string prog: 'Unknow'
                        property string cid;
                        property string nameid;
                        function init(data){
                            cid=data;
                            nameid=Myjs.findname(data);
                        }
                        Text{
                            id:myname
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            text: nameid
                        }
                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            text: 'Progress: '+prog
                        }
                        Rectangle{
                            anchors.top: parent.bottom
                            height: 2
                            anchors.left: parent.left
                            anchors.right: parent.right
                            color: 'grey'
                        }
                        Timer{
                            interval: 200
                            repeat: true
                            running: true
                            property bool isRun: false
                            onTriggered: {
                                //Detect file size
                                if(qprocess.launch('cat '+cid+'.sta')==='NOTREADY\n'){
                                    parent.prog='Waiting for the server'
                                    return;
                                }
                                let status=qprocess.launch('ls '+cid+'.sta');
                                if(status===''){
                                    if(isRun){
                                        parent.prog='Finished';
                                        running=false;
                                        return;
                                    }
                                }

                                let sd=qprocess.launch('./control.sh size '+cid+'.zip');
                                if(sd==='') return;

                                sd=sd.slice(0,sd.length-1);     //Cut \n
                                parent.prog=sd;
                                isRun=true;
                            }
                        }
                    }
                }

            }

        }

        Text{
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 50
            textFormat: TextEdit.MarkdownText
            text: Myjs.pysu
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: mylayout
        running: false
    }

    Component.onDestruction: {
        console.log("Exiting...");
        qprocess.launch('python3 main.py -d');
    }
}

