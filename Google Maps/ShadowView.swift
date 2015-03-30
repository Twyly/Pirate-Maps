//
//  ShadowView.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/30/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//


// Dependent on performance, might be worth shifting Shadow Logic into DrawRect to utilize CPU instead of GPU.
// This is an issue of drawing vs. composition

import UIKit

//enum ShadowViewShadowType {
//    case Strong
//    case Weak
//}


class ShadowView: UIView {
    
    //MARK: - Public API
//    var shadowType: ShadowViewShadowType = .Strong {
//        didSet {
//            applyShadow()
//        }
//    }
    
    var excludeEdges: UIRectEdge = .None {
        didSet {
            applyShadow()
        }
    }
    
    var cornerRadius: CGFloat = 1
    
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
        layer.rasterizationScale = UIScreen.mainScreen().scale
        layer.shouldRasterize = true;
        layer.masksToBounds = false
        contentMode = UIViewContentMode.Redraw
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow()
        roundCorners()
    }
    
    private func applyShadow() {
        
        // FIRST TRY
        let path = UIBezierPath()
        path.lineJoinStyle = kCGLineJoinRound
        
        // For the Rounded Corner effect
        //let a = cornerRadius/sqrt(2)
        
        path.moveToPoint(CGPointZero)
        let height = bounds.size.height
        let width = bounds.size.width
        let horizontalTidbit = width/50
        let verticalTidbit = height/50

        if excludeEdges & .Left != nil {
            path.addLineToPoint(CGPoint(x: 1/4*width, y: verticalTidbit))
            path.addLineToPoint(CGPoint(x: 1/4*width, y: height-verticalTidbit))
            path.addLineToPoint(CGPoint(x: 0, y: height))
        } else {
            path.addLineToPoint(CGPoint(x: 0, y: height))
        }
        
        if excludeEdges & .Bottom != nil {
            path.addLineToPoint(CGPoint(x: horizontalTidbit, y: height*3/4))
            path.addLineToPoint(CGPoint(x: width-horizontalTidbit, y: height*3/4))
            path.addLineToPoint(CGPoint(x: width, y: height))
        } else {
            path.addLineToPoint(CGPoint(x: width, y: height))
        }
        
        if excludeEdges & .Right != nil {
            path.addLineToPoint(CGPoint(x: 3/4*width, y: height-verticalTidbit))
            path.addLineToPoint(CGPoint(x: 3/4*width, y: verticalTidbit))
            path.addLineToPoint(CGPoint(x: width, y: 0))
        } else {
            path.addLineToPoint(CGPoint(x: width, y: 0))
        }
        if excludeEdges & .Top != nil {
            path.addLineToPoint(CGPoint(x: width-horizontalTidbit, y: height*1/4))
            path.addLineToPoint(CGPoint(x: horizontalTidbit, y: height*1/4))
            path.addLineToPoint(CGPoint(x: 0, y: 0))
        } else {
            path.addLineToPoint(CGPoint(x: 0, y: 0))
        }
        layer.shadowPath = path.CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSizeMake(0, 1)
    }
    
    private func roundCorners() {
        layer.cornerRadius = cornerRadius
    }
    

}
