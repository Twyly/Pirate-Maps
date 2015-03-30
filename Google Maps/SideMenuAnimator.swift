//
//  SideMenuAnimator.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/19/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class SideMenuAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning {
    
    var presenting: Bool
    private let transitionDuration: NSTimeInterval = 0.3
    private let dimmerAlpha: CGFloat = 0.5
    private var context: UIViewControllerContextTransitioning?
    
    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
        
    //MARK: - UIViewControllerAnimatedTransitioning
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let menuViewController = !self.presenting ? fromVC as! SideMenuViewController : toVC as! SideMenuViewController
        let bottomViewController = !self.presenting ? toVC as UIViewController : fromVC as UIViewController
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
        
        if (self.presenting){
            self.offStageMenuController(menuViewController, percentComplete: 1)
        }
        
        container.addSubview(bottomView)
        container.addSubview(menuView)
        
        container.layoutIfNeeded()
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            if (self.presenting){
                self.onStageMenuController(menuViewController, percentComplete: 1) // onstage items: slide in
            }
            else {
                self.offStageMenuController(menuViewController, percentComplete: 1) // offstage items: slide out
            }
            
            container.layoutIfNeeded()
            
            }) { (finished: Bool) -> Void in
            transitionContext.completeTransition(true)
            // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
            UIApplication.sharedApplication().keyWindow!.addSubview(toVC.view)
        }
        
    }
    
    // Percent Complete Argument takes number from 0 to 1
    func offStageMenuController(controller: SideMenuViewController, percentComplete: CGFloat) {
        controller.view.backgroundColor = UIColor(white: 0, alpha: dimmerAlpha * (1 - percentComplete))
        controller.leadingSpaceToSuperviewConstraint.constant = controller.leadingSpaceConstant - controller.panelWidth * percentComplete
    }
    
    func onStageMenuController(controller: SideMenuViewController, percentComplete: CGFloat) {
        controller.view.backgroundColor = UIColor(white: 0, alpha: dimmerAlpha * percentComplete)
        
        controller.leadingSpaceToSuperviewConstraint.constant = controller.leadingSpaceConstant - controller.panelWidth * (1 - percentComplete)
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return transitionDuration
    }
    
    func animationEnded(transitionCompleted: Bool) {
        context = nil
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    //MARK: - UIViewControllerInteractiveTransitioning
    
    override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        context = transitionContext
        
        let container = transitionContext.containerView()
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let menuViewController = !self.presenting ? fromVC as! SideMenuViewController : toVC as! SideMenuViewController
        let bottomViewController = !self.presenting ? toVC as UIViewController : fromVC as UIViewController
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
        
        if (self.presenting){
            self.offStageMenuController(menuViewController, percentComplete: 1)
        }
        
        container.addSubview(bottomView)
        container.addSubview(menuView)
        
        container.layoutIfNeeded()
        
    }
    
    //MARK: - UIPercentDrivenInteractiveTransitionOverride Methods
    override func updateInteractiveTransition(percentComplete: CGFloat) {
        super.updateInteractiveTransition(percentComplete)
        if let transitionContext = context {
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            
            let menuViewController = !self.presenting ? fromVC as! SideMenuViewController : toVC as! SideMenuViewController
            let bottomViewController = !self.presenting ? toVC as UIViewController : fromVC as UIViewController
            
            if (presenting) {
                onStageMenuController(menuViewController, percentComplete: percentComplete)
            } else {
                offStageMenuController(menuViewController, percentComplete: percentComplete)
            }
        }
    }
        
    override func finishInteractiveTransition() {
        
        super.finishInteractiveTransition()
        if let transitionContext = context {
            
            let container = transitionContext.containerView()
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            
            container.layoutIfNeeded()

            let duration = NSTimeInterval(1 - percentComplete) * transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
                let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
                
                let menuViewController = !self.presenting ? fromVC as! SideMenuViewController : toVC as! SideMenuViewController
                let bottomViewController = !self.presenting ? toVC as UIViewController : fromVC as UIViewController
                
                if self.presenting {
                    self.onStageMenuController(menuViewController, percentComplete: 1) // onstage items: slide in
                }
                else {
                    self.offStageMenuController(menuViewController, percentComplete: 1) // offstage items: slide out
                }
                container.layoutIfNeeded()
                
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                    UIApplication.sharedApplication().keyWindow!.addSubview(toVC.view)
            }
        }
    }
    
    
    override func cancelInteractiveTransition() {
        super.cancelInteractiveTransition()
        
        if let transitionContext = context {
            
            let container = transitionContext.containerView()
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            
            container.layoutIfNeeded()
            
            let duration = NSTimeInterval(percentComplete) * transitionDuration(transitionContext)

            UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
                let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
                
                let menuViewController = !self.presenting ? fromVC as! SideMenuViewController : toVC as! SideMenuViewController
                let bottomViewController = !self.presenting ? toVC as UIViewController : fromVC as UIViewController
                
                if self.presenting {
                    self.offStageMenuController(menuViewController, percentComplete: 1) // offstage items: slide out
                }
                else {
                    self.onStageMenuController(menuViewController, percentComplete: 1) // onstage items: slide in
                }
                container.layoutIfNeeded()
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(false)
                    // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                    UIApplication.sharedApplication().keyWindow!.addSubview(fromVC.view)
            }
        }
    }
}
