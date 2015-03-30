//
//  CircleLayer.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/29/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

struct Shadow {
    let blur: CGFloat
    let offset: CGSize
}

class CircleLayer: CALayer {
    
    @NSManaged var radius: CGFloat
    var circleCenter: CGPoint = CGPointZero
    
    var fillColor = UIColor.groupTableViewBackgroundColor().colorWithAlphaComponent(0.3).CGColor
    var shadow: Shadow?
    
    class var radiusKey: String {
        return "radius"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init!(radius: CGFloat) {
        super.init()
        self.radius = radius
        setNeedsDisplay()
    }
    
    override init!(layer: AnyObject!) {
        super.init(layer: layer)
        let cLayer = layer as! CircleLayer
        self.radius = layer.radius
        self.circleCenter = layer.circleCenter
        self.fillColor = layer.fillColor
        if let shadow = cLayer.shadow {
            self.shadow = shadow
        }
    }
    
    override func drawInContext(ctx: CGContext!) {
        
        let origin = CGPoint(x: circleCenter.x - radius, y: circleCenter.y - radius)
        let rect = CGRect(origin: origin, size: CGSize(width: 2*radius, height: 2*radius))
        
        // Shadow
        if let shadow = shadow {
            CGContextSaveGState(ctx);
            CGContextSetShadow(ctx, shadow.offset, shadow.blur)
            CGContextAddEllipseInRect(ctx, rect)
            CGContextFillPath(ctx)
            CGContextRestoreGState(ctx);
        }
        
        // Background Circle
        let color = fillColor
        CGContextSetFillColorWithColor(ctx, color)
        CGContextAddEllipseInRect(ctx, rect)
        CGContextFillPath(ctx)
    }
    
    override class func needsDisplayForKey(key: String!) -> Bool {
        if key == radiusKey {
            return true
        } else {
            return super.needsDisplayForKey(key)
        }
    }
    
    override func actionForKey(event: String!) -> CAAction! {
        let key = CircleLayer.radiusKey
        if event == key {
           let anim = CABasicAnimation(keyPath: key)
            if let presLayer: AnyObject = presentationLayer() {
                anim.fromValue = presLayer.valueForKey(key)
                return anim
            } else {
                anim.fromValue = 0
                return anim
            }
        } else {
            return super.actionForKey(event)
        }
    }
    
    
}
