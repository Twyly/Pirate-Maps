//
//  User.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/20/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class User: NSObject {
    
    init(name: String, email: String, profile: UIImage) {
        self.name = name
        self.email = email
        self.profileImage = profile
        self.backgroundImage = UIImage(named: "TeddyBackground.jpg")!
        super.init()
    }
    
    let profileImage: UIImage
    let backgroundImage: UIImage
    let name: String
    let email: String
   
}
