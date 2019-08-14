//
//  SettingViewController.swift
//  YoYo
//
//  Created by CavanSu on 2018/6/25.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

protocol SettingVCDelegate: NSObjectProtocol {
    func settingVCWillShowOnSettingBackgroundView(_ vc: SettingViewController) -> UIView
    func settingVCDidEndShow(_ vc: SettingViewController)

    func settingVCDidSelectedVoiceChanger(_ vc: SettingViewController)
    func settingVCDidSelectedExitRoom(_ vc: SettingViewController)
}

class SettingViewController: UIViewController {
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    weak var delegate: SettingVCDelegate?
    var backgroundView: UIView?
    var beginFrame: CGRect?
    var endFrame: CGRect?
    
    var isDeviceAdapt: Bool = false {
        didSet {
            if isDeviceAdapt == true,
                (DeviceAdapt.currentType() == DeviceAdapt.newFourPointSevenInch || DeviceAdapt.currentType() == DeviceAdapt.newFivePointFiveInch) {
                topViewHeight.constant = topViewHeight.constant + 24
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isDeviceAdapt {
            isDeviceAdapt = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier, !segueId.isEmpty else {
            return
        }
        
        switch segueId {
        case "SubSettingViewController":
            let vc = segue.destination as! SubSettingViewController
            vc.tableView.delegate = self
        default:
            break
        }
    }
    
    func isShow(isShow: Bool) {
        if let bgView = delegate?.settingVCWillShowOnSettingBackgroundView(self) {
            viewMove(to: bgView, isShow: isShow)
        }
    }
    
    @IBAction func doExitRoomPressed(_ sender: UIButton) {
        delegate?.settingVCDidSelectedExitRoom(self)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            delegate?.settingVCDidSelectedVoiceChanger(self)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        return view
    }
}

private extension SettingViewController {
    func viewMove(to bgView: UIView, isShow: Bool) {
        if let _ = self.beginFrame {
        } else {
            var beginFrame = self.view.frame
            beginFrame.origin.x = bgView.bounds.width
            
            var height: CGFloat
            if DeviceAdapt.currentType() == DeviceAdapt.newFourPointSevenInch {
                height = UIScreen.main.bounds.height - 34
            } else {
                height = UIScreen.main.bounds.height
            }
            
            let width = 284 * DeviceAdapt.getWidthCoefficient()
            beginFrame.size.width = width
            beginFrame.size.height = height
            self.beginFrame = beginFrame
        }
        
        if let _ = self.endFrame {
        } else if let beginFrame = self.beginFrame {
            var endFrame = beginFrame
            endFrame.origin.x = bgView.frame.width - beginFrame.size.width
            self.endFrame = endFrame
        }
        
        if let beginFrame = self.beginFrame, let endFrame = self.endFrame {
            if isShow {
                bgView.addSubview(self.view)
                self.preferredContentSize = CGSize(width: beginFrame.size.width, height: beginFrame.size.height)
                self.view.frame = beginFrame
                UIView.animate(withDuration: 0.3) { [weak self]  in
                    if let strongSelf = self {
                        strongSelf.view.frame = endFrame
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = beginFrame
                }) { [weak self] (isFinish) in
                    if isFinish, let strongSelf = self {
                        strongSelf.view.removeFromSuperview()
                        strongSelf.delegate?.settingVCDidEndShow(strongSelf)
                    }
                }
            }
        }
    }
}

