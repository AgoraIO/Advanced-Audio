//
//  AureolaView.swift
//  AureolaView
//
//  Created by CavanSu on 2018/7/3.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

class AureolaView: UIView {
    private var layer1: CALayer!
    private var layer2: CALayer!
    private var layerColor: UIColor!
    private var layWidth: CGFloat = 10
    private var aboveViewSize: CGSize!
    private var aboveView: UIView!
    private var animationRepeat = 1
    private var groupAnimate: CAAnimationGroup!
    private var opacityAnimate: CAKeyframeAnimation!
    private var isAnimating: Bool = false
    private var animationDuration = 1.1 * 0.9
    
    convenience init(color: UIColor) {
        self.init()
        self.layerColor = color
        self.isHidden = true
        self.createLayer1WithoutFrame()
        self.createLayer2WithoutFrame()
    }
    
    func startLayerAnimation(aboveView: UIView, layerWidth: CGFloat) {
        if isAnimating == true {
            return
        }
        
        if self.isHidden == true {
            self.isHidden = false
        }
        
        if self.aboveView == nil {
            self.aboveView = aboveView
            self.layWidth = layerWidth
            
            let aboveViewFrame = aboveView.frame
            let centerX = aboveViewFrame.minX + aboveViewFrame.width * 0.5
            let centerY = aboveViewFrame.minY + aboveViewFrame.height * 0.5
            let aboveCenter = CGPoint(x: centerX, y: centerY)
            
            let width = aboveViewFrame.width
            let height = aboveViewFrame.height
            let aboveSize = CGSize(width: width, height: height)
            
            updateViewAndLayersFrame(aboveViewCenter: aboveCenter, aboveViewSize: aboveSize)
        }
        
        startLayer1Animation()
        startLayer2Animation()
    }
    
    func removeAnimation() {
        self.isHidden = true
        layer1.removeAllAnimations()
        layer2.removeAllAnimations()
    }
}

private extension AureolaView {
    func createLayer1WithoutFrame() { // Big
        layer1 = CALayer()
        layer1.borderWidth = layWidth
        layer1.borderColor = layerColor.cgColor
        layer1.backgroundColor = layerColor.cgColor
        self.layer.addSublayer(layer1)
    }
    
    func createLayer2WithoutFrame() { // Small
        layer2 = CALayer()
        layer2.borderWidth = layWidth
        layer2.borderColor = layerColor.cgColor
        layer2.backgroundColor = layerColor.cgColor
        self.layer.addSublayer(layer2)
    }
    
    func startLayer1Animation() {
        createOpacityAnimation()
        self.layer1.add(self.opacityAnimate, forKey: nil)
    }
    
    func startLayer2Animation() {
        createGroupAnimation()
        self.layer2.add(groupAnimate, forKey: nil)
    }
    
    func createOpacityAnimation() {
        if let _ = opacityAnimate {
            return
        }
        
        let animation1 = CAKeyframeAnimation()
        animation1.isRemovedOnCompletion = false
        animation1.fillMode = CAMediaTimingFillMode.forwards
        
        var valuesList = [Float]()
        let value1 = Float(0)
        valuesList.append(value1)
        var value2 = Float(1)
        valuesList.append(value2)
        let a = Float(0.0125)
        let b = Float(0.15)
        
        for index in 0..<9 {
            if index < 2 || index > 6 {
                value2 = value2 - a
            } else {
                value2 = value2 - b
            }
            valuesList.append(value2)
        }
        
        animation1.values = valuesList
        animation1.duration = animationDuration
        animation1.keyPath = "opacity"
        animation1.repeatCount = Float(animationRepeat)
        self.opacityAnimate = animation1
    }
    
    func createGroupAnimation() {
        if let _ = groupAnimate {
            return
        }
        
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        
        var opacityValuesList = [Float]()
        var scaleValuesList = [Float]()
        
        let opacityValue1 = Float(0)
        var opacityValue = Float(1)
        
        let scaleValue1 = Float(0)
        var scaleValue = Float(1)
        
        opacityValuesList.append(opacityValue1)
        opacityValuesList.append(opacityValue)
        
        scaleValuesList.append(scaleValue1)
        scaleValuesList.append(scaleValue)
        
        let a = Float(1 / 9.0)
        let b = Float(0.05)
        
        for _ in 0..<8 {
            opacityValue = opacityValue - a
            scaleValue = scaleValue + b
            opacityValuesList.append(opacityValue)
            scaleValuesList.append(scaleValue)
        }
        
        opacityValuesList.append(0)
        scaleValuesList.append(scaleValue + b)
        
        let opacity = CAKeyframeAnimation()
        opacity.values = opacityValuesList
        opacity.keyPath = "opacity"
        
        let scale = CAKeyframeAnimation()
        scale.keyPath = "transform.scale"
        scale.values = scaleValuesList
        
        group.duration = animationDuration
        group.repeatCount = Float(animationRepeat)
        group.animations = [opacity, scale]
        
        group.delegate = self
        self.groupAnimate = group
    }
    
    func updateViewAndLayersFrame(aboveViewCenter: CGPoint, aboveViewSize: CGSize) {
        guard let superview = self.aboveView.superview else {
            return
        }
        
        superview.addSubview(self)
        superview.insertSubview(self, belowSubview: self.aboveView)
        
        self.frame = CGRect(x: 0, y: 0, width: aboveViewSize.width + 50, height: aboveViewSize.height + 50)
        self.center = aboveViewCenter

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let borderwidth = layWidth
        
        let w1 = aboveViewSize.width + borderwidth
        let h1 = aboveViewSize.height + borderwidth
        let x1 = (self.frame.width - w1) * 0.5
        let y1 = (self.frame.height - h1) * 0.5
        self.layer1.frame = CGRect(x: x1, y: y1, width: w1, height: h1)
        self.layer1.cornerRadius = h1 * 0.5
        
        let w2 = w1 + borderwidth
        let h2 = w1 + borderwidth
        let x2 = (self.frame.width - w2) * 0.5
        let y2 = (self.frame.height - h2) * 0.5
        self.layer2.frame = CGRect(x: x2, y: y2, width: w2, height: h2)
        self.layer2.cornerRadius = h2 * 0.5
        
        CATransaction.commit()
    }
}

extension AureolaView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        isAnimating = true
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            if self.isAnimating == true {
                return
            }
            self.isHidden = true
        }
        isAnimating = false
    }
}
