import QtQuick 2.5
import "./controls"

Rectangle {
    id: channelpage
    width: 800
    height: 600
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
         width:400
         height: 24
         anchors.top: parent.top
         x:402
         anchors.topMargin: 0
    }

    property alias cbMicrophones: cbMicrophones
    AComboBox {
        id: cbMicrophones
        width: 296
        height: 26
        x:453
        y:241
        fontSize: 14
        fontBold: false
        model: ListModel {
            //ListElement {text: "Local MicPhone"}
        }
    }

    property alias sliderMicrophoneVolume: sliderMicrophoneVolume
    ASlider {
        id: sliderMicrophoneVolume
        x:454
        y:294
        width: 291
        height: 18
        minimumValue: 0
        maximumValue: 255
    }

    property alias ckloopback : ckloopback
    ACheckBox {
        id:ckloopback
        width:15
        height:15
        x:457
        y:334
        defaultImageSource: "images/loop_back.png"
        selectedImageSource: "images/icon_accept.png"
    }

    AImageButton {
         id:btnLeave
         width:305
         height:44
         x:446
         y:378
         text:qsTr("离开频道")
         defaultImageSource: "images/leave_channel.png"
         hoverImageSource: "images/leave_channel_hover.png"
         pressedImageSource: "images/leave_channel.png"
    }
}
