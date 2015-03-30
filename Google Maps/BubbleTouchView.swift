//
//  BubbleTouchView.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/29/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

protocol BubbleTouchViewDelegate: class {
    func touchUpRecognizedOnBubbleView(view: BubbleTouchView)
}

class BubbleTouchView: UIView {
    
    private let circleLayer = CircleLayer(radius: 0)
    private var touchDownPoint: CGPoint?
    
    weak var delegate: BubbleTouchViewDelegate?

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
        circleLayer.masksToBounds = true
        layer.addSublayer(circleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = bounds
    }
    
    //MARK: - Touches
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            let point = touch.locationInView(self)
            touchDownPoint = point
            println("Touch at \(touchDownPoint)")
            animateBubble(point)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            let p1 = touch.locationInView(self)
            if let p2 = touchDownPoint {
                let distance = hypot(p1.x - p2.x, p1.y - p2.y)
                if distance < 15 {
                    delegate?.touchUpRecognizedOnBubbleView(self)
                }
            }
        }
        touchDownPoint = nil
    }
    
    func animateBubble(point: CGPoint) {
        circleLayer.circleCenter = point
        let anim = CABasicAnimation(keyPath: "radius")
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.duration = 0.5
        anim.fromValue = 0
        anim.toValue = circleLayer.bounds.size.width / 2
        circleLayer.addAnimation(anim, forKey: "radiusAnimation")
    }

}
