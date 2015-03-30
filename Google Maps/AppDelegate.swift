//
//  AppDelegate.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/6/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let iOSAPIKey = ThirdPartyKeys.googleAPIKey

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GMSServices.provideAPIKey(iOSAPIKey)
        return true
    }
    
    //MARK: Core Data - Currently Unused!
//    private class var storeURL: NSURL {
//        let docDirectory = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)!
//        return docDirectory.URLByAppendingPathComponent("db.sqlite")
//    }
//    
//    private class var modelURL: NSURL {
//        return NSBundle.mainBundle().URLForResource("Maps", withExtension: "momd")!
//    }
    
    //MARK: ActivityIndicator
    private var numberOfActivityCalls = 0
    internal func setNetworkActivityIndicatorVisable(visable: Bool) {
        if visable {
            numberOfActivityCalls++
        } else {
            numberOfActivityCalls--
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = numberOfActivityCalls > 0
    }
}

