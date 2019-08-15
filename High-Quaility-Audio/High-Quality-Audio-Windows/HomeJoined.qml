import QtQuick 2.4

HomeJoinedForm {
	anchors.fill: parent
    btnLeave.onClicked:main.leaveChannel()
    Component.onCompleted: {
        var i, devices
        devices = agoraRtcEngine.getRecordingDeviceList()
        if (devices && devices.length > 0) {
            for (i = 0; i < devices.length; i++) {
                cbMicrophones.model.append({text: devices.name[i], guid: devices.guid[i]})
            }
        }

        sliderMicrophoneVolume.value = agoraRtcEngine.getRecordingDeviceVolume();
    }

    sliderMicrophoneVolume.onValueChanged:{
        agoraRtcEngine.setRecordingDeviceVolume(sliderMicrophoneVolume.value);
    }

    ckloopback.onClicked: {
        //console.log("click:" + ckloopback.selected)
        agoraRtcEngine.startLoopback(ckloopback.selected) }

    cbMicrophones.activeFocusOnPress: {
        var current = cbMicrophones.model.get(cbMicrophones.currentIndex)
        if (current && current.guid)
            agoraRtcEngine.setRecordingDevice(current.guid)
    }
}
