//
//  LoadingView.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/28/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    //MARK: - Public API
    func startAnimating() {
        if !isAnimating {
            hidden = false
            self.animateStroke(strokeStart: (0, 0.1), strokeEnd: (0.1, 0.9))
            spinnerLayer.addAnimation(rotationAnimation(), forKey: "Rotation")
            animationInProgress = true
        }
    }
    
    func stopAnimating() {
        hidden = true
        spinnerLayer.removeAllAnimations()
        count = 0
        animationInProgress = false
    }
    
    var isAnimating: Bool {
        return animationInProgress
    }
    
    let cycleDuration: NSTimeInterval = 1
    
    //MARK: - Internal
    private let spinnerLayer = CAShapeLayer()
    private let insets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    private var circlePath: UIBezierPath {
        let center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        let radius: CGFloat = max(bounds.size.width / 2 - insets.left - insets.right, bounds.size.height / 2 - insets.top - insets.bottom)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0) - tidbit * CGFloat(count), endAngle: CGFloat(2*M_PI) - tidbit * CGFloat(count), clockwise: true)
        path.lineJoinStyle = kCGLineJoinRound
        return path
    }
    private var animationInProgress = false
    
    let tidbit: CGFloat = CGFloat(2 * M_PI) / 10
    var count: Int = 0

    private func rotationAnimation() -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = M_PI * 2
        rotation.duration = 3.5
        rotation.repeatCount = MAXFLOAT
        return rotation
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
    
    private func setup() {
        spinnerLayer.path = circlePath.CGPath
        spinnerLayer.strokeColor = UIColor.lightGrayColor().CGColor
        spinnerLayer.fillColor = UIColor.clearColor().CGColor
        spinnerLayer.lineWidth = 2
        spinnerLayer.strokeColor = correctStrokeColor().CGColor
        layer.addSublayer(spinnerLayer)
        backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinnerLayer.frame = bounds
    }
    
    // The Length of the circular path at the two points of the animation
    // t = 0    Line = -
    // t = T/2  Line = --------
    struct PathLength {
        let beginning = (start: 0.1, end: 0.9)
        let end = (start: 0.9, end:1)
    }
    
    // Change ot block UIView
    private func animateStroke(strokeStart start: (from: CGFloat, to: CGFloat), strokeEnd end: (from: CGFloat, to: CGFloat)) {
        
        spinnerLayer.strokeStart = start.to
        spinnerLayer.strokeEnd = end.to
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(cycleDuration / 2)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        let tailAnimation = CABasicAnimation(keyPath: "strokeStart")
        tailAnimation.fromValue = start.from
        tailAnimation.toValue = start.to
        
        let headAnimation = CABasicAnimation(keyPath: "strokeEnd")
        headAnimation.fromValue = end.from
        headAnimation.toValue = end.to
       
        if start.from == 0 {
            spinnerLayer.path = circlePath.CGPath
            count++
            spinnerLayer.strokeColor = correctStrokeColor().CGColor
            CATransaction.setCompletionBlock({ () -> Void in
                self.setNeedsLayout()
                self.animateStroke(strokeStart: (0.1, 0.9), strokeEnd: (0.9, 1.0))
            })
        } else {
            CATransaction.setCompletionBlock({ () -> Void in
                self.setNeedsLayout()
                self.animateStroke(strokeStart: (0, 0.1), strokeEnd: (0.1, 0.9))
            })
        }
        spinnerLayer.addAnimation(tailAnimation, forKey: "strokeEndAnimation")
        spinnerLayer.addAnimation(headAnimation, forKey: "strokeStartAnimation")
        CATransaction.commit()
    }
    
    private func correctStrokeColor() -> UIColor {
        let colors = [UIColor.blueColor(), UIColor.redColor(), UIColor.yellowColor(), UIColor.greenColor()]
        let color = colors[count%colors.count]
        return color
    }

}
