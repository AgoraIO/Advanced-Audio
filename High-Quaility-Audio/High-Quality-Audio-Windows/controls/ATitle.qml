import QtQuick 2.5

Rectangle {
    id: title
    width: 400
    height: 24
    color:"#2c2c2d"

    ADragArea {
        window: containerWindow
    }

    AImageButton {
        id: btnMinimize
        x: 346
        y: 0
        width: 24
        height: 24
        anchors.right: btnClose.left
        anchors.rightMargin: 0
        defaultImageSource: "/images/btn_window_minimize.png"
        hoverImageSource: "/images/btn_window_minimize_touch.png"
        pressedImageSource: "/images/btn_window_minimize_push.png"
        onClicked: containerWindow.showMinimized()
    }
    AImageButton {
        id: btnClose
        x: 325
        y: 1
        width: 24
        height: 24
        opacity: 1
        anchors.right: parent.right
        anchors.rightMargin: 0
        defaultImageSource: "/images/btn_window_close.png"
        hoverImageSource: "/images/btn_window_close_touch.png"
        pressedImageSource: "/images/btn_window_close_push.png"
        onClicked: containerWindow.close()
    }
}

