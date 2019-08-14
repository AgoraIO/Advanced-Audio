//
//  NavigationViewController.swift
//  YoYo
//
//  Created by CavanSu on 2018/6/29.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBar()
        addCustomeView()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.setHidesBackButton(true, animated: false)
        if let titleCenter = self.navigationItem.titleView?.center {
            updateBackButtonCenterY(y: titleCenter.y)
        }
        super.pushViewController(viewController, animated: animated)
    }
}

private extension NavigationViewController {
    func updateBar() {
        navigationItem.hidesBackButton = true
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor.init(hexString: "#09BDF4")
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
    }
    
    func addCustomeView() {
        let x = CGFloat(15)
        let w = CGFloat(30)
        let h = CGFloat(30)
        let y = CGFloat(13 + 19.5 * 0.5 - h * 0.5)
        let backButton = UIButton(frame: CGRect(x: x, y: y, width: w, height: h))
        backButton.setImage(#imageLiteral(resourceName: "g_whiteleft"), for: .normal)
        backButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        self.navigationBar.addSubview(backButton)
        self.backButton = backButton
    }
    
    func updateBackButtonCenterY(y: CGFloat) {
        var backButtonCenter = backButton.center
        backButtonCenter.y = y
        backButton.center = backButtonCenter
    }
    
    @objc func popBack() {
        if let vc = self.viewControllers.last {
            vc.navigationController?.popViewController(animated: true)
        }
    }
}
