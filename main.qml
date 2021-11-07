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
    property var mjk: []

    id: mainwindow
//    maximumHeight: mht
//    maximumWidth: mwt
//    minimumHeight: mht
//    minimumWidth: mwt
    width: mwt
    height: mht
    visible: true
    title: "Wallpaper Engine Workshop Downloader"

    MessageDialog {
        id: messageDialog

        title: "Downloader"
        text: "Starting to download this wallpaper"
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
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        c1.color='#F0F0F0'
                        c3.color='#F0F0F0'
                        parent.color='#E0E0E0'
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
                        let msg=qprocess.launch("python3 main.py "+searchbox.text);
                        messagetext.text=msg;
                        if(msg==='-1\n'){
                            console.log("OK");
                            messagetext.text='Cannot connect to steam Wallpaper Engine workshop, please check your internet connection';
                            Myjs.deletePreview();
                        }else{
                            messagetext.text='';
                            Myjs.loadPreview(msg);
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
                            var obj=previewunit.createObject(previewLayout);
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
                        anchors.fill: myrect
                        hoverEnabled: true
                        onEntered: {
                            myrect.color='#F0F0F0'
                        }
                        onExited: {
                            myrect.color='#E0E0E0'
                        }
                        onDoubleClicked: {
                            //Start to download
                            qprocess.launch('python3 down.py '+wpid);
                            messageDialog.open();
                        }
                    }
                }

            }

        }

        Rectangle{
            anchors.fill: parent
            color: 'blue'
        }
        Text{
            text: 'About'
        }
    }


    Component.onDestruction: {
        console.log("Exiting...");
        qprocess.launch('python3 del.py');
    }
}

