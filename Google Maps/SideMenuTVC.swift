//
//  SideMenuTVC.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/20/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class SideMenuTVC: UITableViewController {
    
    var listShowing: Bool = true
    var shouldAnimateCellsAppearance: Bool = true
    
    //MARK: - Types
    struct MainStoryboard {
        struct CellIdentifiers {
            static let menuCell = "MenuCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
         
    struct CellItem {
        let title: String
        let image: String?
    }
    
    struct TableViewSections {
        struct FirstTableView {
            static let firstSectionItems = [CellItem(title: "Your places", image: "anchor.png"), CellItem(title: "Explore nearby", image: "compass.png")]
            static let secondSectionItems = [CellItem(title: "Traffic", image: "fish.png"), CellItem(title: "Public Transit", image: "hat.png"), CellItem(title: "Biking", image: "money.png"), CellItem(title: "Satellite", image: "parascope.png"), CellItem(title: "Terrain", image: "pirate.png"), CellItem(title: "Google Earth", image: "ship.png")]
            static let thirdSetionItems = [CellItem(title: "Settings", image: nil), CellItem(title: "Help & Feedback", image: nil), CellItem(title: "Tips and Tricks", image: nil)]
        }
        struct SecondTableView {
            static let firstSectionItems = [CellItem(title: "Manage accounts", image: "wheel.png")]
        }

    }
    
    //MARK: - Public API
    
    func reloadTableView() {
        shouldAnimateCellsAppearance = true
        let transition = CATransition()
        transition.type = kCATransitionFade;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.fillMode = kCAFillModeForwards;
        transition.duration = 0.3;
        transition.removedOnCompletion = true
        transition.delegate = self
        tableView.layer.addAnimation(transition, forKey: "UITableViewReloadDataAnimationKey")
        tableView.reloadData()
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        println("Animation stopped")
        shouldAnimateCellsAppearance = false
    }
    

    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if listShowing {
            return 3
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listShowing {
            return cellItemsForSection(section).count
        } else {
            return 1
        }
    }
    
    func cellItemsForSection(section: Int) -> [CellItem] {
        if listShowing {
            switch section {
            case 0:
                return TableViewSections.FirstTableView.firstSectionItems
            case 1:
                return TableViewSections.FirstTableView.secondSectionItems
            case 2:
                return TableViewSections.FirstTableView.thirdSetionItems
            default:
                return []
            }
        } else {
            return TableViewSections.SecondTableView.firstSectionItems
        }

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.menuCell, forIndexPath: indexPath) as! SideMenuTableViewCell
        configureCell(cell, path: indexPath)
        return cell
    }
    
    func configureCell(cell: SideMenuTableViewCell, path: NSIndexPath) {
        let item = cellItemsForSection(path.section)[path.row]
        cell.majorLabel?.font = UIFont.applicationFont(15)
        cell.majorLabel?.text = item.title
        if let image = item.image {
            cell.iconImageView?.image = UIImage(named: image)
            cell.imageViewWidthConstraint.constant = 30
        } else {
            cell.iconImageView?.image = nil
            cell.imageViewWidthConstraint.constant = 0
        }
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 1))
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return view
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if shouldAnimateCellsAppearance {
            cell.transform = offStageTransform(cell)
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                cell.transform = CGAffineTransformIdentity
                }, completion: { (finished: Bool) -> Void in
            })
        }
    }
    
    func offStageTransform(cell: UITableViewCell) -> CGAffineTransform {
        if listShowing {
            let offStage = CGAffineTransformMakeTranslation(0, 1.2 * cell.frame.origin.y)
            return offStage
        } else {
            let offStage = CGAffineTransformMakeTranslation(0, -(cell.frame.origin.y + cell.frame.size.height))
            return offStage
        }

    }
    
    //MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        shouldAnimateCellsAppearance = false
    }

}
