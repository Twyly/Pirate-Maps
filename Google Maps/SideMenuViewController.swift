//
//  SideMenuViewController.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/6/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

protocol SideMenuViewControllerDelegate: class {
    func dismissSideMenuController(controller: SideMenuViewController)
    func panRecognized(controller: SideMenuViewController, sender: UIPanGestureRecognizer)
}


class SideMenuViewController: UIViewController {
    
    //MARK: - Types
    struct MainStoryboard {
        struct SegueIdentifiers {
            static let embedTVC = "embedTVC"
        }
    }
    
    //MARK: - Properties
    private let anyHeightWidthConstant: CGFloat = 275
    private let compactHeightWidthConstant: CGFloat = 400
    
    let leadingSpaceConstant: CGFloat = -16
    var panelWidth: CGFloat {
        return view.traitCollection.verticalSizeClass == .Compact ? compactHeightWidthConstant : anyHeightWidthConstant
    }

    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var widthAnyHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthCompactHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingSpaceToSuperviewConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: SideMenuHeaderView!
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    var menuTVC: SideMenuTVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setNeedsStatusBarAppearanceUpdate()
        
        let teddy = User(name: "Teddy Wyly", email: "wylynout@gmail.com", profile: UIImage(named: "TeddyProfile.jpg")!)
        headerView.configureWithUser(teddy)
        
        widthAnyHeightConstraint.constant = anyHeightWidthConstant
        widthCompactHeightConstraint.constant = compactHeightWidthConstant
        
    }
    

    //MARK: - IBActions
    @IBAction func tapGestureRecognized(sender: UITapGestureRecognizer) {
        self.delegate?.dismissSideMenuController(self)
    }
    
    @IBAction func arrowButtonPressed(sender: UIButton) {
        
        if let menuTVC = self.menuTVC {
            
            menuTVC.listShowing = !menuTVC.listShowing
            
            //menuTVC.tableView.reloadData()
            menuTVC.reloadTableView()
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: nil, animations: {
                
                if menuTVC.listShowing {
                    sender.transform = CGAffineTransformIdentity
                } else {
                    sender.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                }
                
                }, completion: { finished in
            })
        }
        

    }
    
    @IBAction func panGestureRecognized(sender: UIPanGestureRecognizer) {
        delegate?.panRecognized(self, sender: sender)
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MainStoryboard.SegueIdentifiers.embedTVC {
            let targetVC = segue.destinationViewController as! SideMenuTVC
            menuTVC = targetVC
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
