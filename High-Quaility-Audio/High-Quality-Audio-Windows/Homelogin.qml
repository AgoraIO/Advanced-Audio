import QtQuick 2.4

HomeloginForm{
    anchors.fill: parent
    btnJoin.onClicked:{
         main.joinedpage(txtChannelName.text,txtMobileUid.text)
    }

    cbMicrophones.activeFocusOnPress: {
        var current = cbMicrophones.model.get(cbMicrophones.currentIndex)
        if (current && current.guid)
            agoraRtcEngine.setRecordingDevice(current.guid)
    }

    Component.onCompleted: {
        textInputChannel.text = main.channelName
        textInputMobileUid.text = main.mobileuid

		var i, devices
        devices = agoraRtcEngine.getRecordingDeviceList()
        //console.log(devices.name)
        if (devices && devices.length > 0) {
            for (i = 0; i < devices.length; i++) {
                cbMicrophones.model.append({text: devices.name[i], guid: devices.guid[i]})
            }
        }
    }
}
