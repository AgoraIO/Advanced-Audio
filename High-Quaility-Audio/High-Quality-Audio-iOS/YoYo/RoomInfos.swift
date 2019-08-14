//
//  RoomInfos.swift
//  YoYo
//
//  Created by CavanSu on 04/05/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

struct RoomInfo {
    var image: UIImage
    var name: String
    var peopleCount: Int
    var type: RoomType
    var roomId: String
    
    init(image: UIImage) {
        self.image = image
        self.name = "这里有你喜欢的话题"
        self.peopleCount = 100
        self.type = .fmRoom
        self.roomId = "Yoyo321123"
    }
}

struct RoomInfos {
    static func list() -> [RoomInfo] {
        var array = [RoomInfo]()
        for index in 0..<12 {
            let room = getFakeRoomInfo(index: index)
            array.append(room)
        }
        return array
    }
    
    static func getRoomInfo(index: Int, roomName: String, roomType: Int, channelId: String) -> RoomInfo {
        let imageIndex = index % 12
        let imageName = "room\(imageIndex)"
        let image = UIImage.init(named: imageName)
        let count = Int(arc4random() % 100)
        let room = RoomInfo.init(image: image!)
        return room
    }
    
    fileprivate static func getFakeRoomInfo(index: Int) -> RoomInfo {
        let imageName = "room\(index)"
        let image = UIImage.init(named: imageName)
        let count = Int(arc4random() % 100)
        let roomName = roomTitleList()[index]
        let room = RoomInfo.init(image: image!)
        return room
    }
    
    static func fakeRoomName() -> String {
        return getRoomName()
    }
    
    fileprivate static func getRoomName() -> String {
        var array = roomTitleList()
        let count = Int(arc4random() % UInt32(array.count))
        return array[count]
    }
    
    static func roomTitleList() -> [String] {
        let array = ["深夜卧谈", "出去玩就一定会买错", "为梦想打 call", "同城 同城", "醒不来的午夜电影",
                     "湖人总冠军", "养花的微小经验", "让耳朵怀孕", "毕加索的达芬奇", "中国好声音",
                     "一座城一个人", "这里有你喜欢的话题", "声网Agora" , "四种杠精类型",  "看剧去学习某项技能吗?"]
        return array
    }
}



enum RoomType: Int {
    case gameRoom = 0, entertainRoom, ktvRoom, fmRoom
    
    static func getRoomType(index: Int) -> RoomType {
        switch index {
        case 0: return gameRoom
        case 1: return entertainRoom
        case 2: return ktvRoom
        case 3: return fmRoom
        default: return gameRoom
        }
    }
}

enum RoomDestination {
    case joinRoom, buildRoom, noneDestination
}

