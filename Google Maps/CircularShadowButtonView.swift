//
//  CircularShadowButtonView.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/30/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class CircularShadowButtonView: UIView {
    
    
    //MARK: - Public API
    func addTarget(target: AnyObject?, action: Selector, forControlEvents: UIControlEvents) {
        button.addTarget(target, action: action, forControlEvents: forControlEvents)
    }
    
    let button = UIButton(frame: CGRectZero)
    
    //MARK: - Types
    
    private enum ShadowType {
        case Light
        case Heavy
    }
    
    //MARK: - Properties
    
    private var shadowType: ShadowType = .Light {
        didSet {
            //animateShadow()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        addSubview(button)
        button.clipsToBounds = true
        let options = NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old
        button.addObserver(self, forKeyPath: "highlighted", options: options, context: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
        button.layer.cornerRadius = bounds.size.width / 2
        layer.cornerRadius = bounds.size.width / 2
        applyShadow()
    }
    
    func applyShadow() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.width/2)
        layer.shadowPath = path.CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        switch(shadowType) {
        case .Heavy:
            layer.shadowOffset = CGSizeMake(0, 4)
            layer.shadowRadius = 2
            layer.shadowOpacity = 0.5
        case .Light:
            layer.shadowOffset = CGSizeMake(0, 2)
            layer.shadowRadius = 2
            layer.shadowOpacity = 0.4
        }

    }
    
    func animateShadow() {
        switch(shadowType) {
        case .Heavy:
            animatateShadow(layer, offset: CGSize(width: 0, height: 4), radius: 5, opacity: 0.4, duration: 1)
        case .Light:
            animatateShadow(layer, offset: CGSize(width: 0, height: 2), radius: 2, opacity: 0.4, duration: 1)
        }
    }
    
    
    func animatateShadow(layer: CALayer, offset: CGSize, radius: CGFloat, opacity: Float, duration: NSTimeInterval) {
        CATransaction.begin()
        CATransaction.setValue(duration, forKey: kCATransactionAnimationDuration)
//        let offsetAnim = CABasicAnimation(keyPath: "shadowOffset")
        let radAnim = CABasicAnimation(keyPath: "shadowRadius")
        let opacAnim = CABasicAnimation(keyPath: "shadowOpacity")
        
        radAnim.toValue = radius
        opacAnim.toValue = opacity
        
        layer.addAnimation(radAnim, forKey: "radiusAnimation")
        layer.addAnimation(opacAnim, forKey: "opacityAnimation")
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        CATransaction.commit()        
    }
    
    
    
    
    //MARK: - KVO Observing
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "highlighted" {
            shadowType = button.highlighted ? .Heavy : .Light
            animateShadow()
        }
    }

}
