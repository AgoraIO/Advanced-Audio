//
//  StreamIdParse.swift
//  YoYo
//
//  Created by CavanSu on 2019/8/7.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit

struct StreamIdParse {
    enum Result {
        case user(User), player(Player)
        
        var rawValue: Int {
            switch self {
            case .user:    return 0
            case .player:  return 1
            }
        }
        
        static func ==(left: Result, right: Result) -> Bool {
            return left.rawValue == right.rawValue
        }
        
        static func !=(left: Result, right: Result) -> Bool {
            return left.rawValue != right.rawValue
        }
    }
    
    static func parse(with streamId: UInt) -> StreamIdParse.Result {
        let plaform = streamId / 1000
        let id = streamId % 1000
        
        if plaform == 3 {
            let player = Player(streamId: streamId, id: id)
            return .player(player)
        } else {
            let user = User(streamId: streamId, id: id)
            return .user(user)
        }
    }
}
