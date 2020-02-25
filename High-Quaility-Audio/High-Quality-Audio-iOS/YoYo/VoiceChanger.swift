//
//  VoiceChanger.swift
//  YoYo
//
//  Created by CavanSu on 14/03/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

protocol CSDescriptable {
    func description() -> String
}

struct VoiceChanger {
    enum VType: CSDescriptable {
        case scene, gendered, adj, stereo
        
        func description() -> String {
            switch self {
            case .scene:    return "音效"
            case .gendered: return "美声"
            case .adj:      return "美音"
            case .stereo:   return "虚拟立体声"
            }
        }
    }
    
    typealias Scene = AgoraAudioReverbPreset
    typealias Improve = AgoraAudioVoiceChanger
    
    static func sceneList() -> [Scene] {
        return [.fxKTV,
                .fxVocalConcert,
                .fxUncle,
                .fxSister,
                .fxStudio,
                .fxPopular,
                .fxRNB,
                .fxPhonograph]
    }
    
    static func stereoList() -> [Scene] {
        return [.virtualStereo]
    }
    
    static func genderedList() -> [Improve] {
        return [.generalBeautyVoiceMaleMagnetic,
                .generalBeautyVoiceFemaleFresh,
                .generalBeautyVoiceFemaleVitality]
    }
    
    static func adjList() -> [Improve] {
        return [.voiceChangerOff,
                .voiceBeautyVigorous,
                .voiceBeautyDeep,
                .voiceBeautyMellow,
                .voiceBeautyFalsetto,
                .voiceBeautyFull,
                .voiceBeautyClear,
                .voiceBeautyResounding,
                .voiceBeautyRinging,
                .voiceBeautySpacial]
    }
    
    static func scene(_ scene: Scene, with agoraKit: AgoraRtcEngineKit) {
        guard VoiceChanger.sceneList().contains(scene) || scene == .off else {
            fatalError()
        }
        print("VoiceChanger: \(scene.description())")
        agoraKit.setLocalVoiceReverbPreset(scene)
    }
    
    static func stereo(_ stereo: Scene, with agoraKit: AgoraRtcEngineKit) {
        guard VoiceChanger.stereoList().contains(stereo) || stereo == .off else {
            fatalError()
        }
        print("VoiceChanger: \(stereo.description())")
        agoraKit.setLocalVoiceReverbPreset(stereo)
    }
    
    static func gendered(_ gendered: Improve, with agoraKit: AgoraRtcEngineKit) {
        guard VoiceChanger.genderedList().contains(gendered) || gendered == .voiceChangerOff else {
            fatalError()
        }
        print("VoiceChanger: \(gendered.description())")
        agoraKit.setLocalVoiceChanger(gendered)
    }
    
    static func adj(_ adj: Improve, with agoraKit: AgoraRtcEngineKit) {
        guard VoiceChanger.adjList().contains(adj) || adj == .voiceChangerOff else {
            fatalError()
        }
        print("VoiceChanger: \(adj.description())")
        agoraKit.setLocalVoiceChanger(adj)
    }
}

extension VoiceChanger.Scene: CSDescriptable {
    func description() -> String {
        switch self {
        case .off:                return "原声"
        case .fxKTV:              return "KTV"
        case .fxVocalConcert:     return "演唱会"
        case .fxUncle:            return "大叔"
        case .fxSister:           return "小姐姐"
        case .fxStudio:           return "录音棚"
        case .fxPopular:          return "流行"
        case .fxRNB:              return "R&B"
        case .fxPhonograph:       return "留声机"
        case .virtualStereo:      return "虚拟立体声"
        default:                  fatalError()
        }
    }
}

extension VoiceChanger.Improve: CSDescriptable {
    func description() -> String {
        switch self {
        case .voiceChangerOff:         return "原声"
        case .voiceBeautyVigorous:     return "浑厚"
        case .voiceBeautyDeep:         return "低沉"
        case .voiceBeautyMellow:       return "圆润"
        case .voiceBeautyFalsetto:     return "假音"
        case .voiceBeautyFull:         return "饱满"
        case .voiceBeautyClear:        return "清澈"
        case .voiceBeautyResounding:   return "高亢"
        case .voiceBeautyRinging:      return "嘹亮"
        case .voiceBeautySpacial:      return "空旷"
            
        case .generalBeautyVoiceMaleMagnetic:   return "磁性（男）"
        case .generalBeautyVoiceFemaleFresh:    return "清新（女）"
        case .generalBeautyVoiceFemaleVitality: return "活力（女）"
        default: fatalError()
        }
    }
}
