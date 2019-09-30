//
//  DeviceAdapt.swift
//  YoYo
//
//  Created by CavanSu on 2018/6/5.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

enum DeviceAdapt {
    case classicFourInch, classicFourPointSevenInch, classicFivePointFiveInch
    case newFourPointSevenInch, newFivePointFiveInch
    case unsupported
    
    static func currentType() -> DeviceAdapt {
        switch UIScreen.main.bounds.width {
        case 320.0:
            return .classicFourInch
            
        // classic: width: 375.0, height: 667.0
        // x: width: 375.0, height: 812.0
        case 375.0:
            if UIScreen.main.bounds.height == 812 {
                return .newFourPointSevenInch
            } else {
                return .classicFourPointSevenInch
            }
            
        // classic: width: 414.0, height: 736.0
        // xr: width: 414.0, height: 896.0
        // xs: width: 414.0, height: 896.0
        case 414.0:
            if UIScreen.main.bounds.height == 896 {
                return .newFivePointFiveInch
            } else {
                return .classicFivePointFiveInch
            }
        default:
            return .unsupported
        }
    }
    
    static func getWidthCoefficient() -> CGFloat {
        let standardWidth: CGFloat = 375.0
        let coefficient = UIScreen.main.bounds.width / standardWidth
        return coefficient
    }
    
    static func getHeightCoefficient() -> CGFloat {
        let standardWidth: CGFloat = 667.0
        let coefficient = UIScreen.main.bounds.height / standardWidth
        return coefficient
    }
    
    static func getScrrenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func getScrrenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
