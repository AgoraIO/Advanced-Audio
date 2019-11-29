//
//  EffectType.swift
//   Agora-RTC-With-Voice-Changer-iOS
//
//  Created by CavanSu on 14/03/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

protocol CSDescriptable {
    func description() -> String
}

class EffectType {
    static func rolesList() -> [EffectRoles] {
        return [.Default,
                .KTV,
                .VocalConcert,
                .OldMan,
                .BabyGirl,
                .RecordingRoom,
                .Fashion,
                .RB,
                .Phonograph]
    }
    static func beautyVoiceList() -> [BeautyVoiceType] {
        return [.Default,
                .DeepVoice,
                .LowVoice,
                .MellowVoice,
                .FakeVoice,
                .FullVoice,
                .ClearVoice,
                .HighVoice,
                .LoudVoice,
                .EmptyVoice]
    }
}

enum EffectRoles: Int, CaseIterable {
    case Default
    case KTV
    case VocalConcert
    case OldMan
    case BabyGirl
    case RecordingRoom
    case Fashion = 7
    case RB
    case Phonograph
}

enum BeautyVoiceType: Int, CaseIterable {
    case Default = 0
    case DeepVoice = 7
    case LowVoice
    case MellowVoice
    case FakeVoice
    case FullVoice
    case ClearVoice
    case HighVoice
    case LoudVoice
    case EmptyVoice
}

extension BeautyVoiceType: CSDescriptable {
    func description() -> String {
        switch self {
        case .Default:         return "原声"
        case .DeepVoice:       return "浑厚"
        case .LowVoice:        return "低沉"
        case .MellowVoice:     return "圆润"
        case .FakeVoice:       return "假音"
        case .FullVoice:       return "饱满"
        case .ClearVoice:      return "清澈"
        case .HighVoice:       return "高亢"
        case .LoudVoice:       return "嘹亮"
        case .EmptyVoice:      return "空旷"
        }
    }
    
    static func fmDefault(with agoraKit: AgoraRtcEngineKit) {
        beautifulVoice(with: agoraKit, type: BeautyVoiceType.Default.rawValue)
    }

    static func beautifulVoice(with agoraKit: AgoraRtcEngineKit, type:Int) {
        agoraKit.setParameters("{\"che.audio.morph.voice_changer\": \(type)}")
    }

    func character(with agoraKit: AgoraRtcEngineKit) {
        BeautyVoiceType.beautifulVoice(with: agoraKit, type: self.rawValue)
    }
}

extension EffectRoles: CSDescriptable {
    func description() -> String {
        switch self {
        case .Default:          return "原声"
        case .KTV:              return "KTV"
        case .VocalConcert:     return "演唱会"
        case .OldMan:           return "大叔"
        case .BabyGirl:         return "小姐姐"
        case .RecordingRoom:    return "录音棚"
        case .Fashion:          return "流行"
        case .RB:               return "R&B"
        case .Phonograph:       return "留声机"
        }
    }
    
    static func fmDefault(with agoraKit: AgoraRtcEngineKit) {
        changeVoice(with: agoraKit, type: EffectRoles.Default.rawValue)
    }

    static func changeVoice(with agoraKit: AgoraRtcEngineKit, type:Int) {
        agoraKit.setParameters("{\"che.audio.morph.reverb_preset\": \(type)}")
    }

    func character(with agoraKit: AgoraRtcEngineKit) {
        EffectRoles.changeVoice(with: agoraKit, type: self.rawValue)
    }
}
