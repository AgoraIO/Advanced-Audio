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
    
    func update(_ info: RoomInfo) {
        roomImageView.image = info.image
        roomNameLabel.text = info.name
    }
}
