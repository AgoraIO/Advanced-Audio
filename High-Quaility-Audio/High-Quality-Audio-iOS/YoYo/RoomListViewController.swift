//
//  RoomListViewController.swift
//  YoYo
//
//  Created by CavanSu on 04/05/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class RoomListViewController: UIViewController {
    @IBOutlet weak var roomsCollectionView: UICollectionView!
    
    let imageGroup = ImageGroup.shared()
    let current = User.fake()
    
    lazy var roomsList: [RoomInfo] = {
        var list = [RoomInfo]()
        for index in 0...4 {
            let image = imageGroup.roomList[index]
            let background = imageGroup.roomBackgroundList[index]
            let name = RoomInfo.titleList[index]
            let roomId = RoomInfo.idList[index]
            let info = RoomInfo(image: image,
                                backgroundImage: background,
                                name: name,
                                roomId: roomId)
            list.append(info)
        }
        return list
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCollectionViewLayout()
    }
}

private extension RoomListViewController {
    func updateCollectionViewLayout() {
        let itemWidth = 160 * DeviceAdapt.getWidthCoefficient()
        let itemHeight = 190 * DeviceAdapt.getWidthCoefficient()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .vertical
        roomsCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func presentRoom(_ room: RoomInfo) {
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigation = story.instantiateViewController(withIdentifier: "NavigationViewController")
        let vc = navigation.children.first
        guard let roomVC = vc as? RoomViewController else {
            return
        }
        
        roomVC.info = room
        roomVC.current = RoomCurrent(info: current)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
    }
    
    func debugLog(log: String) {
        #if DEBUG
        print("<RoomList> \(log)")
        #endif
    }
}

extension RoomListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "room", for: indexPath) as! RoomCell
        let info = roomsList[indexPath.item]
        cell.update(info)
        return cell
    }
}

extension RoomListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let room = roomsList[indexPath.item]
        presentRoom(room)
    }
}
