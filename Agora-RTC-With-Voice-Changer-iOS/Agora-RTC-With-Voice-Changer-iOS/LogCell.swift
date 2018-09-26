//
//  LogCell.swift
//  Agora-RTC-With-Voice-Changer-iOS
//
//  Created by GongYuhua on 2017/4/7.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var logLabel: UILabel!
    
    func set(log: String) {        
        logLabel.text = log
    }
}
