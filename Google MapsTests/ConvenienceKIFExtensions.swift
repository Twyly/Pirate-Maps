//
//  ConvenienceKIFExtensions.swift
//  Google Maps
//
//  Created by Teddy Wyly on 2/18/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import Foundation
import CoreLocation

extension XCTestCase {
    func tester(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
    
    func system(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}

extension KIFTestActor {
    func tester(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
    
    func system(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}

extension KIFUITestActor {
    func navigateToLoginPage() {
        //tapViewWithAccessibilityLabel("")
    }
    
    func confirmLocationAuthorizationStatus() {
        //CLLocationManager.setAuthorizationStatus(true, forBundleIdentifier:NSBundle.mainBundle().bundleIdentifier)
        //[CLLocationManager setAuthorizationStatus:YES forBundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]]
    }
}
