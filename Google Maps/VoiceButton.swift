//
//  VoiceButton.swift
//  Google Maps
//
//  Created by Teddy Wyly on 3/19/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class VoiceButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override class func buttonWithType(buttonType: UIButtonType) -> AnyObject {
        let button: VoiceButton = super.buttonWithType(buttonType) as! VoiceButton
        button.setup()
        return button
    }
    
    func setup() {
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.blackColor().CGColor
        setImage(UIImage(named: "parrot.png"), forState: .Normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2
    }

}
