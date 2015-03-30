//
//  PulsingVoiceView.swift
//  Google Maps
//
//  Created by Teddy Wyly on 3/19/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class PulsingVoiceView: UIView {
    
    // MARK: - PUBLIC API
    
    // Intensity should be a number between 0 and 1
    func pulsate(var intensity: Float) {
        if (intensity < 0.0) {
            intensity = 0.0
        } else if (intensity > 1.0) {
            intensity = 1.0
        }
        circleLayer.path = path(CGFloat(intensity)).CGPath
        circleLayer.addAnimation(pathAnimation(CGFloat(self.intensity), to: CGFloat(intensity)), forKey: "pulse")
        self.intensity = intensity
    }
    
    func beginFluctuations(interval: NSTimeInterval) {
        fluxTimer = nil
        fluxTimer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "fluxIntensity:", userInfo: nil, repeats: true)
    }
    
    func endFluctuations() {
        fluxTimer?.invalidate()
        fluxTimer = nil
    }
    
    func fluxIntensity(timer: NSTimer) {
        let random: Float = Float(arc4random_uniform(11))
        let flux = (random - 5) / 100;
        let newIntensity = flux + intensity
        println("New Iten \(newIntensity)")
        pulsate(newIntensity)
    }

    
    private let circleLayer = CAShapeLayer()
    private var intensity: Float = 0.0
    weak private var fluxTimer: NSTimer?
    
    private func path(intensity: CGFloat) -> UIBezierPath {
        let radius = sqrt(bounds.width*bounds.width + bounds.height*bounds.height)
        return UIBezierPath(ovalInRect: CGRectInset(bounds, -intensity*radius, -intensity*radius))
    }
    
    private func pathAnimation(from: CGFloat, to: CGFloat) -> CABasicAnimation {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = path(from).CGPath
        pathAnimation.toValue = path(to).CGPath
        pathAnimation.duration = 0.02
        return pathAnimation
    }

    //MARK: - Lifecycle
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
        layer.addSublayer(circleLayer)
        backgroundColor = UIColor.clearColor()
        circleLayer.fillColor = UIColor.groupTableViewBackgroundColor().colorWithAlphaComponent(0.5).CGColor
        circleLayer.path = path(0.0).CGPath
    }
    


}
