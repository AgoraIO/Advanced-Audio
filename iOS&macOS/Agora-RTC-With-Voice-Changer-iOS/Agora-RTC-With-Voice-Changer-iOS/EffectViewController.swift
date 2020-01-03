//
//  EffectViewController.swift
//   Agora-RTC-With-Voice-Changer-iOS
//
//  Created by CavanSu on 14/03/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import AgoraRtcKit

enum EffectSettingType: Int {
    case role = 0, custom
    
    var description: String {
        switch self {
        case .role:   return "Role"
        case .custom: return "Custom"
        }
    }
    
    static var list: [EffectSettingType] {
        return [.role, .custom]
    }
}

class EffectViewController: UITableViewController {
    let effectValueDicInit = { () -> [String: Double] in
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
    }
    
    lazy var effectValueDic: [String: Double] = effectValueDicInit()
    
    var agoraKit: AgoraRtcEngineKit!
    var settingType: EffectSettingType = .role
    
    var selectedRole: EffectRoles = .Default {
        didSet {
            agoraKit.setLocalVoiceChanger(selectedRole.agValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let items = [EffectSettingType.role.description, EffectSettingType.custom.description]
        let segControl = UISegmentedControl(items: items)
        segControl.addTarget(self, action: #selector(chooseSettingType(sender:)), for: .valueChanged)
        segControl.selectedSegmentIndex = settingType.rawValue
        tableView.tableHeaderView = segControl
        preferredContentSize = CGSize(width: 300, height: 400)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if settingType == .role {
            return 1
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if settingType == .role {
            return EffectRoles.list.count
        } else {
            switch section {
            case 0:     return 1
            case 1:     return EffectType.equalizationBandFrequencysList().count
            case 2:     return EffectType.reverbsList().count
            default:    return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if settingType == .role {
            let cell = tableView.dequeueReusableCell(withIdentifier: "role_reuse")
            let role = EffectRoles.list[indexPath.row]
            cell?.accessoryType = (selectedRole == role) ? .checkmark : .none
            cell?.textLabel?.text = role.description()
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "effect_reuse") as! EffectCell
            switch indexPath.section {
            case 0:
                cell.title = "Pitch"
                cell.valueSlider.minimumValue = 0.5
                cell.valueSlider.maximumValue = 2.0
            case 1:
                let bandFrequency = EffectType.equalizationBandFrequencysList()[indexPath.row]
                cell.title = bandFrequency.description()
                cell.valueSlider.minimumValue = Float(bandFrequency.valueRange().minValue)
                cell.valueSlider.maximumValue = Float(bandFrequency.valueRange().maxValue)
            case 2:
                let reverb = EffectType.reverbsList()[indexPath.row]
                cell.title = reverb.description()
                cell.valueSlider.minimumValue = Float(reverb.valueRange().minValue)
                cell.valueSlider.maximumValue = Float(reverb.valueRange().maxValue)
            default: break
            }
            cell.indexPath = indexPath
            cell.valueSlider.value = Float(effectValueDic[cell.title]!)
            cell.value = Double(effectValueDic[cell.title]!)
            cell.delegate = self
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if settingType == .role {
            return "Role"
        } else {
            switch section {
            case 0:  return "Pitch"
            case 1:  return "EqualizationBandFrequency"
            case 2:  return "Reverb"
            default: return ""
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if settingType == .role {
            let role = EffectRoles.list[indexPath.row]
            
            if selectedRole == role {
                selectedRole = .Default
            } else {
                selectedRole = role
            }
            tableView.reloadData()
        }
    }
}

private extension EffectViewController {
    @objc func chooseSettingType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case EffectSettingType.role.rawValue:
            settingType = .role
        case EffectSettingType.custom.rawValue:
            settingType = .custom
        default:
            break;
        }
        
        selectedRole = .Default
        effectValueDic = effectValueDicInit()
        tableView.reloadData()
    }
}

extension EffectViewController: EffectCellDelegate {
    func cell(_ cell: EffectCell, didSliderValueChange indexPath: IndexPath, value: Double) {
        switch indexPath.section {
        case 0:
            agoraKit.setLocalVoicePitch(value)
            effectValueDic["Pitch"] = value
        case 1:
            let bandFrequency = EffectType.equalizationBandFrequencysList()[indexPath.row]
            agoraKit.setLocalVoiceEqualizationOf(bandFrequency, withGain: Int(value))
            effectValueDic[bandFrequency.description()] = value
        case 2:
            let reverb = EffectType.reverbsList()[indexPath.row]
            agoraKit.setLocalVoiceReverbOf(reverb, withValue: Int(value))
            effectValueDic[reverb.description()] = value
        default: break
        }
    }
}
