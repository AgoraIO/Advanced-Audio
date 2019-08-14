//
//  Player.swift
//  YoYo
//
//  Created by CavanSu on 2019/8/8.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit

struct Player {
    var streamId: UInt
    var id: UInt
}

extension Array where Element == Player {
    func first(of id: UInt) -> Player? {
        let player = self.first { (player) -> Bool in
            return player.id == id
        }
        return player
    }
}
