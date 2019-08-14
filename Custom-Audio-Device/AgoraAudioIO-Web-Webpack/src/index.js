import RTCClient from './rtc-client';
import {getDevices, serializeFormData, validator, Toast, resolutions} from './common';
import "./assets/style.scss";
import * as M from 'materialize-css';

$(() => {
  $('input[name="appID"],input[name="token"]').on("input", function () {
    this.value = $.trim(this.value);
  });

  let selects = null;
    
  $("#settings").on("click", function (e) {
    e.preventDefault();
    $(this).open(1);
  });

  getDevices(function (devices) {
    selects = devices;
    devices.audios.forEach(function (audio) {
      $('<option/>', {
        value: audio.value,
        text: audio.name,
      }).appendTo("#microphoneId");
    })
    devices.videos.forEach(function (video) {
      $('<option/>', {
        value: video.value,
        text: video.name,
      }).appendTo("#cameraId");
    })
    resolutions.forEach(function (resolution) {
      $('<option/>', {
        value: resolution.value,
        text: resolution.name
      }).appendTo("#cameraResolution");
    })
    M.AutoInit();
  })

  const fields = ['appID', 'channel'];

  let rtc = new RTCClient();

  $(".autoplay-fallback").on("click", function (e) {
    e.preventDefault()
    const id = e.target.getAttribute("id").split("video_autoplay_")[1]
    console.log("autoplay fallback")
    if (id === 'local') {
      rtc._localStream.resume().then(() => {
        Toast.notice("local resume")
        $(e.target).addClass("hide")
      }).catch((err) => {
        Toast.error("resume failed, please open console see more details")
        console.error(err)
      })
      return;
    }
    const remoteStream = rtc._remoteStreams.find((item) => `${item.getId()}` == id)
    if (remoteStream) {
      remoteStream.resume().then(() => {
        Toast.notice("remote resume")
        $(e.target).addClass("hide")
      }).catch((err) => {
        Toast.error("resume failed, please open console see more details")
        console.error(err)
      })
    }
  })

  $("#show_profile").on("change", function (e) {
    e.preventDefault();
    if (!rtc._joined) {
      $(this).removeAttr("checked");
      return false;
    }
    rtc.setNetworkQualityAndStreamStats(this.checked);
  })

  $("#join").on("click", function (e) {
    e.preventDefault();
    console.log("join")
    const params = serializeFormData();
    if (validator(params, fields)) {
      rtc.join(params).then(() => {
        rtc.publish();
      })
    }
  })

  $("#publish").on("click", function (e) {
    e.preventDefault();
    console.log("startLiveStreaming")
    const params = serializeFormData();
    if (validator(params, fields)) {
      rtc.publish();
    }
  });

  $("#unpublish").on("click", function (e) {
    e.preventDefault();
    console.log("stopLiveStreaming")
    const params = serializeFormData();
    if (validator(params, fields)) {
      rtc.unpublish();
    }
  });

  $("#leave").on("click", function (e) {
    e.preventDefault();
    console.log("leave")
    const params = serializeFormData();
    if (validator(params, fields)) {
      rtc.leave();
    }
  });


  $("#audio_mixing_file").on("change", function (e) {
    e.preventDefault();
    console.log("change audio mixing")
    if (rtc._audioMixingState != 'stop') {
      rtc._localStream.stopAudioMixing((error) => {
        if (error) {
          console.error(error);
          return;
        }
        $(".audio_mixing_state").each(function () {
          $(this).prop("checked", false);
        })
        $("#stop_mixing").prop("checked", true)
        rtc._audioMixingState = 'stop';
        console.log("stop audio mixing success");
      })
    }
  })

  $("#audio_effect_files").on("change", function (e) {
    e.preventDefault();
    console.log("change audio effect")
    if (rtc._audioEffectState != 'stop') {
      rtc._localStream.stopAllEffects((error) => {
        if (error) {
          console.error(error);
          return;
        }
        $(".audio_effect_state").each(function () {
          $(this).prop("checked", false);
        })
        $("#stop_effect").prop("checked", true)
        rtc._audioEffectState = 'stop';
        console.log("stop audio effect success");
      });
    }
  })

  $(".audio_mixing_state").on("change", function (e) {
    e.preventDefault();
    const params = serializeFormData();
    if (!validator(params, fields) || !rtc._joined) {
      $(this).removeAttr("checked");
      return false;
    }
    const operate = {
      'play': () => {
        rtc.startAudioMixing(params.audio_mixing_file);
      },
      'stop': () => {
        rtc.stopAudioMixing();
      },
      'pause': () => {
        rtc.pauseAudioMixing();
      },
      'resume': () => {
        rtc.resumeAudioMixing();
      }
    }
    operate[$(this).val()]();
  })

  $(".audio_effect_state").on("change", function (e) {
    e.preventDefault();
    const params = serializeFormData();
    if (!validator(params, fields) || !rtc._joined) {
      $(this).removeAttr("checked");
      return false;
    }

    params.audio_effect_files = M.FormSelect.getInstance($("#audio_effect_files")[0]).getSelectedValues();

    const operate = {
      'play': () => {
        rtc.playEffect(params.audio_effect_files);
      },
      'stop': () => {
        rtc.stopEffect();
      },
      'pause': () => {
        rtc.pauseEffect();
      },
      'resume': () => {
        rtc.resumeEffect();
      }
    }
    operate[$(this).val()]();
  })

})