//
//  Seat.swift
//  YoYo
//
//  Created by CavanSu on 2019/8/7.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit

struct Seat {
    struct Broadcaster {
        var info: User
        var hasPlayer: Bool
        var audioRecording: Bool
    }
    
    enum SeatType {
        case none, takeup(Broadcaster)
        
        var rawValue: Int {
            switch self {
            case .takeup: return 0
            case .none:   return 1
            }
        }
        
        static func ==(left: Seat.SeatType, right: Seat.SeatType) -> Bool {
            return left.rawValue == right.rawValue
        }
    }
    
    var broadcaster: Broadcaster? {
        switch self.type {
        case .takeup(let user): return user
        case .none:             return nil
        }
    }
    
    var type: SeatType
}
