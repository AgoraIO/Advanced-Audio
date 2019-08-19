//
//  VoiceChangerViewController.swift
//  YoYo
//
//  Created by CavanSu on 2018/6/25.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

protocol VoiceChangerVCDelegate: NSObjectProtocol {
    func voiceChangerVC(_ vc: VoiceChangerViewController, didSelected role: EffectRoles, roleIndex:Int)
    func voiceChanngerVCDidCancel(_ vc: VoiceChangerViewController)
}

class VoiceChangerViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var rolesList: [EffectRoles] = EffectRoles.list
    weak var delegate: VoiceChangerVCDelegate?
    var selectedIndex: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        updateCollectionViewLayout()
    }
    
    @IBAction func doConfirmPressed(_ sender: UIButton) {
        if let selectedIndex = selectedIndex {
            let role = rolesList[selectedIndex]
            delegate?.voiceChangerVC(self, didSelected: role, roleIndex: selectedIndex)
        } else {
            delegate?.voiceChanngerVCDidCancel(self)
        }
    }
    
    @IBAction func doCancelPressed(_ sender: UIButton) {
        delegate?.voiceChanngerVCDidCancel(self)
    }
}

private extension VoiceChangerViewController {
    func updateViews() {
        self.navigationItem.title = "变声"
    }
    
    func updateCollectionViewLayout() {
        let itemWidth = UIScreen.main.bounds.size.width * 0.25 * DeviceAdapt.getWidthCoefficient()
        let itemHeight = CGFloat(30)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
}

extension VoiceChangerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rolesList.count - 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoiceChangerCell", for: indexPath) as! VoiceChangerCell
        let role = rolesList[indexPath.item]
        cell.roleLabel.text = role.description()
       
        if let _ = selectedIndex, selectedIndex == indexPath.item {
            cell.isRoleSelected = true
        } else {
            cell.isRoleSelected = false
        }
        return cell
    }
}

extension VoiceChangerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selected = selectedIndex, selected == indexPath.item {
            let index = IndexPath(item: selected, section: 0)
            selectedIndex = indexPath.item
            selectedIndex = nil
            collectionView.reloadItems(at: [index])
            return
        }
        
        if let selected = selectedIndex {
            let index = IndexPath(item: selected, section: 0)
            selectedIndex = indexPath.item
            collectionView.reloadItems(at: [index])
        } else {
            selectedIndex = indexPath.item
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}
