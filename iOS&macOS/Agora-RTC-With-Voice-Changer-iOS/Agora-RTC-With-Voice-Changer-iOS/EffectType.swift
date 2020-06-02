//
//  EffectType.swift
//  Agora-RTC-With-Voice-Changer-iOS
//
//  Created by CavanSu on 14/03/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import AgoraRtcKit

protocol CSDescriptable {
    func description() -> String
}

protocol CSValueRange {
    func valueRange() -> CSRange
}

struct CSRange {
    var minValue : Int
    var maxValue : Int
}

struct EffectType {
    static func equalizationBandFrequencysList() -> [AgoraAudioEqualizationBandFrequency] {
        return  [.band31,
                 .band62,
                 .band125,
                 .band250,
                 .band500,
                 .band1K,
                 .band2K,
                 .band4K,
                 .band8K,
                 .band16K]
    }

    static func reverbsList() -> [AgoraAudioReverbType] {
        return [.dryLevel,
                .wetLevel,
                .roomSize,
                .wetDelay,
                .strength]
    }
}

extension AgoraAudioEqualizationBandFrequency: CSDescriptable, CSValueRange {
    func description() -> String {
        switch self {
        case .band31:     return "Band31"
        case .band62:     return "Band62"
        case .band125:    return "Band125"
        case .band250:    return "Band250"
        case .band500:    return "Band500"
        case .band1K:     return "Band1k"
        case .band2K:     return "Band2k"
        case .band4K:     return "Band4k"
        case .band8K:     return "Band8k"
        case .band16K:    return "Band16k"
        @unknown default: return "unknown"
        }
    }
    
    func valueRange() -> CSRange {
        return CSRange(minValue: -15, maxValue: 15)
    }
}

extension AgoraAudioReverbType: CSDescriptable, CSValueRange {
    func description() -> String {
        switch self {
        case .dryLevel:   return "DryLevel"
        case .wetLevel:   return "WetLevel"
        case .roomSize:   return "RoomSize"
        case .wetDelay:   return "WetDelay"
        case .strength:   return "Strength"
        @unknown default: return "unknown"
        }
    }
    
    func valueRange() -> CSRange {
        switch self {
        case .dryLevel:   return CSRange(minValue: -20, maxValue: 10)
        case .wetLevel:   return CSRange(minValue: -20, maxValue: 10)
        case .roomSize:   return CSRange(minValue: 0, maxValue: 100)
        case .wetDelay:   return CSRange(minValue: 0, maxValue: 200)
        case .strength:   return CSRange(minValue: 0, maxValue: 100)
        @unknown default: return CSRange(minValue: 0, maxValue: 0)
        }
    }
}

enum EffectRoles {
    case OldMan
    case BabyBoy
    case BabyGirl
    case ZhuBaJie
    case Ethereal
    case Hulk

    case KTV
    case RecordingRoom
    case VocalConcert
    case Pop
    case Rock
    case RB
    case Phonograph
    case Default
    
    var agValue: AgoraAudioVoiceChanger {
        switch self {
        case .OldMan:           return .voiceChangerOldMan
        case .BabyBoy:          return .voiceChangerBabyBoy
        case .BabyGirl:         return .voiceChangerBabyGirl
        case .ZhuBaJie:         return .voiceChangerZhuBaJie
        case .Ethereal:         return .voiceChangerEthereal
        case .Hulk:             return .voiceChangerHulk
        
        case .KTV:              return .voiceChangerOff
        case .VocalConcert:     return .voiceChangerOff
        case .RecordingRoom:    return .voiceChangerOff
        case .Rock:             return .voiceChangerOff
        case .Pop:              return .voiceChangerOff
        case .RB:               return .voiceChangerOff
        case .Phonograph:       return .voiceChangerOff
        case .Default:          return .voiceChangerOff
        }
    }
    
    static var list: [EffectRoles] {
        return [.OldMan,
                .BabyBoy,
                .BabyGirl,
                .ZhuBaJie,
                .Ethereal,
                .Hulk]
    }
}

extension EffectRoles: CSDescriptable {
    func description() -> String {
        switch self {
        case .OldMan:           return "大叔"
        case .BabyBoy:          return "小哥哥"
        case .BabyGirl:         return "小姐姐"
        case .ZhuBaJie:         return "猪八戒"
        case .Ethereal:         return "空灵"
        case .Hulk:             return "浩克"
        
        case .KTV:              return "KTV"
        case .VocalConcert:     return "演唱会"
        case .RecordingRoom:    return "录音棚"
        case .Rock:             return "摇滚"
        case .Pop:              return "流行"
        case .RB:               return "R&B"
        case .Phonograph:       return "留声机"
        case .Default:          return "Default"
        }
    }
}
