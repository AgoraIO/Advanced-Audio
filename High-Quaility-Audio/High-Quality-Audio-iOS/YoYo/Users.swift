//
//  User.swift
//  YoYo
//
//  Created by CavanSu on 2019/8/6.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit

enum RoomRole {
    case broadcast, audience
    
    var rawValue: Int {
        switch self {
        case .broadcast: return 0
        case .audience:  return 1
        }
    }
}

struct User {
    var streamId: UInt
    var id: UInt
    var head: Int
    
    init(streamId: UInt, id: UInt) {
        self.streamId = streamId
        self.id = id
        self.head = Int(id % 9)
    }
    
    static func fake() -> User {
        let id = UInt(arc4random() % 999)
        let platform: UInt = 2 // iOS tag
        let streamId = platform * 1000 + id
        
        let user = User(streamId: streamId, id: id)
        return user
    }
}

class RoomCurrent: NSObject {
    var info: User
    var seatIndex: Int?
    
    init(info: User) {
        self.info = info
    }
}
