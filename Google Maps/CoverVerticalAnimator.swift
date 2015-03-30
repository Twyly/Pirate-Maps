//
//  CoverVerticalAnimator.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/26/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class CoverVerticalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool
    private let transitionDuration: NSTimeInterval = 0.4
    
    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let topViewController = !self.presenting ? fromVC as UIViewController : toVC as UIViewController
        let bottomViewController = !self.presenting ? toVC as! MapViewController : fromVC as! MapViewController
        
        let topView = topViewController.view
        let bottomView = bottomViewController.view
        
        if (self.presenting){
            offStageTopController(topViewController)
        }
        
        container.addSubview(bottomView)
        container.addSubview(topView)
        
        container.layoutIfNeeded()
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            
            if self.presenting {
                self.onStageTopController(topViewController)
                self.offStageOfMapController(bottomViewController)
            } else {
                self.offStageTopController(topViewController)
                self.onStageMapController(bottomViewController)
            }
            container.layoutIfNeeded()
            
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.sharedApplication().keyWindow!.addSubview(toVC.view)
        }
        
    }
    
    
    func offStageTopController(controller: UIViewController) {
        var frame = controller.view.frame
        frame.origin.y += frame.size.height
        controller.view.frame = frame
    }
    
    func onStageTopController(controller: UIViewController) {
        var frame = controller.view.frame
        frame.origin.y -= frame.size.height
        controller.view.frame = frame
    }
    
    func offStageOfMapController(controller: MapViewController) {
        var frame = controller.mapSearchView.frame
        frame.origin.y -= frame.size.height + 10
        controller.mapSearchView.frame = frame
    }
    
    func onStageMapController(controller: MapViewController) {
        var frame = controller.mapSearchView.frame
        frame.origin.y += frame.size.height + 10
        controller.mapSearchView.frame = frame
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return transitionDuration
    }
   
}
