//
//  EffectViewController.swift
//   Agora-RTC-With-Voice-Changer-iOS
//
//  Created by CavanSu on 14/03/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class EffectViewController: UITableViewController {

    var agoraKit: AgoraRtcEngineKit!
    lazy var currentValueDic :[String: Double] =  {
        var dic = [String: Double]()
        // Pitch default value = 1
        dic["Pitch"] = 1
        for item in EffectType.equalizationBandFrequencysList() {
            dic[item.description()] = 0
        }
        for item in EffectType.reverbsList() {
            dic[item.description()] = 0
        }
        return dic
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 300, height: 400)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return EffectType.rolesList().count
        case 1: return 1
        case 2: return EffectType.equalizationBandFrequencysList().count
        case 3: return EffectType.reverbsList().count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "role_reuse")
            let role = EffectType.rolesList()[indexPath.row]
            cell?.textLabel?.text = role.description()
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "effect_reuse") as! EffectCell
            switch indexPath.section {
            case 1:
                cell.title = "Pitch"
                cell.valueSlider.minimumValue = 0.5
                cell.valueSlider.maximumValue = 2.0
                break
            case 2:
                let bandFrequency = EffectType.equalizationBandFrequencysList()[indexPath.row]
                cell.title = bandFrequency.description()
                cell.valueSlider.minimumValue = Float(bandFrequency.valueRange().minValue)
                cell.valueSlider.maximumValue = Float(bandFrequency.valueRange().maxValue)
                break
            case 3:
                let reverb = EffectType.reverbsList()[indexPath.row]
                cell.title = reverb.description()
                cell.valueSlider.minimumValue = Float(reverb.valueRange().minValue)
                cell.valueSlider.maximumValue = Float(reverb.valueRange().maxValue)
                break
            default: break
            }
            cell.indexPath = indexPath
            cell.valueSlider.value = Float(currentValueDic[cell.title]!)
            cell.value = Double(currentValueDic[cell.title]!)
            cell.delegate = self
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Role"
        case 1: return "Pitch"
        case 2: return "EqualizationBandFrequency"
        case 3: return "Reverb"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        else {
            let role = EffectType.rolesList()[indexPath.row]
            setRoleEffect(role: role)
        }
    }
}

private extension EffectViewController {
    func setRoleEffect(role: EffectRoles) {
        let character = role.character()
        
        for (key, _) in currentValueDic {
            currentValueDic[key] = character[key]
            setAudioEffect(key: key, value: character[key]!)
        }

        let index = IndexSet(integersIn: 1...3)
        tableView.reloadSections(index, with: .fade)
    }
    
    func setAudioEffect(key: String, value: Double) {
        switch key {
        case "Pitch": agoraKit.setLocalVoicePitch(value)
        case "Band31": agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: Int(value))
        case "Band62": agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: Int(value))
        case "Band125": agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: Int(value))
        case "Band250": agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: Int(value))
        case "Band500": agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: Int(value))
        case "Band1k": agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: Int(value))
        case "Band2k": agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: Int(value))
        case "Band4k": agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: Int(value))
        case "Band8k": agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: Int(value))
        case "Band16k": agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: Int(value))
        case "DryLevel": agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: Int(value))
        case "WetLevel": agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: Int(value))
        case "RoomSize": agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: Int(value))
        case "WetDelay": agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: Int(value))
        case "Strength": agoraKit.setLocalVoiceReverbOf(.strength, withValue: Int(value))
        default: print("")
        }
    }
}

extension EffectViewController: EffectCellDelegate {
    func effectCell(didSliderValueChange indexPath: IndexPath, value: Double) {
        switch indexPath.section {
        case 1:
            agoraKit.setLocalVoicePitch(value)
            currentValueDic["Pitch"] = value
            break
        case 2:
            let bandFrequency = EffectType.equalizationBandFrequencysList()[indexPath.row]
            agoraKit.setLocalVoiceEqualizationOf(bandFrequency, withGain: Int(value))
            currentValueDic[bandFrequency.description()] = value
            break
        case 3:
            let reverb = EffectType.reverbsList()[indexPath.row]
            agoraKit.setLocalVoiceReverbOf(reverb, withValue: Int(value))
            currentValueDic[reverb.description()] = value
            break
        default: break
        }
    }
}
