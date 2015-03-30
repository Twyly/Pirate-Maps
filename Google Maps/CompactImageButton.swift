//
//  CompactImageButton.swift
//  Google Maps
//
//  Created by Teddy Wyly on 3/18/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class CompactImageButton: UIButton {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override class func buttonWithType(buttonType: UIButtonType) -> AnyObject {
        let button: CompactImageButton = super.buttonWithType(buttonType) as! CompactImageButton
        button.setup()
        return button
    }

    func setup() {
        imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    }

}
