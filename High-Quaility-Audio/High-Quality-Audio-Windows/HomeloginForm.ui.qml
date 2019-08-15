import QtQuick 2.5
import "./controls"

Rectangle {
    id: homepage
    width: 800
    height: 600
	property alias btnJoin: btnJoin
    property alias txtChannelName: textInputChannel
    property alias txtMobileUid: textInputMobileUid

     Image {
            id: image1
            x: 0
            y: 0
            width: 800
            height: 600
            source: "images/index_win.png"
       }

       ADragArea {
            window: containerWindow
       }

       ATitle {
         width:400
         height: 24
         anchors.top: parent.top
         x:402
         anchors.topMargin: 0
       }

       property alias textInputChannel: textInputChannel
       TextInput {
           id: textInputChannel
           x:576
           y:219
           width:159
           height:22
           maximumLength: 18
           wrapMode:Text.wrapMode
           font.family:"微软雅黑"
           color: "#f1eeee"
           text: qsTr("")
           echoMode: TextInput.Normal
           horizontalAlignment: Text.AlignHCenter
           verticalAlignment: Text.AlignVCenter
           opacity: 1
           selectionColor: "#7e92ea"
           selectedTextColor: "#aaaa23"
           font.bold: true
           font.pixelSize: 12
           cursorVisible: true
       }

       property alias textInputMobileUid: textInputMobileUid
       TextInput {
           id: textInputMobileUid
           y: 269
           x: 576
           width: 159
           height: 21
           maximumLength: 18
           wrapMode:Text.wrapMode
           font.family:"微软雅黑"
           color: "#f1eeee"
           text: qsTr("")
           horizontalAlignment: Text.AlignHCenter
           verticalAlignment: Text.AlignVCenter
           opacity: 1
           selectionColor: "#7e92ea"
           selectedTextColor: "#aaaa23"
           font.bold: true
           font.pixelSize: 12
           cursorVisible: false
       }

       property alias cbMicrophones: cbMicrophones
       AComboBox {
           id: cbMicrophones
           width: 296
           height: 25
           x:452
           y:322
           fontSize: 14
           fontBold: false
           model: ListModel {
            //ListElement {text: "Local MicPhone"}
           }
       }

       AImageButton {
            id:btnJoin
            width:305
            height:44
            x:446
            y:378
            defaultImageSource: "images/join_channel.png"
            hoverImageSource: "images/join_channel_hover.png"
            pressedImageSource: "images/join_channel.png"
            text:qsTr("加入频道")
       }


}
