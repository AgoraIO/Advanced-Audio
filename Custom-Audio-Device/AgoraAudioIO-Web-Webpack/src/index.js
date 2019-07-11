import RTCClient from './rtc-client';
import {getDevices, serializeFormData, validator, Toast} from './common';
import "./assets/style.scss";
import * as bs from 'bootstrap-material-design';

$(() => {
  let selects = null;
  
  $('body').bootstrapMaterialDesign();
  $("#settings").on("click", function (e) {
    e.preventDefault();
    $("#settings").toggleClass("btn-raised");
    $('#setting-collapse').collapse();
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
  })

  const fields = ['appID', 'channel'];

  let rtc = new RTCClient();

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


  $("#audio_mixing_resources").on("change", function (e) {
    e.preventDefault();
    console.log("change audio mixing")
    if (rtc._audioMixingState != 'stop') {
      rtc._localStream.stopAudioMixing((error) => {
        if (error) {
          Toast.error("stop audio mixing failed, please open console see more detail");
          console.error(error);
          return;
        }
        $("#audio-mixing").text("stop")
        rtc._audioAudioMixingState = 'stop';
        console.log("stop audio mixing success");
      })
    }
  })

  $("#audio_effect_resources").on("change", function (e) {
    e.preventDefault();
    console.log("change audio effect")
    if (rtc._audioEffectState != 'stop') {
      rtc._localStream.stopEffect(rtc._soundId, (error) => {
        if (error) {
          Toast.error("stop audio effect failed, please open console see more detail");
          console.error(error);
          return;
        }
        $("#audio-effect").text("stop");
        rtc._audioEffectState = 'stop';
        console.log("stop audio effect success");
      });
    }
  })

  $("#startMixing").on("click", function (e) {
    e.preventDefault();
    console.log("start mixing");
    console.log(params);
    const params = serializeFormData();
    if (validator(params, fields)) {
      $("#audio-mixing").text("start");
      rtc.startAudioMixing(params.audio_mixing_file);
    }
  })

  $("#stopMixing").on("click", function (e) {
    e.preventDefault();
    console.log("start mixing")
    const params = serializeFormData();
    if (validator(params, fields)) {
      $("#audio-mixing").text("stop")
      rtc.stopAudioMixing();
    }
  })

  $("#pauseMixing").on("click", function (e) {
    e.preventDefault();
    console.log("start mixing")
    const params = serializeFormData();
    if (validator(params, fields)) {
      $("#audio-mixing").text("pause")
      rtc.pauseAudioMixing();
    }
  })

  $("#resumeMixing").on("click", function (e) {
    e.preventDefault();
    console.log("start mixing")
    const params = serializeFormData();
    if (validator(params, fields)) {
      $("#audio-mixing").text("resume")
      rtc.resumeAudioMixing();
    }
  })

  $("#startEffect").on("click", function (e) {
    e.preventDefault();
    console.log("start audio effect")
    const params = serializeFormData();
    if (validator(params, fields)) {
      $("#audio-effect").text("start")
      const audio_effect_files = [];
      $("#effectA").is(":checked") && audio_effect_files.push($("#effectA").attr("value"));
      $("#effectB").is(":checked") && audio_effect_files.push($("#effectB").attr("value"));
      console.log("play effect", audio_effect_files);
      rtc.playEffect(audio_effect_files);
    }
  })

  $("#stopEffect").on("click", function (e) {
    e.preventDefault();
    console.log("stop audio effect")
    const params = serializeFormData();
    if (validator(params, fields)) {
      $("#audio-effect").text("stop")
      rtc.stopEffect();
    }
  })

  $("#pauseEffect").on("click", function (e) {
    e.preventDefault();
    console.log("pause audio effect")
    const params = serializeFormData();
    if (validator(params, fields)) {
      $("#audio-effect").text("pause")
      rtc.pauseEffect();
    }
  })

  $("#resumeEffect").on("click", function (e) {
    e.preventDefault();
    console.log("resume audio effect")
    const params = serializeFormData();
    if (validator(params, fields)) {
      $("#audio-effect").text("resume")
      rtc.resumeEffect();
    }
  })

})