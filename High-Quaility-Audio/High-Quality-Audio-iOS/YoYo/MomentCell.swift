//
//  MomentsCell.swift
//  YoYo
//
//  Created by CavanSu on 06/05/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class MomentCell: UITableViewCell {
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var momentsLabel: UILabel!
    
    func update(_ moment: Moment) {
        self.headImageView.image = ImageGroup.shared().head(of: moment.user.head)
        self.nameLabel.text = "用户 \(moment.user.streamId)"
        self.momentsLabel.text = moment.content
    }
}
