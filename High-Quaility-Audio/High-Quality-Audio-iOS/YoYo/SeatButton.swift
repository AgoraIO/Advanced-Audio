//
//  MicSeatButton.swift
//  YoYo
//
//  Created by CavanSu on 2018/6/7.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

class SeatButton: UIButton {
    fileprivate struct Tags: OptionSet {
        let rawValue: Int
        static let none = Tags(rawValue: 0)
        static let muteAudio = Tags(rawValue: 1 << 0)
        static let hasPlayer = Tags(rawValue: 1 << 1)
    }
    
    private lazy var icon1ImageView: UIImageView = {() -> UIImageView in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var icon2ImageView: UIImageView = {() -> UIImageView in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var centerImageView: UIImageView = {() -> UIImageView in
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "g_add")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var iconTag: Tags = .none {
        didSet {
            guard oldValue != iconTag else {
                return
            }
            updateIconTag(iconTag)
        }
    }
    
    private var isDeviceAdapt: Bool = false
    
    override var isHighlighted: Bool {
        set {
        }
        get {
            return false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(centerImageView)
        self.addSubview(icon1ImageView)
        self.addSubview(icon2ImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isDeviceAdapt {
            isDeviceAdapt = true
            
            let r = self.bounds.width * 0.5
            let d = sqrt(r * r * 0.5)
            let imageWH: CGFloat = 15.0
            let imageXY = d + r - (imageWH * 0.5)
            icon1ImageView.frame = CGRect(x: imageXY, y: imageXY, width: imageWH, height: imageWH)
            icon2ImageView.frame = CGRect(x: imageXY, y: imageXY - imageWH - 5, width: imageWH, height: imageWH)
            
            self.cornerRadius = r
            
            let cw = 32
            let ch = cw
            let cx = self.frame.width * 0.5
            let cy = self.frame.height * 0.5
            centerImageView.frame = CGRect(x: 0, y: 0, width: cw, height: ch)
            centerImageView.center = CGPoint(x: cx, y: cy)
            
            imageView?.cornerRadius = self.frame.width * 0.5
            imageView?.contentMode = .scaleToFill
        }
    }
}

extension SeatButton {
    func update(_ seat: Seat) {
        switch seat.type {
        case .none:
            centerImageView.isHidden = false
            setImage(nil, for: .normal)
        case .takeup(let broadcaster):
            centerImageView.isHidden = true
            
            let head = ImageGroup.shared().head(of: broadcaster.info.head)
            setImage(head, for: .normal)
            
            var tag = Tags(rawValue: 0)
            
            if !broadcaster.audioRecording {
                tag.insert(.muteAudio)
            }
            
            if broadcaster.hasPlayer {
                tag.insert(.hasPlayer)
            }
            
            self.iconTag = tag
        }
    }
    
    private func updateIconTag(_ tag: Tags) {
        if tag.contains([.hasPlayer, .muteAudio]) {
            icon1ImageView.image = UIImage(named: "g_mute")
            icon1ImageView.isHidden = false
            icon2ImageView.isHidden = false
        } else if tag.contains(.hasPlayer) {
            icon1ImageView.isHidden = false
            icon2ImageView.isHidden = true
        } else if tag.contains(.muteAudio) {
            icon1ImageView.image = UIImage(named: "g_mute")
            icon1ImageView.isHidden = false
            icon2ImageView.isHidden = true
        } else {
            icon1ImageView.isHidden = true
            icon2ImageView.isHidden = true
        }
    }
}
