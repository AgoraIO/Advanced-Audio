//
//  RoomCell.swift
//  YoYo
//
//  Created by CavanSu on 04/05/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class RoomCell: UICollectionViewCell {
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var peopleCountLabel: UILabel!
    
    private func setPeopleCount(_ countString: String) {
        let attrStr = NSMutableAttributedString(string: countString)
        let color = UIColor.init(hexString: "#09BDF4")
        if let color = color {
            let kv = [NSAttributedString.Key.foregroundColor: color]
            let range = NSRange.init(location: 0, length: countString.count - 1)
            attrStr.addAttributes(kv, range: range)
            peopleCountLabel.attributedText = attrStr
        }
    }
    
    func update(_ info: RoomInfo) {
        roomImageView.image = info.image
        roomNameLabel.text = info.name
        setPeopleCount("\(info.peopleCount) 人")
    }
}
