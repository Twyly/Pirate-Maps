//
//  MapVCNavigationTests.swift
//  Google Maps
//
//  Created by Teddy Wyly on 2/18/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class MapVCNavigationTests: KIFTestCase {
    
    func testMenuSegueAndReturn() {
        tester().tapViewWithAccessibilityLabel("Menu Button")
        tester().waitForViewWithAccessibilityLabel("Profile Image");
        tester().tapViewWithAccessibilityLabel("Dimmer View")
        tester().waitForViewWithAccessibilityLabel("Map View");
    }
    
    func testVoiceSegueAndReturn() {
        tester().tapViewWithAccessibilityLabel("Voice Segue Button")
        tester().waitForViewWithAccessibilityLabel("Voice Button");
        tester().tapViewWithAccessibilityLabel("Close Button")
        tester().waitForViewWithAccessibilityLabel("Map View");
    }
   
}
