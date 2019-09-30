//
//  SubSetCell.swift
//  YoYo
//
//  Created by CavanSu on 2018/7/4.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

class SubSettingCell: UITableViewCell {
    private var unselectedColor = UIColor.init(hexString: "#454545")
    private var selectedColor = UIColor.init(hexString: "#666666")

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            self.contentView.backgroundColor = selectedColor
        } else {
            UIView.animate(withDuration: 0.1) {
                self.contentView.backgroundColor = self.unselectedColor
            }
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted == true {
            self.contentView.backgroundColor = selectedColor
        } else {
            self.contentView.backgroundColor = unselectedColor
        }
    }
}
