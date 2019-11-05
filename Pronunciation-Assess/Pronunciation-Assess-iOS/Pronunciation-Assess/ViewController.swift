//
//  ViewController.swift
//  Pronunciation-Assess
//
//  Created by CavanSu on 2019/11/1.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit
import AgoraAudioKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var agoraKit: AgoraRtcEngineKit!
    let cxEngine = CXEngine()
    lazy var dataPlugin = AgoraMediaDataPlugin(agoraKit: agoraKit)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAgoraEngine()
        initializeCXEngine()
        joinChannel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    deinit {
        leaveChannel()
    }
    
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppId, delegate: nil)
        agoraKit.setRecordingAudioFrameParametersWithSampleRate(16000,
                                                                channel: 1,
                                                                mode: .readOnly,
                                                                samplesPerCall: 4000)
        
        dataPlugin.registerAudioRawDataObserver([.recordAudio])
        dataPlugin.audioDelegate = self
    }
    
    func joinChannel() {
        agoraKit.joinChannel(byToken: nil,
                             channelId: "pronunciation",
                             info:nil,
                             uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
                                
                                self.agoraKit.setEnableSpeakerphone(true)
        }
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
    }
    
    func initializeCXEngine() {
        cxEngine.prepare(withAppKey: CXAppKey, secrectKey: CXSecretKey)
        cxEngine.delegate = self
    }
    
    @IBAction func doStartTest(_ sender: UIButton) {
        guard let word = inputTextField.text, !word.isEmpty else {
            return
        }
        cxEngine.request(word)
    }
    
    @IBAction func doStopTest(_ sender: UIButton) {
        cxEngine.stopSend()
    }
}

extension ViewController: AgoraAudioDataPluginDelegate {
    func mediaDataPlugin(_ mediaDataPlugin: AgoraMediaDataPlugin, didRecord audioRawData: AgoraAudioRawData) -> AgoraAudioRawData {
        if cxEngine.isNeedAudioData {
            cxEngine.sendAudioData(audioRawData)
        }
        return audioRawData
    }
}

extension ViewController: CXEngineDelegate {
    func cxEngine(_ engine: CXEngine, pronunciateResult result: Int) {
        resultLabel.text = "\(result)"
    }
}
