//
//  RoomViewController.swift
//  YoYo
//
//  Created by CavanSu on 05/05/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    @IBOutlet weak var currenHeadImageView: UIImageView!
    @IBOutlet weak var currentNameLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputMessageView: UIView!
    @IBOutlet weak var inputMessageTextField: UITextField!
    @IBOutlet weak var inputMessageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var userNumLabel: UILabel!
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var playbackButton: UIButton!
    @IBOutlet weak var remindInputTextField: UITextField!
    @IBOutlet weak var backButtonTop: NSLayoutConstraint!
    @IBOutlet weak var bgImageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var seatViewWidth: NSLayoutConstraint!
    @IBOutlet weak var seatViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var settingButton: UIButton!
    
    private var role: RoomRole = .audience {
        didSet {
            switch role {
            case .broadcast:
                isMuteAudioRecording = false
                isMuteAudioPlaying = false
                settingButton.isHidden = false
                micButton.isEnabled = true
                agoraMediaKit.setClientRole(.broadcaster)
            case .audience:
                if micButton.isSelected == true {
                    micButton.isSelected = false
                }
                
                settingButton.isHidden = true
                micButton.isEnabled = false
                agoraMediaKit.setClientRole(.audience)
            }
        }
    }
    
    private var isMuteAudioRecording: Bool = false {
        didSet {
            micButton.isSelected = isMuteAudioRecording
            agoraMediaKit.muteLocalAudioStream(isMuteAudioRecording)
            
            guard let index = seatVC?.indexOfSeat(with: current.info.id),
                let seat = seatVC?.seat(with: index),
                var broadcaster = seat.broadcaster else {
                    return
            }
            broadcaster.audioRecording = !isMuteAudioRecording
            let new = Seat(type: .takeup(broadcaster))
            seatVC?.updateSeat(new, index: index)
        }
    }
    
    private var isMuteAudioPlaying: Bool = false {
        didSet {
            playbackButton.isSelected = isMuteAudioPlaying
            agoraMediaKit.muteAllRemoteAudioStreams(isMuteAudioPlaying)
        }
    }
    
    private var isSettingViewShow: Bool! {
        didSet {
            if isSettingViewShow == true {
                settingVC.isShow(isShow: true)
            } else {
                settingVC.isShow(isShow: false)
            }
        }
    }
    
    private var isDeviceAdapt: Bool = false {
        didSet {
            guard isDeviceAdapt == true else {
                return
            }
            
            if DeviceAdapt.currentType() == .classicFivePointFiveInch {
                seatViewWidth.constant = seatViewWidth.constant * DeviceAdapt.getWidthCoefficient()
                seatViewBottom.constant = seatViewBottom.constant * DeviceAdapt.getWidthCoefficient()
            }
        }
    }
    
    lazy var playerList = [Player]()
    
    weak var momentsVC: MomentsViewController?
    weak var seatVC: BroadcasterSeatViewController?
    
    var current: RoomCurrent!
    var info: RoomInfo!
    var voiceRoleIndex: Int?
    var agoraMediaKit: AgoraRtcEngineKit!
    
    lazy var settingVC: SettingViewController = {() -> SettingViewController in
        let story = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let setVC = story.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        setVC.delegate = self
        return setVC
    }()
    
    lazy var settingBackgroundView: UIView = {() -> UIView in
        var subFrame = CGRect(x: 0, y: 0, width: 91 * DeviceAdapt.getWidthCoefficient(), height: self.view.bounds.height)
        let subView = UIView(frame: subFrame)
        subView.backgroundColor = UIColor.clear
        
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.init(hexString: "#000000-0.6")
        view.addSubview(subView)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(endSettingView))
        subView.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var aureolaView: AureolaView = {() -> AureolaView in
        let view = AureolaView.createAureolaView(layerColor: UIColor.init(hexString: "#09BDF4"))
        return view
    }()
    
    lazy var aureolaViews: [AureolaView] = {() -> [AureolaView] in
        var list = [AureolaView]()
        for _ in 0..<8 {
            let view = AureolaView.createAureolaView(layerColor: UIColor.init(hexString: "#09BDF4"))
            list.append(view)
        }
        
        return list
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if !isDeviceAdapt {
            isDeviceAdapt = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAgoraMediaKit()
        updateRoomInfo()
        updateViews()
        addKeyboardObserver()
        mediaJoinChannel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier, !segueId.isEmpty else {
            return
        }
        
        switch segueId {
        case "BroadcasterSeatViewController":
            let vc = segue.destination as! BroadcasterSeatViewController
            vc.delegate = self
            seatVC = vc
        case "MomentsViewController":
            let vc = segue.destination as! MomentsViewController
            momentsVC = vc
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
// MARK: -
// MARK: Response Action
// MARK:
    @IBAction func doCloseRoomPressed(_ sender: UIButton) {
        leaveRoom()
    }
    
    @IBAction func doMuteLocalPressed(_ sender: UIButton) {
        isMuteAudioRecording.toggle()
    }
    
    @IBAction func doMuteAllRemotePressed(_ sender: UIButton) {
        isMuteAudioPlaying.toggle()
    }
    
    @IBAction func doSettingPressed(_ sender: UIButton) {
        isSettingViewShow = true
    }
}

// MARK: -
// MARK: Init
// MARK:
private extension RoomViewController {
    func loadAgoraMediaKit() {
        agoraMediaKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.appId, delegate: self)
        agoraMediaKit.setChannelProfile(.liveBroadcasting)
        agoraMediaKit.enableAudioVolumeIndication(1000, smooth: 3)
        agoraMediaKit.setAudioProfile(.default, scenario: .gameStreaming)
        debugLog(log: "getSdkVersion: \(AgoraRtcEngineKit.getSdkVersion())")
    }
    
    func mediaJoinChannel() {
        agoraMediaKit.joinChannel(byToken: KeyCenter.token,
                                  channelId: info.roomId,
                                  info: nil,
                                  uid: current.info.streamId) { [unowned self] (_, _, _) in
            self.momentsVC?.append(content: "join room", from: self.current.info)
        }
    }
    
    func updateRoomInfo() {
        currentNameLabel.text = "用户 \(current.info.streamId)"
        currenHeadImageView.image = ImageGroup.shared().head(of: current.info.head)
        titleLabel.text = info.name
    }
    
    func updateViews() {
        inputMessageTextField.delegate = self
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] (notify) in
            guard let userInfo = notify.userInfo,
                let strongSelf = self,
                let endKeyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
                let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
                    return
            }
            
            let endKeyboardFrame = endKeyboardFrameValue.cgRectValue
            let duration = durationValue.doubleValue
            let screenHeight = UIScreen.main.bounds.height
            var endInputMessageViewBottomConstant: CGFloat!
            
            endInputMessageViewBottomConstant = CGFloat(screenHeight - (endKeyboardFrame.minY))
            
            var isShowing: Bool
            if (endKeyboardFrame.maxY) > screenHeight {
                isShowing = false
                endInputMessageViewBottomConstant = endInputMessageViewBottomConstant - CGFloat((strongSelf.inputMessageView.bounds.height))
            } else {
                isShowing = true
                strongSelf.inputMessageView.isHidden = false
                strongSelf.inputMessageTextField.becomeFirstResponder()
                if (DeviceAdapt.currentType() == .newFourPointSevenInch || DeviceAdapt.currentType() == .newFivePointFiveInch) {
                    endInputMessageViewBottomConstant = endInputMessageViewBottomConstant - 34
                }
            }
            
            UIView.animate(withDuration: duration, animations: {
                strongSelf.inputMessageViewBottom.constant = endInputMessageViewBottomConstant
                strongSelf.view.layoutIfNeeded()
            }, completion: {(isSuccess) in
                if isShowing == false {
                    strongSelf.inputMessageView.isHidden = true
                }
            });
        }
    }
    
    func leaveRoom() {
        agoraMediaKit.leaveChannel(nil)
        allAureolaRemoveAnimation()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: -
// MARK: UI
// MARK:
extension RoomViewController {
    func setPopoverDelegate(of vc: UIViewController) {
        vc.popoverPresentationController?.delegate = self
    }
    
    func presentAlerlControllerAsNotification(title: String, message: String?) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alertController.addAction(sureAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func settingBackGroundViewShow(isShow: Bool) {
        if isShow {
            view.addSubview(settingBackgroundView)
        } else {
            settingBackgroundView.removeFromSuperview()
        }
    }
    
    @objc func endSettingView() {
        isSettingViewShow = false
    }
    
    func pushSubFunctionsInSettingView(vcId: String) {
        let story = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        var vc: UIViewController?
        
        switch vcId {
        case "VoiceChangerViewController":
            vc = story.instantiateViewController(withIdentifier: "VoiceChangerViewController")
            let voiceVC = vc as! VoiceChangerViewController
            if let voiceRoleIndex = voiceRoleIndex {
                voiceVC.selectedIndex = voiceRoleIndex
            }
            voiceVC.delegate = self
        default:
            break
        }
        
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)            
        }
    }
    
    func allAureolaRemoveAnimation() {
        aureolaView.removeAnimation()
        for item in aureolaViews {
            item.removeAnimation()
        }
    }
}

extension RoomViewController: SettingVCDelegate {
    func settingVCWillShowOnSettingBackgroundView(_ vc: SettingViewController) -> UIView {
        settingBackGroundViewShow(isShow: true)
        return settingBackgroundView
    }
    
    func settingVCDidEndShow(_ vc: SettingViewController) {
        settingBackGroundViewShow(isShow: false)
    }
    
    func settingVCDidSelectedVoiceChanger(_ vc: SettingViewController) {
        pushSubFunctionsInSettingView(vcId: "VoiceChangerViewController")
    }
    
    func settingVCDidSelectedExitRoom(_ vc: SettingViewController) {
        leaveRoom()
    }
}

// MARK: -
// MARK: AgoraRtcEngineDelegate
// MARK:
extension RoomViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        let result = StreamIdParse.parse(with: uid)
        
        switch result {
        case .user(let user):
            guard current.info.streamId != user.streamId,
                let index = seatVC?.firstIndexOfBlankSeat() else {
                    return
            }
            
            var hasPlayer: Bool
            if let _ = playerList.first(of: user.id) {
                hasPlayer = true
            } else {
                hasPlayer = false
            }
            
            let broadcaster = Seat.Broadcaster(info: user,
                                               hasPlayer: hasPlayer,
                                               audioRecording: true)
            let seat = Seat(type: .takeup(broadcaster))
            seatVC?.updateSeat(seat, index: index)
        case .player(let player):
            playerList.append(player)
            
            guard let index = seatVC?.indexOfSeat(with: player.id),
                let seat = seatVC?.seat(with: index),
                var broadcaster = seat.broadcaster else {
                    return
            }
            
            broadcaster.hasPlayer = true
            let new = Seat(type: .takeup(broadcaster))
            seatVC?.updateSeat(new, index: index)
            
            if player.id == current.info.id {
                agoraMediaKit.muteRemoteAudioStream(uid, mute: true)
            }
        }
    }
    
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
        debugLog(log: "rtcEngineConnectionDidInterrupted")
    }
    
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        debugLog(log: "rtcEngineConnectionDidLost")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        debugLog(log: "didOccurError errorCode: \(errorCode)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        
        if speakers.count == 1, speakers[0].uid == 0 {
            aureolaView.startLayerAnimation(aboveView: currenHeadImageView, layerWidth: 2)
        } else {
            
        }
        
//        if speakers.count == 1, speakers[0].uid == 0 {
//            if role == .owner {
//                aureolaView.startLayerAnimation(aboveView: currenHeadImageView, layerWidth: 2)
//            } else if let micSeatVC = micSeatVC, let button = micSeatVC.getActiveSpeaker(account: userListManager.currentUser.uid) {
//                let view = aureolaViews[button.tag]
//                view.startLayerAnimation(aboveView: button, layerWidth: 2)
//            }
//        } else {
//            for speaker in speakers {
//                if let roomOwner = roomOwner, roomOwner == speaker.uid {
//                    aureolaView.startLayerAnimation(aboveView: currenHeadImageView, layerWidth: 2)
//                } else if let micSeatVC = micSeatVC, let button = micSeatVC.getActiveSpeaker(account: speaker.uid) {
//                    let view = aureolaViews[button.tag]
//                    view.startLayerAnimation(aboveView: button, layerWidth: 2)
//                }
//            }
//        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        let result = StreamIdParse.parse(with: uid)
        
        switch result {
        case .user(let user):
            guard let index = seatVC?.indexOfSeat(with: user.id),
                let seat = seatVC?.seat(with: index),
                var broadcaster = seat.broadcaster else {
                    return
            }
            broadcaster.audioRecording = false
            let new = Seat(type: .takeup(broadcaster))
            seatVC?.updateSeat(new, index: index)
        case .player:
            break
        }
    }
}

// MARK: -
// MARK: VoiceChangerVCDelegate
// MARK:
extension RoomViewController: VoiceChangerVCDelegate {
    func voiceChangerVC(_ vc: VoiceChangerViewController, didSelected role: EffectRoles, roleIndex: Int) {
        voiceRoleIndex = roleIndex
        role.character(with: agoraMediaKit)
        settingBackGroundViewShow(isShow: false)
        vc.navigationController?.popViewController(animated: true)
    }
    
    func voiceChanngerVCDidCancel(_ vc: VoiceChangerViewController) {
        if let _ = voiceRoleIndex {
            EffectRoles.Default.character(with: agoraMediaKit)
            self.voiceRoleIndex = nil
        }
        
        vc.navigationController?.popViewController(animated: true)
    }
}

extension RoomViewController: BroadcasterSeatVCDelegate {
    func broadcasterSeatVC(_ vc: BroadcasterSeatViewController, didSelected index: Int, seat: Seat) {
        switch seat.type {
        case .none:
            guard role == .audience else {
                return
            }
            
            var hasPlayer: Bool
            if let _ = playerList.first(of: current.info.id) {
                hasPlayer = true
            } else {
                hasPlayer = false
            }
            let broadcaster = Seat.Broadcaster(info: current.info, hasPlayer: hasPlayer, audioRecording: true)
            let seat = Seat(type: .takeup(broadcaster))
            vc.updateSeat(seat, index: index)
            role = .broadcast
        case .takeup(let broadcaster):
            guard broadcaster.info.streamId == current.info.streamId else {
                return
            }
            let seat = Seat(type: .none)
            vc.updateSeat(seat, index: index)
            role = .audience
        }
    }
}

extension RoomViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension RoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let content = textField.text {
            momentsVC?.append(content: content, from: current.info)
        }
        
        textField.text = ""
        self.view.endEditing(true)
        return true
    }
}

private extension RoomViewController {
    func debugLog(log: String) {
        #if DEBUG
        print("<Room> \(log)")
        #endif
    }
}
