//
//  RoomViewController.swift
//  Agora-RTC-With-Voice-Changer-iOS
//
//  Created by GongYuhua on 2017/4/7.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

protocol RoomVCDelegate: class {
    func roomVCNeedClose(_ roomVC: RoomViewController)
}

class RoomViewController: UIViewController {
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var muteAudioButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    
    var roomName: String!
    var effectVC: EffectViewController?
    var clientRole = AgoraClientRole.audience {
        didSet {
            updateBroadcastButton()
        }
    }
    weak var delegate: RoomVCDelegate?
    
    fileprivate var agoraKit: AgoraRtcEngineKit!
    fileprivate var logs = [String]()
    
    fileprivate var isBroadcaster: Bool {
        return clientRole == .broadcaster
    }
    fileprivate var audioMuted = false {
        didSet {
            muteAudioButton?.setImage(audioMuted ? #imageLiteral(resourceName: "btn_mute_blue") : #imageLiteral(resourceName: "btn_mute"), for: UIControlState())
        }
    }
    
    fileprivate var speakerEnabled = true {
        didSet {
            speakerButton?.setImage(speakerEnabled ? #imageLiteral(resourceName: "btn_speaker_blue") : #imageLiteral(resourceName: "btn_speaker"), for: UIControlState())
            speakerButton?.setImage(speakerEnabled ? #imageLiteral(resourceName: "btn_speaker") : #imageLiteral(resourceName: "btn_speaker_blue"), for: .highlighted)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomNameLabel.text = "\(roomName!)"
        logTableView.rowHeight = UITableViewAutomaticDimension
        logTableView.estimatedRowHeight = 25
        
        updateBroadcastButton()
        
        loadAgoraKit()
    }
    
    @IBAction func doBroadcastPressed(_ sender: UIButton) {
        audioMuted = false
        clientRole = isBroadcaster ? .audience : .broadcaster
        
        agoraKit.setClientRole(clientRole)
    }
    
    @IBAction func doMuteAudioPressed(_ sender: UIButton) {
        audioMuted = !audioMuted
        agoraKit.muteLocalAudioStream(audioMuted)
    }
    
    @IBAction func doSpeakerPressed(_ sender: UIButton) {
        speakerEnabled = !speakerEnabled
        agoraKit.setEnableSpeakerphone(speakerEnabled)
    }
    
    @IBAction func doClosePressed(_ sender: UIButton) {
        leaveChannel()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ToEffect", effectVC != nil {
            let button = sender as! UIButton
            effectVC?.popoverPresentationController?.sourceView = button
            effectVC?.popoverPresentationController?.permittedArrowDirections = .down
            effectVC?.popoverPresentationController?.delegate = self
            present(effectVC!, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEffect" {
            let desVC = segue.destination as! EffectViewController
            desVC.agoraKit = agoraKit
            desVC.popoverPresentationController?.delegate = self
            effectVC = desVC
        }
    }
}

private extension RoomViewController {
    func append(log string: String) {
        guard !string.isEmpty else {
            return
        }
        logs.append(string)
        var deleted: String?
        if logs.count > 200 {
            deleted = logs.removeFirst()
        }
        updateLogTable(withDeleted: deleted)
    }
    
    func updateLogTable(withDeleted deleted: String?) {
        guard let tableView = logTableView else {
            return
        }
        
        let insertIndexPath = IndexPath(row: logs.count - 1, section: 0)
        
        tableView.beginUpdates()
        if deleted != nil {
            tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
        tableView.insertRows(at: [insertIndexPath], with: .none)
        tableView.endUpdates()
        tableView.scrollToRow(at: insertIndexPath, at: .bottom, animated: false)
    }
    
    func updateBroadcastButton() {
        muteAudioButton?.isEnabled = isBroadcaster
        broadcastButton?.setImage(isBroadcaster ? #imageLiteral(resourceName: "btn_join_blue") : #imageLiteral(resourceName: "btn_join"), for: .normal)
    }
}

//MARK: - table view
extension RoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as! LogCell
        cell.set(log: logs[(indexPath as NSIndexPath).row])
        return cell
    }
}

//MARK: - engine
private extension RoomViewController {
    func loadAgoraKit() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        agoraKit.setChannelProfile(.liveBroadcasting)
        agoraKit.setClientRole(clientRole)
        
        let code = agoraKit.joinChannel(byToken: nil, channelId: roomName, info: nil, uid: 0, joinSuccess: nil)
        
        if code != 0 {
            DispatchQueue.main.async(execute: {
                self.append(log: "Join channel failed: \(code)")
            })
        }
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        delegate?.roomVCNeedClose(self)
    }
}

extension RoomViewController: AgoraRtcEngineDelegate {
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Interrupted")
    }
    
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Lost")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        append(log: "Occur error: \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        append(log: "Did joined channel: \(channel), with uid: \(uid), elapsed: \(elapsed)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        append(log: "Did joined of uid: \(uid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        append(log: "Did offline of uid: \(uid), reason: \(reason.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute api: String, error: Int) {
        append(log: "Did api call execute: \(api), error: \(error)")
    }
}

extension RoomViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
