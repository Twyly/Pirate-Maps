//
//  DirectionsViewController.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/26/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController {
    
    //MARK: - Types
    struct UIConstants {
        static let swapAnimationDuration: NSTimeInterval = 0.5
        static let inactiveAlpha: CGFloat = 0.7
        
        static let firstLabelText = "Your location"
        static let secondLabelText = "Choose destination..."
    }
    
    //MARK: - Properties
    @IBOutlet weak var firstSwapView: UIView!
    @IBOutlet weak var secondSwapView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var dotsImageView: UIImageView!
    
    // Argument could be made for outlet collection, but might be more trouble than its worth
    @IBOutlet weak var boatOneButton: UIButton!
    @IBOutlet weak var boatTwoButton: UIButton!
    @IBOutlet weak var boatThreeButton: UIButton!
    @IBOutlet weak var swimButton: UIButton!
    private var firstSwapViewOnTop = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }
    
    func setupViews() {
        topView.backgroundColor = UIColor.applicationColor()
        firstSwapView.backgroundColor = UIColor.clearColor()
        secondSwapView.backgroundColor = UIColor.clearColor()
        setTravelButtonsActive(false)
        setButtonActive(boatOneButton, active: true)
        setAccessoryViewsWithCorrectAlpha()
        firstLabel.text = UIConstants.firstLabelText
        secondLabel.text = UIConstants.secondLabelText
    }
    
    //MARK: - IBActions
    @IBAction func backButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func firstTravelOptionButtonPressed(sender: UIButton) {
        setTravelButtonsActive(false)
        setButtonActive(sender, active: true)
    }
    
    @IBAction func secondTravelOptionButtonPressed(sender: UIButton) {
        setTravelButtonsActive(false)
        setButtonActive(sender, active: true)
    }
    
    @IBAction func thirdTravelOptionButtonPressed(sender: UIButton) {
        setTravelButtonsActive(false)
        setButtonActive(sender, active: true)
    }
    

    @IBAction func fourthTravelOptionButtonPressed(sender: UIButton) {
        setTravelButtonsActive(false)
        setButtonActive(sender, active: true)
    }
    
    func setButtonActive(button: UIButton, active: Bool) {
        button.alpha = active ? 1.0 : UIConstants.inactiveAlpha
    }
    
    func setTravelButtonsActive(active: Bool) {
        setButtonActive(boatOneButton, active: active)
        setButtonActive(boatTwoButton, active: active)
        setButtonActive(boatThreeButton, active: active)
        setButtonActive(swimButton, active: active)
    }
    
    func setAccessoryViewsWithCorrectAlpha() {
        seperatorView.alpha = UIConstants.inactiveAlpha
        swapButton.alpha = UIConstants.inactiveAlpha
        dotsImageView.alpha = UIConstants.inactiveAlpha
    }


    @IBAction func swapButtonPressed(sender: UIButton) {
        
        let transform = firstSwapViewOnTop ? CGAffineTransformMakeRotation(CGFloat(M_PI)) : CGAffineTransformIdentity
        let firstTarget = secondSwapView.frame
        let secondTarget = firstSwapView.frame
        
        UIView.animateWithDuration(UIConstants.swapAnimationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            sender.transform = transform
            self.firstSwapView.frame = firstTarget
            self.secondSwapView.frame = secondTarget
            }) { (finished: Bool) -> Void in
            self.firstSwapViewOnTop = !self.firstSwapViewOnTop
        }
        
    }
    
    //MARK: - Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

}
