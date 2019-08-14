//
//  ImageGroup.swift
//  YoYo
//
//  Created by CavanSu on 2019/8/6.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit

class ImageGroup: NSObject {
    static let instance = ImageGroup()
    
    var roomBackgroundList: [UIImage]
    var userHeadList: [UIImage]
    
    static func shared() -> ImageGroup {
        return instance
    }
    
    override init() {
        roomBackgroundList = [UIImage]()
        for index in 0...11 {
            let image = UIImage(named:"room\(index)")
            roomBackgroundList.append(image!)
        }
        
        userHeadList = [UIImage]()
        for index in 0...11 {
            let image = UIImage(named:"head\(index)")
            userHeadList.append(image!)
        }
    }
    
    func head(of index: Int) -> UIImage {
        return userHeadList[index]
    }
}
