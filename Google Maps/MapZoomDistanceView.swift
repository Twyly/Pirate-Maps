//
//  MapZoomDistanceView.swift
//  Google Maps
//
//  Created by Teddy Wyly on 2/6/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class MapZoomDistanceView: UIView {

    
    var metersPerPoint: Double = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //MARK: - Properties
    
    //private let americanIntervals = []
    
    var feet: Float = 10
    var meters: Float = 10
    
    var currentMetricInterval: Float = 10
    var currentUSInterval: Float = 10
    
    //MARK: - Drawing
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 2
        UIColor.blackColor().setStroke()

        let y = bounds.size.height/2
        
//        path.moveToPoint(CGPoint(x: bounds.size.width, y: y))
//        let xEnd: CGFloat = CGFloat(zoom)
//        path.addLineToPoint(CGPoint(x: xEnd, y: y))
        path.moveToPoint(CGPoint(x: 0, y: y))
        let xEnd: CGFloat = CGFloat(metersPerPoint/21.0) * bounds.size.width
        path.addLineToPoint(CGPoint(x: xEnd, y: y))
        println("Drawing to end: \(xEnd)")
        
        path.stroke()
        drawLabels()
    }
    
    func drawLabels() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Right
        
        var font = UIFont.applicationFont(10)
        //font = font?.fontWithSize(font?.pointSize * //Scale Factor)
        
        let feetText = "\(currentUSInterval) ft"
        let metersText = "\(currentMetricInterval) m"
        
        let attributes: [String : AnyObject!] = [NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle]
        let usAttributedText = NSAttributedString(string: feetText, attributes: attributes)
        let metricAttributedText = NSAttributedString(string: metersText, attributes: attributes)
        
        let maxWidth = max(usAttributedText.size().width, metricAttributedText.size().width)
        let origin = CGPoint(x: 0, y: bounds.size.width - maxWidth)
        let size = CGSize(width: maxWidth, height: bounds.size.height/2)
    
        let usTextRect = CGRect(origin: origin, size: size)
        usAttributedText.drawInRect(usTextRect)
        
    }
    
    //MARK: - LifeCycle
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
        backgroundColor = nil
        opaque = false
        contentMode = .Redraw
    }

}
