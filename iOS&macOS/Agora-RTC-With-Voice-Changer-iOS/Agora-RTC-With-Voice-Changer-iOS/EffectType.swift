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
        case .OldMan:           return .oldMan
        case .BabyBoy:          return .babyBoy
        case .BabyGirl:         return .babyGirl
        case .ZhuBaJie:         return .zhuBaJie
        case .Ethereal:         return .ethereal
        case .Hulk:             return .hulk
        
        case .KTV:              return .off
        case .VocalConcert:     return .off
        case .RecordingRoom:    return .off
        case .Rock:             return .off
        case .Pop:              return .off
        case .RB:               return .off
        case .Phonograph:       return .off
        case .Default:          return .off
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


//import AgoraRtcKit
//
//protocol CSDescriptable {
//    func description() -> String
//}
//
//protocol CSValueRange {
//    func valueRange() -> CSRange
//}
//
//protocol CSRoleCharacter {
//    func character() -> [String : Double]
//}
//
//protocol CSGetType {
//    static func getEnumType(description: String) -> CSEnumType?
//}
//
//struct CSEnumType {
//    var enumType: AnyObject
//    var subType:  AnyObject
//}
//
//struct CSRange {
//    var minValue : Int!
//    var maxValue : Int!
//}
//
//enum EffectRoles {
//    case OldMan
//    case BabyBoy
//    case ZhuBaJie
//    case Ethereal
//    case Hulk
//    case BabyGirl
//    case Default
//}
//
//let equalizationBandFrequencysArray: [AgoraAudioEqualizationBandFrequency] = [.band31,
//                                                                               .band62,
//                                                                               .band125,
//                                                                               .band250,
//                                                                               .band500,
//                                                                               .band1K,
//                                                                               .band2K,
//                                                                               .band4K,
//                                                                               .band8K,
//                                                                               .band16K]
//
//let reverbsArray: [AgoraAudioReverbType] = [.dryLevel,
//                                             .wetLevel,
//                                             .roomSize,
//                                             .wetDelay,
//                                             .strength]
//
//let rolesArray: [EffectRoles] = [.OldMan,
//                                  .BabyBoy,
//                                  .ZhuBaJie,
//                                  .Ethereal,
//                                  .Hulk,
//                                  .BabyGirl,
//                                  .Default]
//
//class EffectType: NSObject {
//    static func equalizationBandFrequencysList() -> [AgoraAudioEqualizationBandFrequency] {
//        return equalizationBandFrequencysArray
//    }
//
//    static func reverbsList() -> [AgoraAudioReverbType] {
//        return reverbsArray
//    }
//
//    static func rolesList() -> [EffectRoles] {
//        return rolesArray
//    }
//
//}
//
//extension AgoraAudioEqualizationBandFrequency: CSDescriptable, CSValueRange {
//    func description() -> String {
//        switch self {
//        case .band31:  return "Band31"
//        case .band62:  return "Band62"
//        case .band125: return "Band125"
//        case .band250: return "Band250"
//        case .band500: return "Band500"
//        case .band1K:  return "Band1k"
//        case .band2K:  return "Band2k"
//        case .band4K:  return "Band4k"
//        case .band8K:  return "Band8k"
//        case .band16K: return "Band16k"
//        }
//    }
//
//    func valueRange() -> CSRange {
//        return CSRange(minValue: -15, maxValue: 15)
//    }
//}
//
//extension AgoraAudioReverbType: CSDescriptable, CSValueRange {
//    func description() -> String {
//        switch self {
//        case .dryLevel: return "DryLevel"
//        case .wetLevel: return "WetLevel"
//        case .roomSize: return "RoomSize"
//        case .wetDelay: return "WetDelay"
//        case .strength: return "Strength"
//        }
//    }
//
//    func valueRange() -> CSRange {
//        switch self {
//        case .dryLevel: return CSRange(minValue: -20, maxValue: 10)
//        case .wetLevel: return CSRange(minValue: -20, maxValue: 10)
//        case .roomSize: return CSRange(minValue: 0, maxValue: 100)
//        case .wetDelay: return CSRange(minValue: 0, maxValue: 200)
//        case .strength: return CSRange(minValue: 0, maxValue: 100)
//        }
//    }
//}
//
//extension EffectRoles:CSDescriptable {
//    func description() -> String {
//        switch self {
//        case .OldMan:   return "OldMan"
//        case .BabyBoy:  return "BabyBoy"
//        case .ZhuBaJie: return "ZhuBaJie"
//        case .Ethereal: return "Ethereal"
//        case .Hulk:     return "Hulk"
//        case .BabyGirl: return "BabyGirl"
//        case .Default:  return "Default"
//        }
//    }
//
//    func character() -> [String : Double] {
//        var chaDic = [String : Double]()
//
//        switch self {
//        case .OldMan:   do {
//            chaDic["Pitch"] = 0.8
//
//            chaDic["Band31"] = -15
//            chaDic["Band62"] = 0
//            chaDic["Band125"] = 6
//            chaDic["Band250"] = 1
//            chaDic["Band500"] = -4
//            chaDic["Band1k"] = 1
//            chaDic["Band2k"] = -10
//            chaDic["Band4k"] = -5
//            chaDic["Band8k"] = 3
//            chaDic["Band16k"] = 3
//
//            chaDic["DryLevel"] = -12
//            chaDic["WetLevel"] = -12
//            chaDic["RoomSize"] = 0
//            chaDic["WetDelay"] = 90
//            chaDic["Strength"] = 43
//            }
//        case .BabyBoy:  do {
//            chaDic["Pitch"] = 1.23
//
//            chaDic["Band31"] = 15
//            chaDic["Band62"] = 11
//            chaDic["Band125"] = -3
//            chaDic["Band250"] = -5
//            chaDic["Band500"] = -7
//            chaDic["Band1k"] = -7
//            chaDic["Band2k"] = -9
//            chaDic["Band4k"] = -15
//            chaDic["Band8k"] = -15
//            chaDic["Band16k"] = -15
//
//            chaDic["DryLevel"] = 4
//            chaDic["WetLevel"] = 2
//            chaDic["RoomSize"] = 0
//            chaDic["WetDelay"] = 91
//            chaDic["Strength"] = 44
//            }
//        case .ZhuBaJie: do {
//            chaDic["Pitch"] = 0.6
//
//            chaDic["Band31"] = 12
//            chaDic["Band62"] = -9
//            chaDic["Band125"] = -9
//            chaDic["Band250"] = 3
//            chaDic["Band500"] = -3
//            chaDic["Band1k"] = 11
//            chaDic["Band2k"] = 1
//            chaDic["Band4k"] = -8
//            chaDic["Band8k"] = -8
//            chaDic["Band16k"] = -9
//
//            chaDic["DryLevel"] = -14
//            chaDic["WetLevel"] = -8
//            chaDic["RoomSize"] = 34
//            chaDic["WetDelay"] = 0
//            chaDic["Strength"] = 39
//            }
//        case .Ethereal: do {
//            chaDic["Pitch"] = 1
//
//            chaDic["Band31"] = -8
//            chaDic["Band62"] = -8
//            chaDic["Band125"] = 5
//            chaDic["Band250"] = 13
//            chaDic["Band500"] = 2
//            chaDic["Band1k"] = 12
//            chaDic["Band2k"] = -3
//            chaDic["Band4k"] = 7
//            chaDic["Band8k"] = -2
//            chaDic["Band16k"] = -10
//
//            chaDic["DryLevel"] = -17
//            chaDic["WetLevel"] = -13
//            chaDic["RoomSize"] = 72
//            chaDic["WetDelay"] = 9
//            chaDic["Strength"] = 69
//            }
//        case .Hulk:     do {
//            chaDic["Pitch"] = 0.5
//
//            chaDic["Band31"] = -15
//            chaDic["Band62"] = 3
//            chaDic["Band125"] = -9
//            chaDic["Band250"] = -8
//            chaDic["Band500"] = -6
//            chaDic["Band1k"] = -4
//            chaDic["Band2k"] = -3
//            chaDic["Band4k"] = -2
//            chaDic["Band8k"] = -1
//            chaDic["Band16k"] = 1
//
//            chaDic["DryLevel"] = 10
//            chaDic["WetLevel"] = -9
//            chaDic["RoomSize"] = 76
//            chaDic["WetDelay"] = 124
//            chaDic["Strength"] = 78
//            }
//        case .BabyGirl: do {
//            chaDic["Pitch"] = 1.45
//
//            chaDic["Band31"] = 10
//            chaDic["Band62"] = 6
//            chaDic["Band125"] = 1
//            chaDic["Band250"] = 1
//            chaDic["Band500"] = -6
//            chaDic["Band1k"] = 13
//            chaDic["Band2k"] = 7
//            chaDic["Band4k"] = -14
//            chaDic["Band8k"] = 13
//            chaDic["Band16k"] = -13
//
//            chaDic["DryLevel"] = -11
//            chaDic["WetLevel"] = -7
//            chaDic["RoomSize"] = 0
//            chaDic["WetDelay"] = 31
//            chaDic["Strength"] = 44
//            }
//        case .Default: do {
//            chaDic["Pitch"] = 1
//
//            chaDic["Band31"] = 0
//            chaDic["Band62"] = 0
//            chaDic["Band125"] = 0
//            chaDic["Band250"] = 0
//            chaDic["Band500"] = 0
//            chaDic["Band1k"] = 0
//            chaDic["Band2k"] = 0
//            chaDic["Band4k"] = 0
//            chaDic["Band8k"] = 0
//            chaDic["Band16k"] = 0
//
//            chaDic["DryLevel"] = 0
//            chaDic["WetLevel"] = 0
//            chaDic["RoomSize"] = 0
//            chaDic["WetDelay"] = 0
//            chaDic["Strength"] = 0
//            }
//        }
//        return chaDic
//    }
//
//}
