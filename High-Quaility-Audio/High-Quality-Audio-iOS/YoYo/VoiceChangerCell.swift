//
//  VoiceChangerCell.swift
//  YoYo
//
//  Created by CavanSu on 2018/6/25.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

class VoiceChangerCell: UICollectionViewCell {
    @IBOutlet weak var roleLabel: UILabel!
    private let selectedColor = UIColor.init(hexString: "#09BDF4")
    private let unselectedColor = UIColor.init(hexString: "#CCCCCC")
    private let selectedFont = UIFont.boldSystemFont(ofSize: 17)
    private let unselectedFont = UIFont.systemFont(ofSize: 17)
    
    var isRoleSelected: Bool! {
        didSet {
            let color = isRoleSelected ? selectedColor : unselectedColor
            let font = isRoleSelected ? selectedFont : unselectedFont
            self.roleLabel.textColor = color
            self.roleLabel.font = font
            self.layer.borderColor = color?.cgColor
            self.layer.cornerRadius = 15
        }
    }
}
