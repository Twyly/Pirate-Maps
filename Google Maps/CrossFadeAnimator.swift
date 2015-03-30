//
//  DropCellAnimator.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/21/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class CrossFadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool
    private let transitionDuration: NSTimeInterval = 0.5
    
    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let topViewController = !self.presenting ? fromVC as UIViewController : toVC as UIViewController
        let bottomViewController = !self.presenting ? toVC as UIViewController : fromVC as UIViewController
        
        let searchView = topViewController.view
        let bottomView = bottomViewController.view
        
        if (self.presenting){
            offStageContainerController(topViewController)
        }
        
        container.addSubview(bottomView)
        container.addSubview(searchView)
        container.layoutIfNeeded()
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            if self.presenting {
                self.onStageContainerController(topViewController)
            } else {
                self.offStageContainerController(topViewController)
            }
            container.layoutIfNeeded()
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.sharedApplication().keyWindow!.addSubview(toVC.view)
        }
    }
    
    
    func offStageContainerController(controller: UIViewController) {
        controller.view.alpha = 0
    }
    
    func onStageContainerController(controller: UIViewController) {
        controller.view.alpha = 1
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return transitionDuration
    }
}
