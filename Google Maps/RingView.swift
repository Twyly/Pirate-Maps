//
//  RingView.swift
//  Google Maps
//
//  Created by Teddy Wyly on 3/18/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class RingView: UIView {
    
    //MARK: - Public API
    func shootPulse(duration: NSTimeInterval) {
        let pulseShapeLayer = CAShapeLayer()
        layer.addSublayer(pulseShapeLayer)
        configureRing(pulseShapeLayer)
        pulseShapeLayer.removeAllAnimations()
        CATransaction.begin()
        CATransaction.setCompletionBlock{
            pulseShapeLayer.removeFromSuperlayer()
        }
        pulseShapeLayer.addAnimation(pulseAnimation(duration, repeat: false), forKey: "pulse")
        CATransaction.commit()
    }
    
    func startPeriodicPulsing(duration: NSTimeInterval) {
        shapeLayer.removeAllAnimations()
        shapeLayer.addAnimation(pulseAnimation(duration, repeat: true), forKey: "pulse")
    }
    
    func stopPeriodicPulsing() {
        shapeLayer.removeAllAnimations()
    }
    
    //MARK: - Properties
    
    private func pulseAnimation(duration: NSTimeInterval, repeat: Bool) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.animations = [pathAnimation, alphaAnimation]
        group.duration = duration
        group.repeatCount = repeat ? Float.infinity : 1
        return group
    }
    
    private let shapeLayer = CAShapeLayer()
    
    
    private var pathAnimation: CABasicAnimation {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = initialPath.CGPath
        pathAnimation.toValue = targetPath.CGPath
        return pathAnimation
    }
    
    private var alphaAnimation: CABasicAnimation {
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        return alphaAnimation
    }
    
    private var initialPath: UIBezierPath {
        return UIBezierPath(ovalInRect: bounds)
    }
    
    private var targetPath: UIBezierPath {
        let radius = sqrt(bounds.width*bounds.width + bounds.height*bounds.height)
        return UIBezierPath(ovalInRect: CGRectInset(bounds, -2*radius, -2*radius))
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        layer.addSublayer(shapeLayer)
        backgroundColor = UIColor.clearColor()
        configureRing(shapeLayer)

    }
    
    private func configureRing(shapeLayer: CAShapeLayer) {
        shapeLayer.lineWidth = 8;
        shapeLayer.strokeColor = UIColor.groupTableViewBackgroundColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.path = initialPath.CGPath
    }



}


