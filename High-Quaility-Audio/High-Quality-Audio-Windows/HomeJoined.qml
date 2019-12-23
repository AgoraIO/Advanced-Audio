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


        cbReverbPreset.currentIndex = agoraRtcEngine.getReverbPreset()
       // cbVoiceChanger.currentIndex = agoraRtcEngine.getVoiceChanger()
       // cbBeautyVoice.currentIndex = agoraRtcEngine.getBeautyVoice()

      //  agoraRtcEngine.setReverbPreset(cbReverbPreset.currentIndex);
    }

    sliderMicrophoneVolume.onValueChanged:{
        agoraRtcEngine.setRecordingDeviceVolume(sliderMicrophoneVolume.value);
    }

    ckloopback.onClicked: {
        //console.log("click:" + ckloopback.selected)
        agoraRtcEngine.startLoopback(ckloopback.selected)
    }


    ckpcm.onClicked: {
        agoraRtcEngine.startPcmDump(ckpcm.selected)
    }

    cbMicrophones.activeFocusOnPress: {
        var current = cbMicrophones.model.get(cbMicrophones.currentIndex)
        if (current && current.guid)
            agoraRtcEngine.setRecordingDevice(current.guid)
    }

    cbReverbPreset.activeFocusOnPress: {
        agoraRtcEngine.setReverbPreset(cbReverbPreset.currentIndex);
    }

    cbVoiceChanger.activeFocusOnPress: {
        agoraRtcEngine.setVoiceChanger(cbVoiceChanger.currentIndex);
    }

    cbBeautyVoice.activeFocusOnPress: {
        agoraRtcEngine.setBeautyVoice(cbBeautyVoice.currentIndex);
    }
}
