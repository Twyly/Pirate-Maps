//
//  ConvenienceExtensions.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/20/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

extension UIFont {
    class func applicationFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "Arial", size: size)
    }
    
    class func applicationBoldFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "Arial Rounded MT Bold", size: size)
    }
}

extension UIColor {
    class func applicationColor() -> UIColor {
        return UIColor.applicationBlueColor()
    }
    
    class func applicationDarkGrayColor() -> UIColor {
        return UIColor.darkTextColor()
    }
    
    class func appliactionLightGrayColor() -> UIColor {
        return UIColor.lightTextColor()
    }
    
    private class func applicationBlueColor() -> UIColor {
        return UIColor(red: 0.26, green: 0.48, blue: 0.97, alpha: 1.0)
    }
}

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}

//MARK: - GlobalFunctions - Obviously Very Careful Here

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
