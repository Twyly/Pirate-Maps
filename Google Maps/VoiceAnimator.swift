//
//  VoiceAnimator.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/20/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class VoiceAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool
    private let transitionDuration: NSTimeInterval = 0.6
    private var targetRect = CGRectZero
    
    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
    
    convenience init(presentFromRect: CGRect) {
        self.init(presenting: true)
        targetRect = presentFromRect
    }
    
    //MARK: - UIViewControllerAnimatedTransitioning
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let voiceViewController = !self.presenting ? fromVC as! VoiceViewController : toVC as! VoiceViewController
        let bottomViewController = !self.presenting ? toVC as UIViewController : fromVC as UIViewController
        let voiceView = voiceViewController.view
        let bottomView = bottomViewController.view
        
        container.addSubview(bottomView)
        container.layoutIfNeeded()
        
        if self.presenting {
            
            // Add Circle View
            let radius = sqrt((voiceView.bounds.size.width) * (voiceView.bounds.size.width) + (voiceView.bounds.size.height) * (voiceView.bounds.size.height))
            let circleLayer = configuredCircleLayer(bottomView)
            bottomView.layer.addSublayer(circleLayer)
            
            // Add Voice Button
            let voiceButton = VoiceButton.buttonWithType(.Custom) as! VoiceButton
            let voiceButtonLength = voiceViewController.voiceButtonWidth.constant;
            voiceButton.frame = CGRect(x: circleLayer.bounds.size.width, y: -voiceButtonLength, width: voiceButtonLength, height: voiceButtonLength)
            container.addSubview(voiceButton)
            
            let targetPoint = CGPoint(x: CGRectGetMidX(circleLayer.bounds) - voiceButtonLength/2, y: circleLayer.bounds.size.height - voiceViewController.voiceButtonToBottomConstraint.constant - voiceButtonLength)
            
            // Change Model Layer
            circleLayer.radius = radius
        
            let anim = radiusAnimation(true, duration: transitionDuration(transitionContext), radius: radius)
            
            
            // Documentation states that you are supposed to nest Core Animation animations inside UIView block based aniamtions.  However, that was not working in this case
            CATransaction.begin()
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: nil, animations: { () -> Void in
                voiceButton.frame = CGRect(origin: targetPoint, size: voiceButton.bounds.size)
                container.layoutIfNeeded()
                }, completion: { (success: Bool) -> Void in
                    //
            })
            CATransaction.setCompletionBlock({ () -> Void in
                container.addSubview(voiceView)
                circleLayer.removeFromSuperlayer()
                transitionContext.completeTransition(true)
            })
            circleLayer.addAnimation(anim, forKey: "radiusAnimation")
            CATransaction.commit()
            
        } else {
            
            let radius = sqrt((voiceView.bounds.size.width) * (voiceView.bounds.size.width) + (voiceView.bounds.size.height) * (voiceView.bounds.size.height))
            
            // Add Circle
            let circleLayer = CircleLayer(radius: radius)
            circleLayer.frame = bottomView.bounds
            circleLayer.circleCenter = voiceViewController.voiceButton.center
            circleLayer.fillColor = UIColor.whiteColor().CGColor
            circleLayer.shadow = Shadow(blur: 15, offset: CGSizeZero)
            bottomView.layer.addSublayer(circleLayer)
            
            // Add VoiceButton
            let voiceLayer = voiceViewController.voiceButton.layer
            voiceLayer.frame = voiceViewController.voiceButton.frame
            voiceLayer.backgroundColor = UIColor.whiteColor().CGColor
            circleLayer.addSublayer(voiceLayer)
            
            // Change Model Layer
            voiceLayer.opacity = 0
            circleLayer.radius = 0
            
            let radiusAnim = radiusAnimation(false, duration: transitionDuration(transitionContext), radius: radius)
            let opacityAnim = opacityAnimation(transitionDuration(transitionContext))

            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                circleLayer.removeFromSuperlayer()
                transitionContext.completeTransition(true)
                UIApplication.sharedApplication().keyWindow!.addSubview(toVC.view)
            })
            circleLayer.addAnimation(radiusAnim, forKey: "radiusAnimation")
            voiceLayer.addAnimation(opacityAnim, forKey: "voiceAnimation")
            CATransaction.commit()
        }
    }
    
    func radiusAnimation(presenting: Bool, duration: NSTimeInterval, radius: CGFloat) -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "radius")
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.duration = duration
        anim.fromValue = presenting ? 0 : radius
        anim.toValue = presenting ? radius : 0
        return anim
    }
    
    func opacityAnimation(duration: NSTimeInterval) -> CABasicAnimation {
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        opacityAnim.duration = duration
        opacityAnim.fromValue = 1
        opacityAnim.toValue = 0
        return opacityAnim
    }
    
    func configuredCircleLayer(bottomView: UIView) -> CircleLayer {
        let circleLayer = CircleLayer(radius: 0)
        circleLayer.frame = bottomView.bounds
        circleLayer.circleCenter = CGPoint(x: bottomView.bounds.size.width, y: 0)
        circleLayer.fillColor = UIColor.whiteColor().CGColor
        circleLayer.shadow = Shadow(blur: 15, offset: CGSize(width: -15, height: 15))
        return circleLayer
    }
    
    // Percent Complete Argument takes number from 0 to 1
    func offStageVoiceController(controller: VoiceViewController, dismissFromRect: CGRect) {
    }
    
    func onStageVoiceController(controller: VoiceViewController, displayFromRect: CGRect) {
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return transitionDuration
    }

   
}
