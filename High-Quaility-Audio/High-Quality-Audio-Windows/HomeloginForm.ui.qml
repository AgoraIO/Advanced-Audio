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
        width: 400
        height: 24
        anchors.top: parent.top
        x: 402
        anchors.topMargin: 0
    }

    property alias textInputChannel: textInputChannel
    TextInput {
        id: textInputChannel
        x: 576
        y: 219
        width: 159
        height: 22
        maximumLength: 18
        wrapMode: Text.wrapMode
        font.family: "微软雅黑"
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
        wrapMode: Text.wrapMode
        font.family: "微软雅黑"
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
        x: 452
        y: 322
        fontSize: 14
        fontBold: false
        model: ListModel {
            //ListElement {text: "Local MicPhone"}
        }
    }

    property alias cbReverbPreset: cbReverbPreset
    AComboBox {
        id: cbReverbPreset
        width: 88
        height: 25
        x: 450
        y: 380
        fontSize: 14
        fontBold: false
        model: ListModel {
            id: list
            ListElement {text: "关闭"}
            ListElement {text: "KTV"}
            ListElement {text: "演唱会"}
            ListElement {text: "大叔"}
            ListElement {text: "小姐姐"}

            ListElement {text: "录音棚"}
            ListElement {text: "流行"}
            ListElement {text: qsTr("R\&B")}
            ListElement {text: "留声机"}
        }
    }

    property alias cbVoiceChanger: cbVoiceChanger
    AComboBox {
        id: cbVoiceChanger
        width: 80
        height: 25
        x: 556
        y: 380
        fontSize: 14
        fontBold: false
        model: ListModel {

            ListElement {text: "关闭"}
            ListElement {text: "浑厚"}
            ListElement {text: "低沉"}
            ListElement {text: "圆润"}
            ListElement {text: "假音"}
            ListElement {text: "饱满"}
            ListElement {text: "清澈"}
            ListElement {text: qsTr("高亢")}
            ListElement {text: "嘹亮"}
            ListElement {text: "空旷"}
        }
    }

    property alias cbBeautyVoice: cbBeautyVoice
    AComboBox {
        id: cbBeautyVoice
        width: 80
        height: 25
        x: 663
        y: 380
        fontSize: 14
        fontBold: false
        model: ListModel {

            ListElement {text: "关闭"}
            ListElement {text: "磁性"}
            ListElement {text: "清新"}
            ListElement {text: "活力"}
        }
    }

    AImageButton {
        id: btnJoin
        width: 305
        height: 44
        x: 448
        y: 431
        defaultImageSource: "images/join_channel.png"
        hoverImageSource: "images/join_channel_hover.png"
        pressedImageSource: "images/join_channel.png"
        text: qsTr("加入频道")
    }
}
