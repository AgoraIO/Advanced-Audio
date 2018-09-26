//
//  MainViewController.swift
//  Agora-RTC-With-Voice-Changer-iOS
//
//  Created by GongYuhua on 2017/4/7.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier , segueId == "mainToRoom" else {
            return
        }
        
        let roomVC = segue.destination as! RoomViewController
        roomVC.roomName = roomNameTextField.text
        if let value = sender as? NSNumber, let role = AgoraClientRole(rawValue: value.intValue) {
            roomVC.clientRole = role
        }
        roomVC.delegate = self
    }
    
    @IBAction func doJoinPressed(_ sender: UIButton) {
        enterRoom()
    }
}

private extension MainViewController {
    func enterRoom() {
        guard let roomName = roomNameTextField.text , !roomName.isEmpty else {
            return
        }
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let broadcaster = UIAlertAction(title: "Broadcaster", style: .default) { [unowned self] _ in
            self.enterRoom(withRole: .broadcaster)
        }
        let audience = UIAlertAction(title: "Audience", style: .default) { [unowned self] _ in
            self.enterRoom(withRole: .audience)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(broadcaster)
        sheet.addAction(audience)
        sheet.addAction(cancel)
        sheet.popoverPresentationController?.sourceView = joinButton
        sheet.popoverPresentationController?.permittedArrowDirections = .up
        present(sheet, animated: true, completion: nil)
    }
    
    func enterRoom(withRole role: AgoraClientRole) {
        performSegue(withIdentifier: "mainToRoom", sender: NSNumber(value: role.rawValue))
    }
}

extension MainViewController: RoomVCDelegate {
    func roomVCNeedClose(_ roomVC: RoomViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterRoom()
        return true
    }
}
