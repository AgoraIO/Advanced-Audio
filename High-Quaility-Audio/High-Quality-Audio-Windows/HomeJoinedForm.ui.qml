import QtQuick 2.5
import "./controls"

Rectangle {
    id: channelpage
    width: 800
    height: 600
    property alias ckpcm: ckpcm
    property alias btnLeave: btnLeave

    Image {
        id: bkjoined
        x: 0
        y: 0
        width: 800
        height: 600
        source: "images/index2_win.png"
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

   property alias cbMicrophones: cbMicrophones
    AComboBox {
        id: cbMicrophones
        width: 296
        height: 26
        x: 453
        y: 241
        fontSize: 14
        fontBold: false
        model: ListModel {
            //ListElement {text: "Local MicPhone"}
        }
    }

    property alias cbReverbPreset: cbReverbPreset
    AComboBox {
        id: cbReverbPreset
        width: 86
        height: 25
        x: 452
        y: 380
        fontSize: 14
        fontBold: false
        currentIndex: 0
        model: ListModel {
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

    property alias sliderMicrophoneVolume: sliderMicrophoneVolume
    ASlider {
        id: sliderMicrophoneVolume
        x: 454
        y: 294
        width: 291
        height: 18
        minimumValue: 0
        maximumValue: 255
    }


    property alias ckloopback: ckloopback
    ACheckBox {
        id: ckloopback
        width: 15
        height: 15
        x: 457
        y: 334
        defaultImageSource: "images/loop_back.png"
        selectedImageSource: "images/icon_accept.png"
    }

    AImageButton {
        id: btnLeave
        width: 305
        height: 44
        x: 447
        y: 432
        text: qsTr("离开频道")
        defaultImageSource: "images/leave_channel.png"
        hoverImageSource: "images/leave_channel_hover.png"
        pressedImageSource: "images/leave_channel.png"
    }

    ACheckBox {
        id: ckpcm
        x: 589
        y: 334
        width: 15
        height: 15
        selected: false
        selectedImageSource: "images/icon_accept.png"
        defaultImageSource: "images/loop_back.png"
    }
}
