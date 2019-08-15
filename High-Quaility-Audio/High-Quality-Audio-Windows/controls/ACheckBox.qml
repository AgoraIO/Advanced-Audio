import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4

Rectangle {
    id:checkbox
    signal clicked
    property bool selected: false
    property url defaultImageSource:image.source
    property url selectedImageSource: image.source
    width:19
    height:19
    Component.onCompleted: {
        image.source = defaultImageSource
        console.log("completed:" ,image.source)
    }
    MouseArea {
        anchors.fill: parent
        onClicked: checkbox.clicked()
        onPressedChanged: {
            if (containsMouse) {
                if (pressed) {
                    selected = !selected
                    //console.log("selected:" ,selected)
                    image.source = selected? selectedImageSource:defaultImageSource
                    //console.log("pressed:" ,image.source)
                }
                else {
                    //image.source = defaultImageSource
                }
            }
        }
    }

    Image {
        id: image
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        onSourceSizeChanged: {
            image.width = sourceSize.width
            image.height = sourceSize.height
        }
    }
}

