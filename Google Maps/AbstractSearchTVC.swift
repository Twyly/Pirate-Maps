//
//  AbstractSearchTVC.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/30/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

protocol AbstractSearchTVCDelegate: class {
    func searchTVCDidScroll(controller: AbstractSearchTVC, scrollView: UIScrollView)
    func searchTVCFinishedAnimatedCellDispaly(controller: AbstractSearchTVC)
    func searchTVCDidSelectPlace(controller: AbstractSearchTVC, place: Place)
    func searchTVCDidSelectService(controller: AbstractSearchTVC, service: Service)
}

class AbstractSearchTVC: UITableViewController {
    
    //MARK: - Public API
    weak var delegate: AbstractSearchTVCDelegate?
    var firstFetchPerformed: Bool = false

    func withdrawVisableCells(completion: (() -> ())) {
        let cells = tableView.visibleCells() as! [UITableViewCell]
        UIView.animateWithDuration(UIConstants.cellDropDuration, animations: { () -> Void in
            for cell in cells {
                cell.transform = self.offStageTransform(cell)
            }
            }, completion: { (finished: Bool) -> Void in
                completion()
        })
    }
    
    internal func reloadDataWithPossibleAnimation() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        firstFetchPerformed = true
    }
    
    //MARK: - Types
    struct UIConstants {
        static let cellDropDuration: NSTimeInterval = 0.3
        static let topContentInset: CGFloat = 1
        static let tableViewSectionHieght: CGFloat = 8
        static let tableViewCellHieght: CGFloat = 56
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: UIConstants.topContentInset, left: 0, bottom: 0, right: 0)
    }

    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !firstFetchPerformed {
            cell.transform = offStageTransform(cell)
            UIView.animateWithDuration(UIConstants.cellDropDuration, animations: { () -> Void in
                cell.transform = CGAffineTransformIdentity
                }, completion: { (finished: Bool) -> Void in
                    println("")
                    self.delegate?.searchTVCFinishedAnimatedCellDispaly(self)
            })
        }
    }
    
    private func offStageTransform(cell: UITableViewCell) -> CGAffineTransform {
        let safetyMargin: CGFloat = 10
        let offStage = CGAffineTransformMakeTranslation(0, -(cell.frame.origin.y + cell.frame.size.height + safetyMargin))
        return offStage
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIConstants.tableViewCellHieght
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UIConstants.topContentInset
        } else {
            return UIConstants.tableViewSectionHieght
        }
    }
    
    //MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.searchTVCDidScroll(self, scrollView: scrollView)
    }

}
