//
//  DirectionsTVC.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/26/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class DirectionsTVC: UITableViewController {
    
    //MARK: - Types
    struct MainStoryboard {
        struct CellIdentifiers {
            static let resultCell = "ResultCell"
        }
    }
    
    struct UIConstants {
        static let tableViewCellHeight: CGFloat = 56
        static let tableViewHeaderHeight: CGFloat = 12
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.resultCell, forIndexPath: indexPath) as! RoundedSectionShadowTableViewCell
        return cell
    }
    
    private func configureCell(cell: RoundedSectionShadowTableViewCell, path: NSIndexPath) {
        cell.prepareShadowsAndCorners(tableView, path: path)
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIConstants.tableViewCellHeight
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIConstants.tableViewHeaderHeight
    }


}
