//
//  ChannelViewController.swift
//  SpeechRecognizer-iOS
//
//  Created by GongYuhua on 2019/7/8.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit
import Speech
import AgoraAudioKit

class ChannelViewController: UIViewController {

    @IBOutlet var remoteUidLabel: UILabel!
    @IBOutlet var remoteTextView: UITextView!
    
    var channel: String!
    var local: Locale!
    
    private lazy var speechRecognizer = SFSpeechRecognizer(locale: local)!
    private let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private var remoteUid: UInt = 0
    
    private lazy var engine: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: AppId, delegate: self)
        return engine
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        engine.joinChannel(byToken: nil, channelId: channel, info: nil, uid: 0, joinSuccess: nil)
        
        MediaWorker.setDelegate(self)
        speechRecognizer.delegate = self
        
        startRecognize()
        MediaWorker.registerAudioBuffer(inEngine: engine)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func doLeaveChannel() {
        MediaWorker.setDelegate(nil)
        MediaWorker.deregisterAudioBuffer(inEngine: engine)
        stopRecognize()
        engine.leaveChannel(nil)
        navigationController?.popViewController(animated: true)
    }
}

private extension ChannelViewController {
    func startRecognize() {
        recognitionRequest.shouldReportPartialResults = true
        
        // You can keep speech recognition data on device since iOS 13
        if #available(iOS 13, *) {
//            recognitionRequest.requiresOnDeviceRecognition = true
        }
        
        let textView = remoteTextView
        textView?.text = "Recognizing"
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) {result, error in
            if let result = result {
                textView?.text = result.bestTranscription.formattedString
            }
            
            if let error = error {
                textView?.text = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func stopRecognize() {
        recognitionRequest.endAudio()
    }
}

extension ChannelViewController: SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            remoteTextView.text = "Recognition Not Available"
        }
    }
}

extension ChannelViewController: MediaWorkerDelegate {
    func mediaWorkerDidReceiveRemotePCM(_ buffer: AVAudioPCMBuffer) {
        recognitionRequest.append(buffer)
    }
}

extension ChannelViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        guard remoteUid == 0 else {
            return
        }
        
        remoteUid = uid
        MediaWorker.setRemoteUid(uid)
        remoteUidLabel.text = "\(uid)"
    }
}
