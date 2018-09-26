//
//  EffectCell.swift
//  Agora-RTC-With-Voice-Changer-iOS
//
//  Created by CavanSu on 14/03/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

protocol EffectCellDelegate: NSObjectProtocol {
    func effectCell(didSliderValueChange indexPath: IndexPath, value: Double)
}

class EffectCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    
    var indexPath: IndexPath!
    weak var delegate: EffectCellDelegate?
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    var value: Double! {
        didSet {
            if indexPath.section == 0 {
                valueLabel.text = NSString.init(format: "%.1f", value) as String
            }
            else {
                valueLabel.text = "\(Int(value))"
            }
            
            delegate?.effectCell(didSliderValueChange: indexPath, value: value)
        }
    }
    
    @IBAction func doValueChanged(_ sender: UISlider) {
        value = Double(sender.value)
    }
}
