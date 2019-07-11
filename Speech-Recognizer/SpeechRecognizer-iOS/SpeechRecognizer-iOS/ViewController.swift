//
//  ViewController.swift
//  SpeechRecognizer-iOS
//
//  Created by GongYuhua on 2019/7/8.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var channelTextField: UITextField!
    @IBOutlet weak var localSwitcher: UISegmentedControl!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            return
        }
        
        switch segueId {
        case "rootVCToRoomVC":
            let channelVC = segue.destination as! ChannelViewController
            channelVC.channel = channelTextField.text
            channelVC.local = Locale(identifier: localSwitcher.selectedSegmentIndex == 0 ? "en_US" : "zh_CN")
        default:
            return
        }
    }
    
    @IBAction func channelEditing(_ sender: UITextField) {
        if let channel = sender.text, !channel.isEmpty {
            joinButton.isEnabled = true
        } else {
            joinButton.isEnabled = false
        }
    }
}

