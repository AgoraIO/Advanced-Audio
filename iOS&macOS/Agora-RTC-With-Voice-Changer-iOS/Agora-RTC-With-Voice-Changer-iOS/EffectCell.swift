//
//  EffectCell.swift
//  Agora-RTC-With-Voice-Changer-iOS
//
//  Created by CavanSu on 14/03/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

protocol EffectCellDelegate: NSObjectProtocol {
    func cell(_ cell: EffectCell, didSliderValueChange indexPath: IndexPath, value: Double)
}

class EffectCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    
    weak var delegate: EffectCellDelegate?
    
    var value: Double = 0.0
    var indexPath: IndexPath!
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBAction func doValueChanged(_ sender: UISlider) {
        value = Double(sender.value)
        
        if indexPath.section == 0 {
            valueLabel.text = NSString(format: "%.1f", value) as String
        }
        else {
            valueLabel.text = "\(Int(value))"
        }
        
        delegate?.cell(self, didSliderValueChange: indexPath, value: value)
    }
}
