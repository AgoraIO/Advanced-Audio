import AgoraRTC from 'agora-rtc-sdk'
import {Toast, addView, removeView} from './common'

console.log('agora sdk version: ' + AgoraRTC.VERSION + ' compatible: ' + AgoraRTC.checkSystemRequirements())

export default class RTCClient {
  constructor () {
    this._client = null
    this._joined = false
    this._published = false
    this._localStream = null
    this._remoteStreams = []
    this._audioMixingState = 'stop'
    this._audioEffectState = 'stop'
    this._params = {}

    this._showProfile = false
  }

  handleEvents() {
    this._client.on('error', (err) => {
      console.log('error', err)
      console.log(err)
    })
    // Occurs when the peer user leaves the channel; for example, the peer user calls Client.leave.
    this._client.on('peer-leave', (evt) => {
      const id = evt.uid
      if (id != this._params.uid) {
        removeView(id)
      }
      Toast.notice('peer leave')
      console.log('peer-leave', id)
    })
    // Occurs when the local stream is _published.
    this._client.on('stream-published', (evt) => {
      Toast.notice('stream published success')
      console.log('stream-published')
    })
    // Occurs when the remote stream is added.
    this._client.on('stream-added', (evt) => {  
      const remoteStream = evt.stream
      const id = remoteStream.getId()
      Toast.info('stream-added uid: ' + id)
      if (id !== this._params.uid) {
        this._client.subscribe(remoteStream, (err) => {
          console.log('stream subscribe failed', err)
        })
      }
      console.log('stream-added remote-uid: ', id)
    })
    // Occurs when a user subscribes to a remote stream.
    this._client.on('stream-subscribed', (evt) => {
      const remoteStream = evt.stream
      const id = remoteStream.getId()
      this._remoteStreams.push(remoteStream)
      addView(id, this._showProfile)
      remoteStream.play('remote_video_' + id, {fit: 'cover'})
      Toast.info('stream-subscribed remote-uid: ' + id)
      console.log('stream-subscribed remote-uid: ', id)
    })
    // Occurs when the remote stream is removed; for example, a peer user calls Client.unpublish.
    this._client.on('stream-removed', (evt) => {
      const remoteStream = evt.stream
      const id = remoteStream.getId()
      Toast.info('stream-removed uid: ' + id)
      remoteStream.stop()
      this._remoteStreams = this._remoteStreams.filter((stream) => {
        return stream.getId() !== id
      })
      removeView(id)
      console.log('stream-removed remote-uid: ', id)
    })
    this._client.on('onTokenPrivilegeWillExpire', () => {
      // After requesting a new token
      // this._client.renewToken(token);
      Toast.info('onTokenPrivilegeWillExpire')
      console.log('onTokenPrivilegeWillExpire')
    })
    this._client.on('onTokenPrivilegeDidExpire', () => {
      // After requesting a new token
      // client.renewToken(token);
      Toast.info('onTokenPrivilegeDidExpire')
      console.log('onTokenPrivilegeDidExpire')
    })
    this._client.on('network-quality', (stats) => {
      const qualityProgressPresenter = {
        1: '100%',
        2: '80%',
        3: '60%',
        4: '40%',
        5: '20%',
        6: '10%'
      }
      if (stats.uplinkNetworkQuality != 0) {
        $('#net_up').attr({'style': 'width: ' + qualityProgressPresenter[stats.uplinkNetworkQuality] + ''})
      }
      if (stats.downlinkNetworkQuality != 0) {
        $('#net_down').attr({'style': 'width: ' + qualityProgressPresenter[stats.downlinkNetworkQuality] + ''})
      }
    })
  }

  join (data) {
    return new Promise((resolve, reject) => {    
      if (this._joined) {
        Toast.error('Your already joined')
        return
      }
    
      /**
       * A class defining the properties of the config parameter in the createClient method.
       * Note:
       *    Ensure that you do not leave mode and codec as empty.
       *    Ensure that you set these properties before calling Client.join.
       *  You could find more detail here. https://docs.agora.io/en/Video/API%20Reference/web/interfaces/agorartc.clientconfig.html
      **/
      this._client = AgoraRTC.createClient({mode: data.mode, codec: data.codec})
    
      this._params = data
    
      // handle AgoraRTC client event
      this.handleEvents()
    
      // init client
      this._client.init(data.appID, () => {
        console.log('init success')
    
        /**
         * Joins an AgoraRTC Channel
         * This method joins an AgoraRTC channel.
         * Parameters
         * tokenOrKey: string | null
         *    Low security requirements: Pass null as the parameter value.
         *    High security requirements: Pass the string of the Token or Channel Key as the parameter value. See Use Security Keys for details.
         *  channel: string
         *    A string that provides a unique channel name for the Agora session. The length must be within 64 bytes. Supported character scopes:
         *    26 lowercase English letters a-z
         *    26 uppercase English letters A-Z
         *    10 numbers 0-9
         *    Space
         *    "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", "{", "}", "|", "~", ","
         *  uid: number | null
         *    The user ID, an integer. Ensure this ID is unique. If you set the uid to null, the server assigns one and returns it in the onSuccess callback.
         *   Note:
         *      All users in the same channel should have the same type (number) of uid.
         *      If you use a number as the user ID, it should be a 32-bit unsigned integer with a value ranging from 0 to (232-1).
        **/
        this._client.join(data.token ? data.token : null, data.channel, data.uid ? data.uid : null, (uid) => {
          this._params.uid = uid
          Toast.notice('join channel: ' + data.channel + ' success, uid: ' + uid)
          console.log('join channel: ' + data.channel + ' success, uid: ' + uid)
          this._joined = true
    
          // start stream interval stats
          // if you don't need show stream profile you can comment this
          if (!this._interval) {
            this._interval = setInterval(() => {
              this._updateVideoInfo()
            }, 0)
          }
    
          // create local stream
          this._localStream = AgoraRTC.createStream({
            streamID: this._params.uid,
            audio: true,
            video: true,
            screen: false,
            microphoneId: data.microphoneId,
            cameraId: data.cameraId
          })

          this._localStream.on('player-status-change', (evt) => {
            console.log('player status change', evt)
          })

          this._localStream.on('audioMixingPlayed', () => {
            Toast.info('audioMixingPlayed')
            console.log('audioMixingPlayed')
          })
          this._localStream.on('audioMixingFinished', () => {
            Toast.info('audioMixingFinished')
            console.log('audioMixingFinished')
          })

          if (data.cameraResolution && data.cameraResolution != 'default') {
            // set local video resolution
            this._localStream.setVideoProfile(data.cameraResolution)
          }
    
          // init local stream
          this._localStream.init(() => {
            console.log('init local stream success')
            // play stream with html element id "local_stream"
            this._localStream.play('local_stream', {fit: 'cover'})
    
            // run callback
            resolve()
          }, (err) =>  {
            Toast.error('stream init failed, please open console see more detail')
            console.error('init local stream failed ', err)
          })
        }, function(err) {
          Toast.error('client join failed, please open console see more detail')
          console.error('client join failed', err)
        })
      }, (err) => {
        Toast.error('client init failed, please open console see more detail')
        console.error(err)
      })
    })
  }

  publish () {
    if (!this._client) {
      Toast.error('Please Join First')
      return
    }
    if (this._published) {
      Toast.error('Your already published')
      return
    }
    const oldState = this._published
  
    // publish localStream
    this._client.publish(this._localStream, (err) => {
      this._published = oldState
      console.log('publish failed')
      Toast.error('publish failed')
      console.error(err)
    })
    Toast.info('publish')
    this._published = true
  }

  unpublish () {
    if (!this._client) {
      Toast.error('Please Join First')
      return
    }
    if (!this._published) {
      Toast.error('Your didn\'t publish')
      return
    }
    const oldState = this._published
    this._client.unpublish(this._localStream, (err) => {
      this._published = oldState
      console.log('unpublish failed')
      Toast.error('unpublish failed')
      console.error(err)
    })
    Toast.info('unpublish')
    this._published = false
  }

  leave () {
    if (!this._client) {
      Toast.error('Please Join First!')
      return
    }
    if (!this._joined) {
      Toast.error('You are not in channel')
      return
    }
    // leave channel
    this._client.leave(() => {
      // close stream
      this._localStream.close()

      $('#local_video_info').addClass('hide')
      // stop stream
      this._localStream.stop()
      while (this._remoteStreams.length > 0) {
        const stream = this._remoteStreams.shift()
        const id = stream.getId()
        stream.stop()
        removeView(id)
      }
      this._localStream = null
      this._remoteStreams = []
      this._client = null
      console.log('client leaves channel success')
      this._published = false
      this._joined = false
      Toast.notice('leave success')
    }, (err) => {
      console.log('channel leave failed')
      Toast.error('leave success')
      console.error(err)
    })
  }

  _transmitAudioMixingState (state) {
    if (this._audioMixingState == 'start' && ['stop', 'resume', 'pause'].indexOf(state) != -1) {
      return true
    } else if (this._audioMixingState == 'stop' && ['start'].indexOf(state) != -1) {
      return true
    } else if (this._audioMixingState == 'resume' && ['start', 'stop', 'pause'].indexOf(state) != -1) {
      return true
    } else if (this._audioMixingState == 'pause' && ['start', 'stop', 'resume'].indexOf(state) != -1) {
      return true
    }
    console.log(`Can't transmit audio mixing state: ${this._audioMixingState}, into: ${state}`)
  }

  startAudioMixing (filePath) {
    if (!this._client) {
      Toast.error('Please Join First!')
      return
    }
    if (!this._joined) {
      Toast.error('You are not in channel')
      return
    }
    if (!this._transmitAudioMixingState('start')) {
      return
    }

    /**
   * startAudioMixing
   * This method mixes the specified online audio file with the audio stream from the microphone; or, it replaces the microphone’s audio stream with the specified online audio file.
   * Note:
   * This method supports the following browsers:
   *   Call this method when you are in a channel, otherwise, it may cause issues.
   *   Due to browser policy changes, this method must be triggered by the user's gesture on the Chrome 70+ and Safari browser. See Autoplay Policy Changes for details.
   * 
   * GET MORE DETAILS PLEASE VISIT IT ON DOCUMENTATION https://docs.agora.io/en/Audio%20Broadcast/API%20Reference/web/interfaces/agorartc.stream.html#startaudiomixing
   */
    this._localStream.startAudioMixing({
      filePath: filePath, // valid audio filepath
      playTime: 0, // If you need to play the file from the beginning, set this paramter to 0.
      loop: true // whether the audio mixing file loops infinitely.
    }, (error) => {
      if (error) {
        Toast.error('start audio mixing failed, please open console see more detail')
        console.error(error)
        return
      }
      console.log(this._localStream.audioMixing)
      this._audioMixingState = 'start'
      console.log('start audio mixing success')
    })
  }

  // This method requried invoke after join channel success
  stopAudioMixing () {
    if (!this._client) {
      Toast.error('Please Join First!')
      return
    }
    if (!this._joined) {
      Toast.error('You are not in channel')
      return
    }
    if (!this._transmitAudioMixingState('stop')) {
      return
    }

    this._localStream.stopAudioMixing((error) => {
      if (error) {
        Toast.error('stop audio mixing failed, please open console see more detail')
        console.error(error)
        return
      }
      this._audioMixingState = 'stop'
      console.log('stop audio mixing success')
    })
  }

  pauseAudioMixing () {
    if (!this._client) {
      Toast.error('Please Join First!')
      return
    }
    if (!this._joined) {
      Toast.error('You are not in channel')
      return
    }
    if (!this._transmitAudioMixingState('pause')) {
      return
    }
    this._localStream.pauseAudioMixing((error) => {
      if (error) {
        Toast.error('pause audio mixing failed, please open console see more detail')
        console.error(error)
        return
      }
      this._audioMixingState = 'pause'
      console.log('pause audio mixing success')
    })
  }

  resumeAudioMixing () {
    if (!this._client) {
      Toast.error('Please Join First!')
      return
    }
    if (!this._joined) {
      Toast.error('You are not in channel')
      return
    }
    if (!this._transmitAudioMixingState('resume')) {
      return
    }

    this._localStream.resumeAudioMixing((error) => {
      if (error) {
        Toast.error('resume audio mixing failed, please open console see more detail')
        console.error(error)
        return
      }
      this._audioMixingState = 'resume'
      console.log('resume audio mixing success')
    })
  }

  _transmitAudioEffectState (state) {
    if (this._audioEffectState == 'start' && ['stop', 'resume', 'pause', 'start'].indexOf(state) != -1) {
      return true
    } else if (this._audioEffectState == 'stop' && ['start'].indexOf(state) != -1) {
      return true
    } else if (this._audioEffectState == 'resume' && ['start', 'stop', 'pause'].indexOf(state) != -1) {
      return true
    } else if (this._audioEffectState == 'pause' && ['start', 'stop', 'resume'].indexOf(state) != -1) {
      return true
    }
    console.log(`Can't transmit audio effect state: ${this._audioEffectState}, into: ${state}`)
  }

  /**
   * playEffect
   * This method supports playing multiple audio effect files at the same time, and is different from startAudioMixing.
   * You can use this method to add specific audio effects for specific scenarios. For example, gaming.
   * Note:
   * This method supports the following browsers:
   *   Call this method when you are in a channel, otherwise, it may cause issues.
   *   Due to browser policy changes, this method must be triggered by the user's gesture on the Chrome 70+ and Safari browser. See Autoplay Policy Changes for details.
   * 
   * GET MORE DETAILS PLEASE VISIT IT ON DOCUMENTATION https://docs.agora.io/en/Audio%20Broadcast/API%20Reference/web/interfaces/agorartc.stream.html#playeffect
   */
  playEffect (filePaths) {
    if (!this._client) {
      Toast.error('Please Join First!')
      return
    }
    if (!this._joined) {
      Toast.error('You are not in channel')
      return
    }

    if (!this._transmitAudioEffectState('start')) {
      return
    }

    for (let filePath of filePaths) {
      this._localStream.playEffect({
        soundId: Date.now() % 10000, // id of the specified audio effect
        cycle: 1, // playback loops
        filePath: filePath  // valid audio filepath
      }, (error) => {
        if (error) {
          Toast.error('start audio effect failed, please open console see more detail')
          console.error(error)
          return
        }
        this._audioEffectState = 'start'
        console.log('start audio effect success')
      })
    }
  }

  stopEffect () {
    if (!this._client) {
      Toast.error('Please Join First!')
      return
    }
    if (!this._joined) {
      Toast.error('You are not in channel')
      return
    }

    if (!this._transmitAudioEffectState('stop')) {
      return
    }

    this._localStream.stopAllEffects((error) => {
      if (error) {
        Toast.error('stop audio effect failed, please open console see more detail')
        console.error(error)
        return
      }
      this._audioEffectState = 'stop'
      console.log('stop audio effect success')
    })
  }

  resumeEffect () {
    if (!this._client) {
      Toast.error('Please Join First!')
      return
    }
    if (!this._joined) {
      Toast.error('You are not in channel')
      return
    }

    if (!this._transmitAudioEffectState('resume')) {
      return
    }

    this._localStream.resumeAllEffects((error) => {
      if (error) {
        Toast.error('resume audio effect failed, please open console see more detail')
        console.error(error)
        return
      }
      this._audioEffectState = 'resume'
      console.log('resume audio effect success')
    })
  }

  pauseEffect () {
    if (!this._client) {
      Toast.error('Please Join First!')
      return
    }
    if (!this._joined) {
      Toast.error('You are not in channel')
      return
    }

    if (!this._transmitAudioEffectState('pause')) {
      return
    }

    this._localStream.pauseAllEffects((error) => {
      if (error) {
        Toast.error('pause audio effect failed, please open console see more detail')
        console.error(error)
        return
      }
      this._audioEffectState = 'pause'
      console.log('pause audio effect success')
    })
  }

  _updateVideoInfo () {
    this._localStream && this._localStream.getStats((stats) => {
      const localStreamProfile = [
        ['Uid: ', this._localStream.getId()].join(''),
        ['SDN access delay: ', stats.accessDelay, 'ms'].join(''),
        ['Video send: ', stats.videoSendFrameRate, 'fps ', stats.videoSendResolutionWidth + 'x' + stats.videoSendResolutionHeight].join(''),
      ].join('<br/>')
      $('#local_video_info')[0].innerHTML = localStreamProfile
    })

    if (this._remoteStreams.length > 0) {
      for (let remoteStream of this._remoteStreams) {
        remoteStream.getStats((stats) => {
          const remoteStreamProfile = [
            ['Uid: ', remoteStream.getId()].join(''),
            ['SDN access delay: ', stats.accessDelay, 'ms'].join(''),
            ['End to end delay: ', stats.endToEndDelay, 'ms'].join(''),
            ['Video recv: ', stats.videoReceiveFrameRate, 'fps ', stats.videoReceiveResolutionWidth + 'x' + stats.videoReceiveResolutionHeight].join(''),
          ].join('<br/>')
          if ($('#remote_video_info_'+remoteStream.getId())[0]) {
            $('#remote_video_info_'+remoteStream.getId())[0].innerHTML = remoteStreamProfile
          }
        })
      }
    }
  }

  setNetworkQualityAndStreamStats (enable) {
    this._showProfile = enable
    this._showProfile ? $('.video-profile').removeClass('hide') : $('.video-profile').addClass('hide')
  }
}

