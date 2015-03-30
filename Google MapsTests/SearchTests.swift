//
//  SearchTests.swift
//  Google Maps
//
//  Created by Teddy Wyly on 3/17/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class SearchTests: KIFTestCase {
    
    func testSuccessfulSearch() {
        tester().tapViewWithAccessibilityLabel("Title View")
        tester().waitForViewWithAccessibilityLabel("Search View");
        tester().enterText("new york", intoViewWithAccessibilityLabel: "Search View")
        tester().waitForCellAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), inTableViewWithAccessibilityIdentifier: "Search Table View")
        tester().tapRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), inTableViewWithAccessibilityIdentifier: "Search Table View")
        tester().waitForViewWithAccessibilityLabel("Map View");
    }
   
}
