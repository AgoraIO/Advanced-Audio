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

protocol CSValueRange {
    func valueRange() -> CSRange
}

struct CSRange {
    var minValue : Int!
    var maxValue : Int!
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
    
    static func rolesList() -> [EffectRoles] {
        return [.OldMan,
                .BabyBoy,
                .ZhuBaJie,
                .Ethereal,
                .Hulk,
                .BabyGirl,
                .KTV,
                .RecordingRoom,
                .VocalConcert,
                .Fashion,
                .HipHop,
                .Rock,
                .RB,
                .Ethereal2,
                .Default]
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
    case ZhuBaJie
    case Ethereal
    case Hulk
    case BabyGirl
    case KTV
    case RecordingRoom
    case VocalConcert
    case Fashion
    case HipHop
    case Rock
    case RB
    case Ethereal2
    case Default
}

extension EffectRoles: CSDescriptable {
    func description() -> String {
        switch self {
        case .OldMan:           return "大叔"
        case .BabyBoy:          return "正太"
        case .ZhuBaJie:         return "猪八戒"
        case .Ethereal:         return "空灵"
        case .Hulk:             return "浩克"
        case .BabyGirl:         return "萝莉"
        case .KTV:              return "KTV"
        case .RecordingRoom:    return "录音棚"
        case .VocalConcert:     return "演唱会"
        case .Fashion:          return "流行"
        case .HipHop:           return "嘻哈"
        case .Rock:             return "摇滚"
        case .RB:               return "R&B"
        case .Ethereal2:        return "空灵2"
        case .Default:          return "Default"
        }
    }
    
    func character(with agoraKit: AgoraRtcEngineKit) {
        switch self {
        case .OldMan:
            agoraKit.setLocalVoiceChanger(.oldMan)
        case .BabyBoy:
            agoraKit.setLocalVoiceChanger(.babyBoy)
        case .ZhuBaJie:
            agoraKit.setLocalVoiceChanger(.zhuBaJie)
        case .Ethereal:
            agoraKit.setLocalVoiceChanger(.ethereal)
        case .Hulk:
            agoraKit.setLocalVoiceChanger(.hulk)
        case .BabyGirl:
            agoraKit.setLocalVoiceChanger(.babyGirl)
        case .KTV:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 10)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 30)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 100)
        case .RecordingRoom:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 10)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 10)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 50)
        case .VocalConcert:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 10)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 50)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 45)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 100)
        case .Fashion:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 1)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 1)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 5)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 20)
        case .HipHop:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -4)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 5)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 66)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 100)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 0)
        case .Rock:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -7)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -7)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 95)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 170)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 58)
        case .RB:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -12)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -1)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 20)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 59)
        case .Ethereal2:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -1)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 3)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 100)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 26)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 82)
        case .Default:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 0)
        }
    }
}
